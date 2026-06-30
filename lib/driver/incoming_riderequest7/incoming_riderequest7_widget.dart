import 'dart:async';
import 'dart:ui';
import '/components/location_node_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/hex_stat_cell/hex_stat_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import '/auth/custom_auth/auth_util.dart';
import 'incoming_riderequest7_model.dart';
export 'incoming_riderequest7_model.dart';

class IncomingRiderequest7Widget extends StatefulWidget {
  const IncomingRiderequest7Widget({
    super.key,
    required this.rideId,
  });

  final String rideId;

  static String routeName = 'IncomingRiderequest7';
  static String routePath = '/incomingRiderequest7';

  @override
  State<IncomingRiderequest7Widget> createState() =>
      _IncomingRiderequest7WidgetState();
}

class _IncomingRiderequest7WidgetState
    extends State<IncomingRiderequest7Widget> {
  late IncomingRiderequest7Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  LatLng? _currentLocation;
  Map<String, dynamic>? _rideData;
  bool _isAccepting = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IncomingRiderequest7Model());

    // Get driver's real GPS location
    getCurrentUserLocation(defaultLocation: const LatLng(6.5244, 3.3792), cached: false)
        .then((loc) {
      if (!mounted) return;
      setState(() {
        _currentLocation = loc;
        _model.mapGoogleMapsCenter = loc;
      });
    });

    // Fetch real ride data and check it hasn't already been cancelled
    fetchRideById(widget.rideId).then((data) {
      if (!mounted || data == null) return;
      final ride = data['ride'] ?? data;
      final status = ride['status']?.toString().toLowerCase() ?? '';
      // Dismiss immediately if ride was cancelled before we loaded
      if (status == 'cancelled' || status == 'accepted') {
        if (mounted) Navigator.of(context).pop();
        return;
      }
      setState(() => _rideData = ride);

      // Center map on pickup location if available
      final pickupLat = _parseDouble(ride['pickupLat'] ?? ride['pickup_lat']);
      final pickupLng = _parseDouble(ride['pickupLng'] ?? ride['pickup_lng']);
      if (pickupLat != null && pickupLng != null && mounted) {
        setState(() => _model.mapGoogleMapsCenter = LatLng(pickupLat, pickupLng));
      }
    });

    // Dismiss if passenger cancels while this screen is open
    SocketService().onRideCancelled = (data) {
      final cancelledId = data?['rideId']?.toString() ?? '';
      if (cancelledId == widget.rideId && mounted) {
        _timer?.cancel();
        Navigator.of(context).pop();
      }
    };

    // Start 60-second countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        // Mark as dismissed so _checkPendingRides won't show it again
        SocketService().dismissedRideIds.add(widget.rideId);
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    SocketService().onRideCancelled = null;
    _model.dispose();
    super.dispose();
  }

  double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }

  String _passengerInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return 'P';
  }

  Future<void> _acceptRide() async {
    if (_isAccepting) return;
    _timer?.cancel();
    setState(() => _isAccepting = true);

    // Try 'accept' first; fall back to 'accepted' if the backend uses that path
    bool res = await updateRideStatus(widget.rideId, 'accept', {
      'driver_id': currentUserUid,
    });
    if (!res) {
      res = await updateRideStatus(widget.rideId, 'accepted', {
        'driver_id': currentUserUid,
      });
    }

    if (!mounted) return;
    setState(() => _isAccepting = false);
    if (res) {
      context.pushNamed('NavigateToPassenger8',
          queryParameters: {'rideId': widget.rideId});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not accept ride — check your connection and try again.'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _acceptRide,
          ),
        ),
      );
      // Restart the timer so the driver can still decide
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) { t.cancel(); return; }
        setState(() => _countdown--);
        if (_countdown <= 0) {
          t.cancel();
          if (mounted) Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final ride = _rideData;

    // Passenger info
    final passengerName = (ride?['passenger']?['display_name']
                          ?? ride?['passengerName']
                          ?? ride?['passenger_name']
                          ?? '')
        .toString()
        .trim();
    final displayName = passengerName.isNotEmpty ? passengerName : 'Passenger';
    final initials = _passengerInitials(displayName);
    final passengerRating = (ride?['passenger']?['rating'] ?? ride?['passengerRating'])?.toString() ?? '—';

    // Pickup / destination
    final pickupAddress  = (ride?['pickupAddress']  ?? ride?['pickup_address']  ?? ride?['from'] ?? '').toString();
    final dropoffAddress = (ride?['dropoffAddress'] ?? ride?['dropoff_address'] ?? ride?['to']   ?? '').toString();

    // Fare / distance / time
    final fare     = (ride?['fare'] ?? ride?['estimated_fare'] ?? ride?['price'] ?? 0).toString();
    final fareText = fare == '0' ? '—' : '₦$fare';
    final distance = (ride?['distance'] ?? ride?['distanceKm'] ?? '—').toString();
    final distText = distance == '—' ? '—' : '${distance} km';
    final estTime  = (ride?['estimatedTime'] ?? ride?['estimated_time'] ?? ride?['duration'] ?? '—').toString();
    final timeText = estTime == '—' ? '—' : '$estTime mins';

    final mapCenter = _model.mapGoogleMapsCenter ?? _currentLocation ?? const LatLng(6.5244, 3.3792);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // ── Full-screen map centred on driver's location ──────────────
            Positioned.fill(
              child: FlutterFlowGoogleMap(
                controller: _model.mapGoogleMapsController,
                onCameraIdle: (latLng) => _model.mapGoogleMapsCenter = latLng,
                initialLocation: mapCenter,
                markerColor: GoogleMarkerColor.violet,
                mapType: MapType.normal,
                style: GoogleMapStyle.standard,
                initialZoom: 15.0,
                allowInteraction: true,
                allowZoom: true,
                showZoomControls: false,
                showLocation: true,   // ← shows the driver's GPS blue dot
                showCompass: false,
                showMapToolbar: false,
                showTraffic: false,
                centerMapOnMarkerTap: true,
                mapTakesGesturePreference: false,
              ),
            ),

            // ── Top badge: Incoming Request + countdown ───────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Pulse dot
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.6, end: 1.0),
                              duration: const Duration(milliseconds: 700),
                              builder: (_, v, child) => Transform.scale(scale: v, child: child),
                              child: Container(
                                width: 10, height: 10,
                                decoration: BoxDecoration(
                                  color: theme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Incoming Request',
                              style: GoogleFonts.inter(
                                color: theme.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _countdown <= 10 ? const Color(0xFFDC2626) : theme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${(_countdown ~/ 60).toString().padLeft(2, '0')}:${(_countdown % 60).toString().padLeft(2, '0')}',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
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

            // ── Bottom info sheet ─────────────────────────────────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      24, 20, 24, MediaQuery.of(context).padding.bottom + 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Drag handle
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

                      // ── Passenger info row ──────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar
                          Container(
                            width: 50, height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              initials,
                              style: GoogleFonts.inter(
                                color: theme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: GoogleFonts.inter(
                                    color: theme.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(Icons.star_rounded,
                                        color: const Color(0xFFF59E0B), size: 14),
                                    const SizedBox(width: 3),
                                    Text(
                                      passengerRating,
                                      style: GoogleFonts.inter(
                                        color: theme.secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Fare
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Estimated Fare',
                                style: GoogleFonts.inter(
                                  color: theme.secondaryText,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                fareText,
                                style: GoogleFonts.inter(
                                  color: theme.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Pickup / Destination ────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Column(
                          children: [
                            LocationNodeWidget(
                              address: pickupAddress.isNotEmpty
                                  ? pickupAddress
                                  : 'Loading pickup…',
                              type: 'Pickup',
                              isPickup: true,
                            ),
                            const SizedBox(height: 14),
                            LocationNodeWidget(
                              address: dropoffAddress.isNotEmpty
                                  ? dropoffAddress
                                  : 'Loading destination…',
                              type: 'Destination',
                              isPickup: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Distance / Time ─────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: HexStatCellWidget(
                              icon: Icon(Icons.route_rounded,
                                  color: theme.primary, size: 18),
                              label: 'Distance',
                              value: distText,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: HexStatCellWidget(
                              icon: Icon(Icons.schedule_rounded,
                                  color: theme.primary, size: 18),
                              label: 'Est. Time',
                              value: timeText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Accept button ───────────────────────────────────
                      GestureDetector(
                        onTap: _isAccepting ? null : _acceptRide,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isAccepting
                                ? theme.primary.withOpacity(0.6)
                                : theme.primary,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isAccepting
                              ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Accept Ride',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Decline ─────────────────────────────────────────
                      GestureDetector(
                        onTap: () {
                          _timer?.cancel();
                          SocketService().dismissedRideIds.add(widget.rideId);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          child: Text(
                            'Decline',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFDC2626),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
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
