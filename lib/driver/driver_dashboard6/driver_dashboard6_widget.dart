import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/custom_auth/auth_util.dart';
import 'driver_dashboard6_model.dart';
export 'driver_dashboard6_model.dart';

class DriverDashboard6Widget extends StatefulWidget {
  const DriverDashboard6Widget({super.key});

  static String routeName = 'DriverDashboard6';
  static String routePath = '/driverDashboard6';

  @override
  State<DriverDashboard6Widget> createState() => _DriverDashboard6WidgetState();
}

class _DriverDashboard6WidgetState extends State<DriverDashboard6Widget> {
  late DriverDashboard6Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _currentLocation;
  bool _isTogglingOnline = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DriverDashboard6Model());

    SocketService().initSocket(currentUserUid, 'driver');
    SocketService().onNewRideOffer = (data) {
      if (data != null && data['ride'] != null) {
        context.pushNamed(
          'IncomingRiderequest7',
          queryParameters: {'rideId': data['ride']['_id'].toString()},
        );
      }
    };

    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => _currentLocation = loc));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formattedDate() {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  Future<void> _toggleOnline(bool isOnline) async {
    if (_isTogglingOnline) return;
    setState(() => _isTogglingOnline = true);
    try {
      await updateDriverProfile(currentUserUid, {'is_active': !isOnline});
    } finally {
      if (mounted) setState(() => _isTogglingOnline = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(FlutterFlowTheme.of(context).primary),
          ),
        ),
      );
    }

    return StreamBuilder<List<UserDriverRecord>>(
      stream: queryCurrentDriverRecord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(FlutterFlowTheme.of(context).primary),
              ),
            ),
          );
        }

        final driver = snapshot.data!.isNotEmpty ? snapshot.data!.first : null;
        final isOnline = driver?.isOnline == OnlineStatus.Online;
        final fullName = driver?.displayName ?? 'Driver';
        final firstName = fullName.split(' ').first;
        final walletBalance = driver?.walletBalance?.toStringAsFixed(2) ?? '0.00';
        final totalTrips = driver?.totalTrips ?? 0;
        final rating = driver?.driverRating?.toStringAsFixed(1) ?? '5.0';
        final theme = FlutterFlowTheme.of(context);

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: theme.primaryBackground,
            body: Stack(
              children: [
                // ── Full-screen map ──────────────────────────────────────
                Positioned.fill(
                  child: FlutterFlowGoogleMap(
                    controller: _model.mapGoogleMapsController,
                    onCameraIdle: (latLng) =>
                        safeSetState(() => _model.mapGoogleMapsCenter = latLng),
                    initialLocation:
                        _model.mapGoogleMapsCenter ??= _currentLocation!,
                    markerColor: GoogleMarkerColor.violet,
                    mapType: MapType.normal,
                    style: GoogleMapStyle.standard,
                    initialZoom: 14.0,
                    allowInteraction: true,
                    allowZoom: true,
                    showZoomControls: false,
                    showLocation: true,
                    showCompass: false,
                    showMapToolbar: false,
                    showTraffic: false,
                    centerMapOnMarkerTap: true,
                    mapTakesGesturePreference: false,
                  ),
                ),

                // ── Header overlay ───────────────────────────────────────
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: theme.primaryBackground.withOpacity(0.88),
                          padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
                          child: Row(
                            children: [
                              // Avatar initials
                              GestureDetector(
                                onTap: () => context.pushNamed('DriverEditProfile'),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [theme.primary, theme.secondary],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primary.withOpacity(0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    firstName.isNotEmpty
                                        ? firstName[0].toUpperCase()
                                        : 'D',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Greeting + date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_greeting()}, $firstName!',
                                      style: GoogleFonts.inter(
                                        color: theme.primaryText,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        height: 1.3,
                                      ),
                                    ),
                                    Text(
                                      _formattedDate(),
                                      style: GoogleFonts.inter(
                                        color: theme.secondaryText,
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Online/offline status pill
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isOnline
                                      ? const Color(0xFF22C55E).withOpacity(0.14)
                                      : const Color(0xFFEF4444).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isOnline
                                        ? const Color(0xFF22C55E).withOpacity(0.4)
                                        : const Color(0xFFEF4444).withOpacity(0.4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: isOnline
                                            ? const Color(0xFF22C55E)
                                            : const Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      isOnline ? 'Online' : 'Offline',
                                      style: GoogleFonts.inter(
                                        color: isOnline
                                            ? const Color(0xFF22C55E)
                                            : const Color(0xFFEF4444),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Notification bell
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.notifications_none_rounded,
                                  color: theme.primaryText,
                                  size: 22,
                                ),
                                splashRadius: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 36, minHeight: 36),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Bottom panel ─────────────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.14),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 4),
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.alternate,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ── Earnings + mini stats ─────────────────
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Earnings gradient card
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              theme.primary,
                                              theme.primary.withOpacity(0.72),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.primary
                                                  .withOpacity(0.28),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Today's Earnings",
                                              style: GoogleFonts.inter(
                                                color: Colors.white
                                                    .withOpacity(0.75),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$0.00',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.directions_car_rounded,
                                                  color: Colors.white54,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '$totalTrips trips total',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white54,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Mini stat cards
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          _MiniStat(
                                            icon: Icons.star_rounded,
                                            value: rating,
                                            label: 'Rating',
                                            iconColor:
                                                const Color(0xFFF59E0B),
                                            bgColor: const Color(0xFFF59E0B)
                                                .withOpacity(0.1),
                                          ),
                                          const SizedBox(height: 8),
                                          _MiniStat(
                                            icon: Icons
                                                .account_balance_wallet_rounded,
                                            value: '\$$walletBalance',
                                            label: 'Wallet',
                                            iconColor: theme.primary,
                                            bgColor: theme.primary10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // ── Quick actions ─────────────────────────
                                Row(
                                  children: [
                                    _QuickAction(
                                      icon: Icons.history_rounded,
                                      label: 'Rides',
                                      onTap: () =>
                                          context.pushNamed('DRideHistory'),
                                    ),
                                    _QuickAction(
                                      icon: Icons.calendar_month_rounded,
                                      label: 'Schedule',
                                      onTap: () =>
                                          context.pushNamed('DScheduledRides'),
                                    ),
                                    _QuickAction(
                                      icon: Icons.payments_rounded,
                                      label: 'Payment',
                                      onTap: () =>
                                          context.pushNamed('DPayment'),
                                    ),
                                    _QuickAction(
                                      icon: Icons.headset_mic_rounded,
                                      label: 'Support',
                                      onTap: () =>
                                          context.pushNamed('DSupport'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // ── Go Online / Offline button ────────────
                                GestureDetector(
                                  onTap: _isTogglingOnline
                                      ? null
                                      : () => _toggleOnline(isOnline),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: double.infinity,
                                    height: 54,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isOnline
                                          ? const Color(0xFFDC2626)
                                          : const Color(0xFF16A34A),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isOnline
                                                  ? const Color(0xFFDC2626)
                                                  : const Color(0xFF16A34A))
                                              .withOpacity(0.32),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: _isTogglingOnline
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isOnline
                                                    ? Icons
                                                        .power_settings_new_rounded
                                                    : Icons
                                                        .play_circle_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                isOnline
                                                    ? 'Go Offline'
                                                    : 'Go Online',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Bottom navigation bar ────────────────────────────────────
            bottomNavigationBar: _BottomNav(activeIndex: 0),
          ),
        );
      },
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.bgColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: theme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: theme.secondaryText,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: theme.alternate),
              ),
              child: Icon(icon, color: theme.onSurface, size: 20),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                color: theme.secondaryText,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.activeIndex});
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final items = [
      (Icons.home_rounded, 'Home', () => context.pushReplacementNamed('DriverDashboard6')),
      (Icons.insights_rounded, 'Earnings', () => context.pushNamed('DPayment')),
      (Icons.history_rounded, 'Rides', () => context.pushNamed('DRideHistory')),
      (Icons.person_outline_rounded, 'Profile', () => context.pushNamed('DriverEditProfile')),
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
                _NavItem(
                  icon: items[i].$1,
                  label: items[i].$2,
                  active: i == activeIndex,
                  onTap: items[i].$3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: active
                  ? theme.primary.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: active ? theme.primary : theme.secondaryText,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: active ? theme.primary : theme.secondaryText,
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
