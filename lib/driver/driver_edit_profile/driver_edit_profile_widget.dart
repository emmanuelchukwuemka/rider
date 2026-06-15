import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '/backend/backend.dart';
import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/custom_auth/auth_util.dart';
import 'driver_edit_profile_model.dart';
export 'driver_edit_profile_model.dart';

class DriverEditProfileWidget extends StatefulWidget {
  const DriverEditProfileWidget({super.key});

  static String routeName = 'DriverEditProfile';
  static String routePath = '/driverEditProfile';

  @override
  State<DriverEditProfileWidget> createState() =>
      _DriverEditProfileWidgetState();
}

class _DriverEditProfileWidgetState extends State<DriverEditProfileWidget> {
  late DriverEditProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _driverId;
  String? _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DriverEditProfileModel());
    _model.nameController ??= TextEditingController();
    _model.phoneController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _model.isDataUploading = true);
    final url = await uploadProfileImage(image.path);
    if (url != null && mounted) {
      setState(() {
        _model.uploadedFileUrl = url;
        _currentPhotoUrl =
            url.startsWith('http') ? url : '$baseUrl$url';
      });
    }
    if (mounted) setState(() => _model.isDataUploading = false);
  }

  Future<void> _saveChanges() async {
    if (_driverId == null) return;
    setState(() => _model.isDataUploading = true);

    final updates = <String, dynamic>{
      'display_name': _model.nameController!.text.trim(),
      'phone_number': _model.phoneController!.text.trim(),
    };
    if (_model.uploadedFileUrl.isNotEmpty) {
      updates['photo_url'] = _model.uploadedFileUrl;
    }

    final success = await updateDriverProfile(_driverId!, updates);
    if (mounted) setState(() => _model.isDataUploading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? 'Profile updated successfully!'
          : 'Failed to update profile'),
      backgroundColor: success ? const Color(0xFF16A34A) : Colors.red,
    ));
    if (success) Navigator.of(context).pop();
  }

  void _showEditSheet(BuildContext context, UserDriverRecord driver) {
    final theme = FlutterFlowTheme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.alternate,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.inter(
                      color: theme.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Avatar picker
                  Center(
                    child: GestureDetector(
                      onTap: _pickAndUploadPhoto,
                      child: Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [theme.primary, theme.secondary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(2.5),
                            child: ClipOval(
                              child: _currentPhotoUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: _currentPhotoUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: theme.primary10,
                                      child: Icon(Icons.person_rounded,
                                          color: theme.primaryText, size: 40),
                                    ),
                            ),
                          ),
                          if (_model.isDataUploading)
                            Positioned.fill(
                              child: ClipOval(
                                child: Container(
                                  color: Colors.black38,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: theme.primaryBackground, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _inputField(
                    controller: _model.nameController!,
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: _model.phoneController!,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _model.isDataUploading ? null : _saveChanges,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _model.isDataUploading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              'Save Changes',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required FlutterFlowTheme theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: theme.primaryText, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            GoogleFonts.inter(color: theme.secondaryText, fontSize: 14),
        prefixIcon: Icon(icon, color: theme.secondaryText, size: 20),
        filled: true,
        fillColor: theme.secondaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primary, width: 1.5),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.primaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Sign Out',
          style: GoogleFonts.inter(
              color: theme.primaryText, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.inter(color: theme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: theme.secondaryText)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authManagerSignOut();
              if (context.mounted) {
                context.pushReplacementNamed('SplashScreen');
              }
            },
            child: Text('Sign Out',
                style: GoogleFonts.inter(
                    color: const Color(0xFFDC2626),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserDriverRecord>>(
      stream: queryCurrentDriverRecord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                    FlutterFlowTheme.of(context).primary),
              ),
            ),
          );
        }

        final driver =
            snapshot.data!.isNotEmpty ? snapshot.data!.first : null;

        if (driver == null) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: const Center(child: Text('Profile not found')),
          );
        }

        // Initialise once
        if (_driverId == null) {
          _driverId = driver.reference.id;
          _model.nameController?.text = driver.displayName;
          _model.phoneController?.text = driver.phoneNumber;
          _currentPhotoUrl = driver.photoUrl.isNotEmpty
              ? (driver.photoUrl.startsWith('http')
                  ? driver.photoUrl
                  : '$baseUrl${driver.photoUrl}')
              : null;
        }

        final theme = FlutterFlowTheme.of(context);
        final firstName = driver.displayName.split(' ').first;
        final rating =
            driver.driverRating?.toStringAsFixed(1) ?? '5.0';
        final totalTrips = driver.totalTrips ?? 0;

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: theme.primaryBackground,
            body: CustomScrollView(
              slivers: [
                // ── Profile header ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primary,
                          theme.primary.withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                        child: Column(
                          children: [
                            // Back button row
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.arrow_back_rounded,
                                        color: Colors.white,
                                        size: 20),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'My Profile',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 38),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _currentPhotoUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: _currentPhotoUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) =>
                                                Container(
                                              color: Colors.white24,
                                              child: Icon(
                                                Icons.person_rounded,
                                                color: Colors.white,
                                                size: 48,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.white24,
                                            child: Icon(
                                              Icons.person_rounded,
                                              color: Colors.white,
                                              size: 48,
                                            ),
                                          ),
                                  ),
                                ),
                                // Verified badge
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              driver.displayName,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              driver.email,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Stats row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _headerStat('★ $rating', 'Rating'),
                                _headerDivider(),
                                _headerStat('$totalTrips', 'Total Trips'),
                                _headerDivider(),
                                _headerStat(
                                    driver.isActive == true
                                        ? 'Active'
                                        : 'Inactive',
                                    'Status'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Menu sections ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Account section
                        _sectionLabel('Account', theme),
                        const SizedBox(height: 8),
                        _menuCard(theme, [
                          _MenuItem(
                            icon: Icons.edit_rounded,
                            iconColor: theme.primary,
                            label: 'Edit Profile',
                            subtitle: 'Update name, photo, phone',
                            onTap: () =>
                                _showEditSheet(context, driver),
                          ),
                          _MenuItem(
                            icon: Icons.directions_car_rounded,
                            iconColor: theme.primary,
                            label: 'Vehicle Info',
                            subtitle: 'Manage your vehicle details',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.description_rounded,
                            iconColor: theme.primary,
                            label: 'My Documents',
                            subtitle: 'License, insurance, registration',
                            onTap: () => context
                                .pushNamed('DriverDocumentUpload1'),
                            isLast: true,
                          ),
                        ]),
                        const SizedBox(height: 20),

                        // Earnings & Rides section
                        _sectionLabel('Earnings & Rides', theme),
                        const SizedBox(height: 8),
                        _menuCard(theme, [
                          _MenuItem(
                            icon: Icons.payments_rounded,
                            iconColor: theme.primary,
                            label: 'Payment & Wallet',
                            subtitle: 'Balance, payout methods',
                            onTap: () => context.pushNamed('DPayment'),
                          ),
                          _MenuItem(
                            icon: Icons.history_rounded,
                            iconColor: theme.primary,
                            label: 'Ride History',
                            subtitle: 'Past trips and receipts',
                            onTap: () =>
                                context.pushNamed('DRideHistory'),
                          ),
                          _MenuItem(
                            icon: Icons.calendar_month_rounded,
                            iconColor: theme.primary,
                            label: 'Scheduled Rides',
                            subtitle: 'Upcoming bookings',
                            onTap: () =>
                                context.pushNamed('DScheduledRides'),
                            isLast: true,
                          ),
                        ]),
                        const SizedBox(height: 20),

                        // Preferences section
                        _sectionLabel('Preferences', theme),
                        const SizedBox(height: 8),
                        _menuCard(theme, [
                          _MenuItem(
                            icon: Icons.settings_rounded,
                            iconColor: theme.primary,
                            label: 'Settings',
                            subtitle: 'Notifications, privacy, more',
                            onTap: () => context.pushNamed('DSettings'),
                          ),
                          _MenuItem(
                            icon: Icons.notifications_rounded,
                            iconColor: theme.primary,
                            label: 'Notifications',
                            subtitle: 'Manage alert preferences',
                            onTap: () => context.pushNamed('DSettings'),
                            isLast: true,
                          ),
                        ]),
                        const SizedBox(height: 20),

                        // Help section
                        _sectionLabel('Help & Legal', theme),
                        const SizedBox(height: 8),
                        _menuCard(theme, [
                          _MenuItem(
                            icon: Icons.headset_mic_rounded,
                            iconColor: theme.primary,
                            label: 'Support',
                            subtitle: 'Get help from our team',
                            onTap: () => context.pushNamed('DSupport'),
                          ),
                          _MenuItem(
                            icon: Icons.article_rounded,
                            iconColor: theme.primary,
                            label: 'Terms & Privacy',
                            subtitle: 'Policies and guidelines',
                            onTap: () =>
                                context.pushNamed('TermsCommission2'),
                            isLast: true,
                          ),
                        ]),
                        const SizedBox(height: 24),

                        // Sign out button
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFFDC2626)
                                      .withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout_rounded,
                                    color: Color(0xFFDC2626), size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Sign Out',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDC2626),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom nav — Profile tab active (index 3)
            bottomNavigationBar: _DriverBottomNav(activeIndex: 3),
          ),
        );
      },
    );
  }

  Widget _headerStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _headerDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white30,
      margin: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _sectionLabel(String label, FlutterFlowTheme theme) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: theme.secondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _menuCard(FlutterFlowTheme theme, List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          final isLast = item.isLast;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: item.iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(item.icon,
                            color: item.iconColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label,
                              style: GoogleFonts.inter(
                                color: theme.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (item.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle!,
                                style: GoogleFonts.inter(
                                  color: theme.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: theme.secondaryText, size: 20),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 70,
                  color: theme.alternate,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Data class for menu items ─────────────────────────────────────────────────

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isLast;
}

// ── Shared bottom nav for driver pages ────────────────────────────────────────

class _DriverBottomNav extends StatelessWidget {
  const _DriverBottomNav({required this.activeIndex});
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final items = <(IconData, String, VoidCallback)>[
      (Icons.home_rounded, 'Home',
          () => context.pushReplacementNamed('DriverDashboard6')),
      (Icons.insights_rounded, 'Earnings',
          () => context.pushNamed('DPayment')),
      (Icons.history_rounded, 'Rides',
          () => context.pushNamed('DRideHistory')),
      (Icons.person_outline_rounded, 'Profile',
          () => context.pushReplacementNamed('DriverEditProfile')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(top: BorderSide(color: theme.alternate, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < items.length; i++)
                GestureDetector(
                  onTap: items[i].$3,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: i == activeIndex
                              ? theme.primary.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          items[i].$1,
                          color: i == activeIndex
                              ? theme.primary
                              : theme.secondaryText,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$2,
                        style: GoogleFonts.inter(
                          color: i == activeIndex
                              ? theme.primary
                              : theme.secondaryText,
                          fontSize: 11,
                          fontWeight: i == activeIndex
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
