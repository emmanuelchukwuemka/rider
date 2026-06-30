import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import '/auth/custom_auth/auth_util.dart';
import '/components/button2/button2_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'trip_in_progress10_model.dart';
export 'trip_in_progress10_model.dart';

class TripInProgress10Widget extends StatefulWidget {
  const TripInProgress10Widget({super.key, this.rideId = ''});

  final String rideId;

  static String routeName = 'TripInProgress10';
  static String routePath = '/tripInProgress10';

  @override
  State<TripInProgress10Widget> createState() => _TripInProgress10WidgetState();
}

class _TripInProgress10WidgetState extends State<TripInProgress10Widget> {
  late TripInProgress10Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _ride;
  bool _completing = false;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TripInProgress10Model());
    _loadRide();

    // Broadcast driver location every 5 s so passenger map updates
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final loc = await getCurrentUserLocation(
          defaultLocation: const LatLng(6.5244, 3.3792), cached: false);
      SocketService().updateLocation(loc.latitude, loc.longitude,
          driverId: currentUserUid);
    });

    // If passenger cancels mid-trip, return to dashboard
    SocketService().onRideCancelled = (data) {
      if (!mounted) return;
      _locationTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride was cancelled by the passenger.')),
      );
      context.goNamed('DriverDashboard6');
    };
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    SocketService().onRideCancelled = null;
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadRide() async {
    if (widget.rideId.isEmpty) return;
    final data = await fetchRideById(widget.rideId);
    if (mounted && data != null) setState(() => _ride = data['ride'] ?? data);
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    if (p.isNotEmpty && p[0].isNotEmpty) return p[0][0].toUpperCase();
    return 'P';
  }

  String get _passengerName {
    final r = _ride;
    return (r?['passenger']?['display_name'] ??
            r?['passenger']?['name'] ??
            r?['passenger_name'] ??
            '')
        .toString()
        .trim();
  }

  String get _passengerPhone {
    final r = _ride;
    return (r?['passenger']?['phone_number'] ??
            r?['passenger_phone'] ??
            '')
        .toString()
        .trim();
  }

  String get _dropoffAddress {
    return (_ride?['dropoff_address'] ?? '').toString().trim();
  }

  double get _fare {
    return double.tryParse(
            (_ride?['estimated_fare'] ?? _ride?['fare'] ?? 0).toString()) ??
        0.0;
  }

  Future<void> _completeTrip() async {
    if (_completing || widget.rideId.isEmpty) return;
    setState(() => _completing = true);

    final ok = await updateRideStatus(widget.rideId, 'complete');
    _locationTimer?.cancel();

    if (!mounted) return;
    setState(() => _completing = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to complete trip. Try again.')),
      );
      return;
    }

    context.pushNamed(
      'TripSummary11',
      queryParameters: {
        'rideId': widget.rideId,
        'fare': serializeParam(_fare, ParamType.double),
      },
    );
  }

  void _openChat() async {
    final phone = _passengerPhone;
    if (phone.isNotEmpty) {
      await launchUrl(Uri(scheme: 'sms', path: phone));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passenger phone number not available')),
      );
    }
  }

  void _openCall() async {
    final phone = _passengerPhone;
    if (phone.isNotEmpty) {
      await launchUrl(Uri(scheme: 'tel', path: phone));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passenger phone number not available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final name = _passengerName;
    final initials = name.isNotEmpty ? _initials(name) : 'P';
    final dest = _dropoffAddress.isNotEmpty ? _dropoffAddress : 'Destination';

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
          alignment: AlignmentDirectional(-1.0, -1.0),
          children: [
            // Map
            FlutterFlowGoogleMap(
              controller: _model.mapGoogleMapsController,
              onCameraIdle: (latLng) => _model.mapGoogleMapsCenter = latLng,
              initialLocation:
                  _model.mapGoogleMapsCenter ??= const LatLng(6.5244, 3.3792),
              markers: _model.location
                  .map((m) => FlutterFlowMarker(m.serialize(), m))
                  .toList(),
              markerColor: GoogleMarkerColor.violet,
              mapType: MapType.normal,
              style: GoogleMapStyle.standard,
              initialZoom: 14.0,
              allowInteraction: true,
              allowZoom: true,
              showZoomControls: false,
              showLocation: false,
              showCompass: false,
              showMapToolbar: false,
              showTraffic: false,
              centerMapOnMarkerTap: true,
              mapTakesGesturePreference: false,
            ),

            // Top status bar
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.surface90,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                color: theme.primary,
                                borderRadius: BorderRadius.circular(9999.0),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trip in Progress',
                                    style: theme.labelSmall.override(
                                      font: GoogleFonts.inter(),
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    dest,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold),
                                      fontWeight: FontWeight.bold,
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
                ),
              ),
            ),

            // Bottom sheet
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Drag handle
                      Container(
                        width: 40.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: theme.alternate,
                          borderRadius: BorderRadius.circular(9999.0),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Destination + ETA row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dest,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.titleMedium.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Destination',
                                style: theme.bodySmall.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _fare > 0
                                    ? '₦${_fare.toStringAsFixed(0)}'
                                    : '—',
                                style: theme.headlineMedium.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Fare',
                                style: theme.bodySmall.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Divider(
                        height: 32.0,
                        thickness: 1.0,
                        color: theme.alternate,
                      ),

                      // Passenger row + chat/call buttons
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: theme.tertiary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initials,
                              style: theme.labelMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),

                          // Name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.isNotEmpty ? name : 'Passenger',
                                  style: theme.titleMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Passenger',
                                  style: theme.bodySmall.override(
                                    font: GoogleFonts.inter(),
                                    color: theme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Chat button
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: theme.primaryBackground,
                            icon: Icon(Icons.chat_bubble_rounded,
                                color: theme.primary, size: 24.0),
                            onPressed: _openChat,
                          ),
                          const SizedBox(width: 8.0),

                          // Call button
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: theme.primaryBackground,
                            icon: Icon(Icons.call_rounded,
                                color: theme.primary, size: 24.0),
                            onPressed: _openCall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      // Complete Trip button
                      GestureDetector(
                        onTap: _completing ? null : _completeTrip,
                        child: wrapWithModel(
                          model: _model.buttonModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: Button2Widget(
                            content:
                                _completing ? 'Completing…' : 'Complete Trip',
                            iconPresent: false,
                            iconEndPresent: false,
                            color: theme.secondaryText,
                            variant: 'primary',
                            size: 'large',
                            fullWidth: true,
                            loading: _completing,
                            disabled: _completing,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
