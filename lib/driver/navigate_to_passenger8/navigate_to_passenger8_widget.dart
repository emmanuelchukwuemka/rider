import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/custom_auth/auth_util.dart';
import 'navigate_to_passenger8_model.dart';
export 'navigate_to_passenger8_model.dart';

class NavigateToPassenger8Widget extends StatefulWidget {
  const NavigateToPassenger8Widget({super.key, this.rideId = ''});
  final String rideId;

  static String routeName = 'NavigateToPassenger8';
  static String routePath = '/navigateToPassenger8';

  @override
  State<NavigateToPassenger8Widget> createState() =>
      _NavigateToPassenger8WidgetState();
}

class _NavigateToPassenger8WidgetState
    extends State<NavigateToPassenger8Widget> {
  late NavigateToPassenger8Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<gmaps.GoogleMapController> _mapController = Completer();

  Map<String, dynamic>? _rideData;
  String _passengerName = '';
  String _passengerPhone = '';
  gmaps.LatLng? _pickupLatLng;
  gmaps.LatLng? _myLatLng;
  Set<gmaps.Marker> _markers = {};
  Set<gmaps.Polyline> _polylines = {};
  bool _isArriving = false;
  Timer? _locationTimer;

  static const _apiKey = 'AIzaSyAMK0gm6FqImxY1oLDQ72UcTuZzybFl7Lw';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavigateToPassenger8Model());
    _init();
  }

  Future<void> _init() async {
    // 1. Driver's current GPS
    final loc = await getCurrentUserLocation(
        defaultLocation: const LatLng(6.5244, 3.3792), cached: false);
    if (!mounted) return;
    _myLatLng = gmaps.LatLng(loc.latitude, loc.longitude);

    // 2. Fetch ride data
    if (widget.rideId.isNotEmpty) {
      final data = await fetchRideById(widget.rideId);
      if (!mounted) return;
      if (data != null) {
        final ride = data['ride'] ?? data;
        setState(() => _rideData = ride);

        // Fetch passenger's real name and phone
        final passengerId = (ride['passenger_id'] ?? ride['passenger_ref'] ?? ride['passenger']?['id'] ?? '').toString();
        if (passengerId.isNotEmpty) {
          final passengerData = await fetchUserById(passengerId);
          if (mounted && passengerData != null) {
            setState(() {
              _passengerName = (passengerData['display_name'] ?? passengerData['name'] ?? '').toString().trim();
              _passengerPhone = (passengerData['phone_number'] ?? passengerData['phone'] ?? '').toString().trim();
            });
          }
        }

        final lat = _parseDouble(ride['pickupLat'] ?? ride['pickup_lat']);
        final lng = _parseDouble(ride['pickupLng'] ?? ride['pickup_lng']);
        if (lat != null && lng != null) {
          _pickupLatLng = gmaps.LatLng(lat, lng);
          _updatePickupMarker();
          if (_myLatLng != null) _fetchRoute(_myLatLng!, _pickupLatLng!);
        }
      }
    }

    // 3. Emit location every 5 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final loc = await getCurrentUserLocation(
          defaultLocation: const LatLng(6.5244, 3.3792), cached: false);
      if (!mounted) return;
      final newPos = gmaps.LatLng(loc.latitude, loc.longitude);
      _myLatLng = newPos;

      // Emit to socket so passenger sees me moving
      SocketService().updateLocation(
        loc.latitude, loc.longitude,
        driverId: currentUserUid,
      );

      // Refresh route if we have a pickup target
      if (_pickupLatLng != null) {
        _fetchRoute(newPos, _pickupLatLng!);
      }
    });
  }

  void _updatePickupMarker() {
    if (_pickupLatLng == null) return;
    setState(() {
      _markers = {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('pickup'),
          position: _pickupLatLng!,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueGreen),
          infoWindow: const gmaps.InfoWindow(title: 'Passenger Pickup'),
        ),
      };
    });
  }

  Future<void> _fetchRoute(gmaps.LatLng origin, gmaps.LatLng dest) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${dest.latitude},${dest.longitude}'
          '&key=$_apiKey';
      final res = await http.get(Uri.parse(url));
      if (!mounted) return;
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final encoded =
              routes[0]['overview_polyline']['points'] as String? ?? '';
          final points = _decodePolyline(encoded);
          if (!mounted) return;
          setState(() {
            _polylines = {
              gmaps.Polyline(
                polylineId: const gmaps.PolylineId('route'),
                points: points,
                color: FlutterFlowTheme.of(context).primary,
                width: 5,
                startCap: gmaps.Cap.roundCap,
                endCap: gmaps.Cap.roundCap,
              ),
            };
          });
          // Zoom to show driver → pickup
          if (_mapController.isCompleted) {
            final c = await _mapController.future;
            final bounds = gmaps.LatLngBounds(
              southwest: gmaps.LatLng(
                  [origin.latitude, dest.latitude].reduce((a, b) => a < b ? a : b),
                  [origin.longitude, dest.longitude].reduce((a, b) => a < b ? a : b)),
              northeast: gmaps.LatLng(
                  [origin.latitude, dest.latitude].reduce((a, b) => a > b ? a : b),
                  [origin.longitude, dest.longitude].reduce((a, b) => a > b ? a : b)),
            );
            c.animateCamera(gmaps.CameraUpdate.newLatLngBounds(bounds, 80));
          }
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<gmaps.LatLng> _decodePolyline(String encoded) {
    final points = <gmaps.LatLng>[];
    int index = 0;
    final len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      points.add(gmaps.LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }

  Future<void> _cancelRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text(
            'Are you sure you want to cancel? The passenger will be notified.'),
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
    _locationTimer?.cancel();
    await updateRideStatus(widget.rideId, 'cancel');
    if (mounted) context.goNamed('DriverDashboard6');
  }

  Future<void> _markArrived() async {
    if (_isArriving) return;
    _locationTimer?.cancel();
    setState(() => _isArriving = true);
    // Fire-and-forget — don't block navigation on backend response
    markDriverArrived(widget.rideId, currentUserUid).then((ok) {
      print('[_markArrived] backend result: $ok');
    });
    // Always navigate to arrived screen; backend update is best-effort
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    context.pushNamed('ArrivedAtPickup9',
        queryParameters: {'rideId': widget.rideId});
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final ride = _rideData;

    final displayName = _passengerName.isNotEmpty ? _passengerName : 'Loading...';
    final initials = _initials(displayName);
    final fare = (ride?['fare'] ?? ride?['estimated_fare'] ?? ride?['price'] ?? '')
        .toString();
    final fareDisplay = (fare.isEmpty || fare == '0') ? '' : '₦$fare';
    final passengerPhone = _passengerPhone.isNotEmpty
        ? _passengerPhone
        : (ride?['passenger_phone'] ?? '').toString().trim();

    final initialPos = _pickupLatLng ??
        _myLatLng ??
        const gmaps.LatLng(6.5244, 3.3792);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // ── Native GoogleMap with route + markers ─────────────────────
            Positioned.fill(
              child: gmaps.GoogleMap(
                onMapCreated: (c) {
                  if (!_mapController.isCompleted) _mapController.complete(c);
                },
                initialCameraPosition: gmaps.CameraPosition(
                  target: initialPos,
                  zoom: 14,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: _markers,
                polylines: _polylines,
                mapType: gmaps.MapType.normal,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            // ── Top bar ───────────────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      _MapBtn(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground.withOpacity(0.88),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(
                                      color: theme.primary,
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Heading to Pickup',
                                  style: GoogleFonts.inter(
                                    color: theme.primaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            // ── Side buttons ──────────────────────────────────────────────
            Positioned(
              right: 16, bottom: 220,
              child: Column(
                children: [
                  _MapBtn(
                    icon: Icons.call_rounded,
                    onTap: () {
                      if (passengerPhone.isNotEmpty) {
                        launchUrl(Uri.parse('tel:$passengerPhone'));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _MapBtn(
                    icon: Icons.chat_bubble_rounded,
                    onTap: () {
                      if (passengerPhone.isNotEmpty) {
                        launchUrl(Uri.parse('sms:$passengerPhone'));
                      }
                    },
                  ),
                ],
              ),
            ),

            // ── Bottom card ───────────────────────────────────────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
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
                        margin: const EdgeInsets.only(bottom: 14),
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
                          width: 48, height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            initials,
                            style: GoogleFonts.inter(
                              color: theme.onSecondary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            displayName,
                            style: GoogleFonts.inter(
                              color: theme.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (fareDisplay.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Text(
                              fareDisplay,
                              style: GoogleFonts.inter(
                                color: theme.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Cancel Ride
                    SizedBox(
                      height: 40,
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
                    const SizedBox(height: 8),
                    // I've Arrived
                    GestureDetector(
                      onTap: _isArriving ? null : _markArrived,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isArriving
                              ? theme.primary.withOpacity(0.6)
                              : theme.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primary.withOpacity(0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isArriving
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
                                    "I've Arrived",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    if (p.isNotEmpty && p[0].isNotEmpty) return p[0][0].toUpperCase();
    return 'P';
  }
}

class _MapBtn extends StatelessWidget {
  const _MapBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: theme.primary, size: 20),
      ),
    );
  }
}
