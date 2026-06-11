import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../page15_passenger_profile/page15_passenger_profile_widget.dart';
import '../passenger_wallet/passenger_wallet_widget.dart';
import '../passenger_activity/passenger_activity_widget.dart';
import '../page6_set_destination/page6_set_destination_widget.dart';
import '../page7_schedule_ride/page7_schedule_ride_widget.dart';
import 'passengers_dashboardnew_model.dart';
export 'passengers_dashboardnew_model.dart';

class PassengersDashboardnewWidget extends StatefulWidget {
  const PassengersDashboardnewWidget({super.key});

  static String routeName = 'PassengersDashboardnew';
  static String routePath = '/passengersDashboardnew';

  @override
  State<PassengersDashboardnewWidget> createState() =>
      _PassengersDashboardnewWidgetState();
}

class _PassengersDashboardnewWidgetState
    extends State<PassengersDashboardnewWidget> {
  late PassengersDashboardnewModel _model;
  LatLng? _currentLocation;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengersDashboardnewModel());
    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: false)
        .then((loc) {
      if (!mounted) return;
      safeSetState(() => _currentLocation = loc);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _goToDestination() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Page6SetDestinationWidget(
          mapDropoff: _model.googleMapsCenter,
        ),
      ),
    );
  }

  void _goToSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Page7ScheduleRideWidget(
          mapDropoff: _model.googleMapsCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg = theme.primaryBackground;
    final cardBg = theme.secondaryBackground;
    final primary = theme.primary;
    final primaryText = theme.primaryText;
    final secondaryText = theme.secondaryText;
    final alt = theme.alternate;

    if (_currentLocation == null) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primary),
              const SizedBox(height: 16),
              Text('Getting your location…',
                  style: GoogleFonts.inter(color: secondaryText, fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen map ─────────────────────────────────────────
          Positioned.fill(
            child: FlutterFlowGoogleMap(
              controller: _model.googleMapsController,
              onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
              initialLocation: _model.googleMapsCenter ??= _currentLocation!,
              markerColor: GoogleMarkerColor.violet,
              mapType: MapType.normal,
              style: GoogleMapStyle.standard,
              initialZoom: 15.0,
              allowInteraction: true,
              allowZoom: true,
              showZoomControls: false,
              showLocation: true,
              showCompass: false,
              showMapToolbar: false,
              showTraffic: false,
              centerMapOnMarkerTap: true,
            ),
          ),

          // ── Center location pin ─────────────────────────────────────
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: primary, size: 44),
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Top overlay ─────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _GlassButton(
                    icon: Icons.menu_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Page15PassengerProfileWidget(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  _GlassButton(
                    icon: Icons.notifications_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom sheet ─────────────────────────────────────────────
          DraggableScrollableSheet(
            initialChildSize: 0.42,
            minChildSize: 0.38,
            maxChildSize: 0.78,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: alt,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting
                            Text(
                              _greeting(),
                              style: GoogleFonts.inter(
                                color: secondaryText,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Where are you going?',
                              style: GoogleFonts.inter(
                                color: primaryText,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Search bar ───────────────────────────────
                            GestureDetector(
                              onTap: _goToDestination,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: alt, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search_rounded,
                                        color: primary, size: 22),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Search destination…',
                                        style: GoogleFonts.inter(
                                          color: secondaryText,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Now',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Quick action cards ───────────────────────
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.local_taxi_rounded,
                                    label: 'Ride',
                                    subtitle: 'Book now',
                                    iconColor: primary,
                                    bgColor: primary.withOpacity(0.08),
                                    onTap: _goToDestination,
                                    theme: theme,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.calendar_today_rounded,
                                    label: 'Schedule',
                                    subtitle: 'Plan ahead',
                                    iconColor: const Color(0xFF7C3AED),
                                    bgColor: const Color(0xFF7C3AED).withOpacity(0.08),
                                    onTap: _goToSchedule,
                                    theme: theme,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ── Saved places ──────────────────────────────
                            Text(
                              'Saved Places',
                              style: GoogleFonts.inter(
                                color: primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SavedPlaceTile(
                              icon: Icons.home_rounded,
                              label: 'Home',
                              subtitle: 'Add home address',
                              theme: theme,
                              onTap: _goToDestination,
                            ),
                            const SizedBox(height: 8),
                            _SavedPlaceTile(
                              icon: Icons.work_rounded,
                              label: 'Work',
                              subtitle: 'Add work address',
                              theme: theme,
                              onTap: _goToDestination,
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // ── Bottom nav bar ────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: alt, width: 1)),
                      ),
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                        bottom: MediaQuery.of(context).padding.bottom + 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _NavItem(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            active: _selectedNavIndex == 0,
                            primary: primary,
                            secondaryText: secondaryText,
                            onTap: () => safeSetState(() => _selectedNavIndex = 0),
                          ),
                          _NavItem(
                            icon: Icons.receipt_long_rounded,
                            label: 'Activity',
                            active: _selectedNavIndex == 1,
                            primary: primary,
                            secondaryText: secondaryText,
                            onTap: () {
                              safeSetState(() => _selectedNavIndex = 1);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PassengerActivityWidget()),
                              ).then((_) =>
                                  safeSetState(() => _selectedNavIndex = 0));
                            },
                          ),
                          _NavItem(
                            icon: Icons.account_balance_wallet_rounded,
                            label: 'Wallet',
                            active: _selectedNavIndex == 2,
                            primary: primary,
                            secondaryText: secondaryText,
                            onTap: () {
                              safeSetState(() => _selectedNavIndex = 2);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PassengerWalletWidget()),
                              ).then((_) =>
                                  safeSetState(() => _selectedNavIndex = 0));
                            },
                          ),
                          _NavItem(
                            icon: Icons.person_rounded,
                            label: 'Account',
                            active: _selectedNavIndex == 3,
                            primary: primary,
                            secondaryText: secondaryText,
                            onTap: () {
                              safeSetState(() => _selectedNavIndex = 3);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const Page15PassengerProfileWidget()),
                              ).then((_) =>
                                  safeSetState(() => _selectedNavIndex = 0));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF1A1A1A)),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: theme.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: theme.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedPlaceTile extends StatelessWidget {
  const _SavedPlaceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.theme,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.alternate, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.primaryText, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                      color: theme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                Text(subtitle,
                    style: GoogleFonts.inter(
                      color: theme.secondaryText,
                      fontSize: 12,
                    )),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: theme.secondaryText, size: 20),
          ],
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
    required this.primary,
    required this.secondaryText,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color primary;
  final Color secondaryText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? primary : secondaryText;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
