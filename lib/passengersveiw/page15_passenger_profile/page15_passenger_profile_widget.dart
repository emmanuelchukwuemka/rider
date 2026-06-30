import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/components/settings_option2_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/passengersveiw/passenger_activity/passenger_activity_widget.dart';
import '/passengersveiw/passenger_edit_profile/passenger_edit_profile_widget.dart';
import '/passengersveiw/passenger_wallet/passenger_wallet_widget.dart';
import '../passenger_settings/passenger_settings_widget.dart';
import '../passenger_scheduled_rides/passenger_scheduled_rides_widget.dart';
import '../passenger_help_center/passenger_help_center_widget.dart';
import 'page15_passenger_profile_model.dart';
export 'page15_passenger_profile_model.dart';

class Page15PassengerProfileWidget extends StatefulWidget {
  const Page15PassengerProfileWidget({super.key});

  static String routeName = 'Page15PassengerProfile';
  static String routePath = '/page15PassengerProfile';

  @override
  State<Page15PassengerProfileWidget> createState() =>
      _Page15PassengerProfileWidgetState();
}

class _Page15PassengerProfileWidgetState
    extends State<Page15PassengerProfileWidget> {
  late Page15PassengerProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _profileImagePath;  // local file path (fallback)
  String? _profileImageUrl;   // server URL (preferred)
  String _displayName = '';
  int _tripCount = 0;
  String _memberYears = '—';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page15PassengerProfileModel());
    _loadAll();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadAll() async {
    final uid = currentUserUid;
    if (uid.isEmpty) return;

    final results = await Future.wait([
      fetchUserById(uid),
      fetchUserRideHistory(uid),
    ]);
    final user = results[0] as Map<String, dynamic>?;
    final rides = results[1] as List<Map<String, dynamic>>;

    // Also save fresh name to SharedPreferences so it persists across sessions
    final freshName = user?['display_name']?.toString() ??
        user?['name']?.toString() ??
        user?['full_name']?.toString() ??
        currentUserDisplayName;
    if (freshName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('displayName', freshName);
    }

    final serverImageUrl = user?['profile_image']?.toString() ??
        user?['avatar']?.toString() ??
        user?['photo_url']?.toString();

    final prefs = await SharedPreferences.getInstance();
    final localPath = prefs.getString('profile_image_path');
    final createdAt = user?['created_at']?.toString() ?? user?['createdAt']?.toString() ?? prefs.getString('createdAt');
    String years = '—';
    if (createdAt != null) {
      try {
        final dt = DateTime.parse(createdAt);
        final diff = DateTime.now().difference(dt).inDays / 365.0;
        years = diff.toStringAsFixed(1);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _displayName = freshName;
      _profileImageUrl = (serverImageUrl != null && serverImageUrl.isNotEmpty) ? serverImageUrl : null;
      _profileImagePath = localPath;
      _tripCount = rides.length;
      _memberYears = years;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image == null) return;

    // Upload to server
    final url = await uploadProfileImage(image.path);
    final prefs = await SharedPreferences.getInstance();
    if (url != null && url.isNotEmpty) {
      await prefs.setString('profile_image_url', url);
      if (mounted) setState(() => _profileImageUrl = url);
    } else {
      // Fallback: store local path
      await prefs.setString('profile_image_path', image.path);
      if (mounted) setState(() => _profileImagePath = image.path);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient Header
                  Container(
                    height: 220.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primary,
                          FlutterFlowTheme.of(context).tertiary,
                        ],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 50.0,
                    left: 15.0,
                    child: InkWell(
                      onTap: () => context.safePop(),
                      child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 24.0),
                    ),
                  ),
                  // Edit Profile Button
                  Positioned(
                    top: 50.0,
                    right: 15.0,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PassengerEditProfileWidget()),
                      ).then((_) => setState(() {})),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_rounded, color: Colors.white, size: 14.0),
                            SizedBox(width: 4.0),
                            Text(
                              'Edit',
                              style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Profile Content
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 120.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar
                        Stack(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          children: [
                            Container(
                              width: 110.0,
                              height: 110.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 6.0),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9999.0),
                                  child: InkWell(
                                    onTap: _pickImage,
                                    child: _profileImageUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: _profileImageUrl!,
                                            width: 102.0,
                                            height: 102.0,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) => _buildInitialAvatar(),
                                          )
                                        : _profileImagePath != null
                                            ? Image.file(
                                                File(_profileImagePath!),
                                                width: 102.0,
                                                height: 102.0,
                                                fit: BoxFit.cover,
                                              )
                                            : _buildInitialAvatar(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        // Name and Phone
                        Text(
                          _displayName.isNotEmpty ? _displayName : (currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'Passenger'),
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          currentPhoneNumber,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                        SizedBox(height: 24.0),
                        // Stats Card
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.0,
                                color: Color(0x1A000000),
                                offset: Offset(0.0, 4.0),
                              )
                            ],
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(context, '$_tripCount', 'Trips'),
                                Container(
                                  width: 1.0,
                                  height: 30.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                _buildStatColumn(context, _memberYears, 'Years'),
                                Container(
                                  width: 1.0,
                                  height: 30.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                _buildStatColumn(context, 'Member', 'Status'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Options List
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Account',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PassengerActivityWidget()),
                        );
                      },
                      child: SettingsOption2Widget(
                        icon: Icon(Icons.history_rounded, color: FlutterFlowTheme.of(context).primary, size: 22.0),
                        subtitle: 'View your past trips and receipts',
                        title: 'Ride History',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PassengerScheduledRidesWidget()),
                        );
                      },
                      child: SettingsOption2Widget(
                        icon: Icon(Icons.event_available_rounded, color: FlutterFlowTheme.of(context).primary, size: 22.0),
                        subtitle: 'Manage your upcoming trips',
                        title: 'Scheduled Rides',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PassengerWalletWidget()),
                        );
                      },
                      child: SettingsOption2Widget(
                        icon: Icon(Icons.payments_rounded, color: FlutterFlowTheme.of(context).primary, size: 22.0),
                        subtitle: 'Visa •••• 4242',
                        title: 'Payment Methods',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PassengerSettingsWidget()),
                        );
                      },
                      child: SettingsOption2Widget(
                        icon: Icon(Icons.settings_rounded, color: FlutterFlowTheme.of(context).primary, size: 22.0),
                        subtitle: 'Privacy, language, and app preferences',
                        title: 'Settings',
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Divider(color: FlutterFlowTheme.of(context).alternate, thickness: 1.0),
                    SizedBox(height: 24.0),
                    Text(
                      'Support',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PassengerHelpCenterWidget()),
                        );
                      },
                      child: SettingsOption2Widget(
                        icon: Icon(Icons.help_outline_rounded, color: FlutterFlowTheme.of(context).primary, size: 22.0),
                        subtitle: 'Get support and safety information',
                        title: 'Help Center',
                      ),
                    ),
                    SizedBox(height: 32.0),
                    // Logout Button
                    FFButtonWidget(
                      onPressed: () async {
                        await authManagerSignOut();
                        context.go('/');
                      },
                      text: 'Logout',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                          color: FlutterFlowTheme.of(context).error,
                        ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Center(
                      child: Text(
                        'Version 2.4.0 (Build 102)',
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar() {
    final name = _displayName.isNotEmpty ? _displayName : (currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'P');
    final initial = name[0].toUpperCase();
    return Container(
      width: 102.0,
      height: 102.0,
      color: FlutterFlowTheme.of(context).primary.withOpacity(0.15),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.bold, color: FlutterFlowTheme.of(context).primary),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label, {bool highlight = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: FlutterFlowTheme.of(context).titleMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w700),
            color: highlight ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: FlutterFlowTheme.of(context).labelSmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w500),
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ],
    );
  }
}
