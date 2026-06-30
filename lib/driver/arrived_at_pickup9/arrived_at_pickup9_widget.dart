import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/backend/api_service.dart';
import '/auth/custom_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'arrived_at_pickup9_model.dart';
export 'arrived_at_pickup9_model.dart';

class ArrivedAtPickup9Widget extends StatefulWidget {
  const ArrivedAtPickup9Widget({super.key, this.rideId = ''});

  final String rideId;

  static String routeName = 'ArrivedAtPickup9';
  static String routePath = '/arrivedAtPickup9';

  @override
  State<ArrivedAtPickup9Widget> createState() => _ArrivedAtPickup9WidgetState();
}

class _ArrivedAtPickup9WidgetState extends State<ArrivedAtPickup9Widget> {
  late ArrivedAtPickup9Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _rideData;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ArrivedAtPickup9Model());
    _loadRide();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadRide() async {
    if (widget.rideId.isEmpty) return;
    final data = await fetchRideById(widget.rideId);
    if (!mounted) return;
    if (data != null) setState(() => _rideData = data['ride'] ?? data);
  }

  Future<void> _cancelRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text(
            'Are you sure you want to cancel this ride? The passenger will be notified.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes, Cancel',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await updateRideStatus(widget.rideId, 'cancel');
    if (mounted) context.goNamed('DriverDashboard6');
  }

  Future<void> _startTrip() async {
    if (_starting) return;
    setState(() => _starting = true);
    bool ok = false;
    for (final ep in ['start', 'start-trip', 'begin', 'in_progress']) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('authToken') ?? '';
        final res = await http.post(
          Uri.parse('$baseUrl/api/rides/${widget.rideId}/$ep'),
          headers: {
            'Content-Type': 'application/json',
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
          },
          body: json.encode({'driver_id': currentUserUid}),
        );
        print('[startTrip] POST $ep → ${res.statusCode}: ${res.body}');
        if (res.statusCode == 200 || res.statusCode == 201) { ok = true; break; }
      } catch (_) {}
    }
    if (!ok) {
      ok = await updateRideStatus(widget.rideId, 'start',
          {'status': 'in_progress', 'driver_id': currentUserUid});
    }
    print('[startTrip] final result: $ok');
    if (!mounted) return;
    context.pushNamed('TripInProgress10',
        queryParameters: {'rideId': widget.rideId});
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    if (p.isNotEmpty && p[0].isNotEmpty) return p[0][0].toUpperCase();
    return 'P';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final ride = _rideData;

    final passengerName = (ride?['passenger']?['display_name'] ??
            ride?['passenger']?['name'] ??
            ride?['passenger_name'] ??
            '')
        .toString()
        .trim();
    final displayName = passengerName.isNotEmpty ? passengerName : 'Passenger';
    final initials = _initials(displayName);
    final pickup = (ride?['pickup_address'] ?? ride?['pickup']?['address'] ?? '')
        .toString()
        .trim();
    final dropoff =
        (ride?['dropoff_address'] ?? ride?['destination']?['address'] ?? '')
            .toString()
            .trim();
    final fare = (ride?['fare'] ?? ride?['price'] ?? '').toString().trim();
    final fareText = fare.isNotEmpty && fare != 'null' ? '₦$fare' : '';
    final passengerPhone = (ride?['passenger']?['phone_number'] ??
            ride?['passenger']?['phone'] ??
            ride?['passenger_phone'] ??
            '')
        .toString()
        .trim();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // Map background
            Positioned.fill(
              child: FlutterFlowGoogleMap(
                controller: _model.mapGoogleMapsController,
                onCameraIdle: (latLng) =>
                    _model.mapGoogleMapsCenter = latLng,
                initialLocation:
                    _model.mapGoogleMapsCenter ??= const LatLng(6.5244, 3.3792),
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
                mapTakesGesturePreference: false,
              ),
            ),

            // Top "Arrived" badge
            Positioned(
              top: 0, left: 0, right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.alternate),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: theme.success,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.location_on_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('You have arrived!',
                                  style: GoogleFonts.inter(
                                    color: theme.primaryText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  )),
                              Text('Waiting for passenger to board',
                                  style: GoogleFonts.inter(
                                    color: theme.secondaryText,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, -3)),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                    20, 14, 20, MediaQuery.of(context).padding.bottom + 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 36, height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: theme.alternate,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Passenger row
                    Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.primary, width: 2),
                          ),
                          child: Text(initials,
                              style: GoogleFonts.inter(
                                color: theme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(displayName,
                                  style: GoogleFonts.inter(
                                    color: theme.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              if (fareText.isNotEmpty)
                                Text(fareText,
                                    style: GoogleFonts.inter(
                                      color: theme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _CircleBtn(
                              icon: Icons.call_rounded,
                              onTap: () {
                                if (passengerPhone.isNotEmpty) {
                                  launchUrl(Uri.parse('tel:$passengerPhone'));
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            _CircleBtn(
                              icon: Icons.chat_bubble_rounded,
                              onTap: () {
                                if (passengerPhone.isNotEmpty) {
                                  launchUrl(Uri.parse('sms:$passengerPhone'));
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Pickup / Dropoff
                    if (pickup.isNotEmpty || dropoff.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: theme.primaryBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.alternate),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            if (pickup.isNotEmpty)
                              _AddrRow(
                                icon: Icons.circle,
                                iconColor: theme.primary,
                                label: pickup,
                                sub: 'Pickup',
                              ),
                            if (pickup.isNotEmpty && dropoff.isNotEmpty)
                              Divider(
                                  height: 12,
                                  color: theme.alternate),
                            if (dropoff.isNotEmpty)
                              _AddrRow(
                                icon: Icons.location_on_rounded,
                                iconColor: Colors.red,
                                label: dropoff,
                                sub: 'Destination',
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),

                    // START TRIP button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _starting ? null : _startTrip,
                        icon: _starting
                            ? const SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 22),
                        label: Text(
                          _starting ? 'Starting…' : 'START TRIP',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.success,
                          disabledBackgroundColor:
                              theme.success.withOpacity(0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // CANCEL RIDE button
                    SizedBox(
                      height: 44,
                      child: TextButton.icon(
                        onPressed: _cancelRide,
                        icon: const Icon(Icons.cancel_outlined,
                            color: Colors.red, size: 18),
                        label: Text(
                          'Cancel Ride',
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          shape: BoxShape.circle,
          border: Border.all(color: theme.alternate),
        ),
        child: Icon(icon, color: theme.primary, size: 18),
      ),
    );
  }
}

class _AddrRow extends StatelessWidget {
  const _AddrRow(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.sub});
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sub;
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 14),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sub,
                  style: GoogleFonts.inter(
                      color: theme.secondaryText, fontSize: 10)),
              Text(label,
                  style: GoogleFonts.inter(
                      color: theme.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
