import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:url_launcher/url_launcher.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/custom_auth/auth_util.dart';
import 'p_driver_on_the_way_model.dart';
export 'p_driver_on_the_way_model.dart';

class PDriverOnTheWayWidget extends StatefulWidget {
  const PDriverOnTheWayWidget({super.key, this.rideId = ''});
  final String rideId;

  static String routeName = 'PDriverOnTheWay';
  static String routePath = '/pDriverOnTheWay';

  @override
  State<PDriverOnTheWayWidget> createState() => _PDriverOnTheWayWidgetState();
}

class _PDriverOnTheWayWidgetState extends State<PDriverOnTheWayWidget> {
  late PDriverOnTheWayModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<gmaps.GoogleMapController> _mapController = Completer();

  Map<String, dynamic>? _rideData;
  Map<String, dynamic>? _driverData;
  gmaps.LatLng? _driverLatLng;     // driver's live position
  gmaps.LatLng? _myLatLng;         // passenger's own position
  Set<gmaps.Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PDriverOnTheWayModel());

    // Connect as passenger to receive driver location updates
    SocketService().initSocket(currentUserUid, 'passenger');

    SocketService().onDriverLocationUpdated = (data) {
      if (!mounted) return;
      final lat = double.tryParse(data['lat']?.toString() ?? '');
      final lng = double.tryParse(data['lng']?.toString() ?? '');
      if (lat != null && lng != null) {
        final pos = gmaps.LatLng(lat, lng);
        setState(() {
          _driverLatLng = pos;
          _updateMarkers();
        });
        // Animate camera to keep driver in view
        if (_mapController.isCompleted) {
          _mapController.future.then(
              (c) => c.animateCamera(gmaps.CameraUpdate.newLatLng(pos)));
        }
      }
    };

    // When driver marks arrived, auto-navigate passenger
    SocketService().onDriverArrived = (data) {
      if (!mounted) return;
      context.pushNamed('PDriverArrived',
          queryParameters: {'rideId': widget.rideId});
    };

    _initData();
  }

  Future<void> _initData() async {
    // Get passenger's own GPS location
    final loc = await getCurrentUserLocation(
        defaultLocation: const LatLng(6.5244, 3.3792), cached: false);
    if (!mounted) return;
    setState(() => _myLatLng = gmaps.LatLng(loc.latitude, loc.longitude));

    // Fetch ride data
    if (widget.rideId.isNotEmpty) {
      final data = await fetchRideById(widget.rideId);
      if (!mounted) return;
      if (data != null) {
        final ride = data['ride'] ?? data;
        setState(() => _rideData = ride);

        // Fetch driver profile for name/vehicle
        final driverId = ride['driver_ref']?.toString() ??
            ride['driver_id']?.toString() ??
            ride['driverId']?.toString() ??
            ride['driver']?['_id']?.toString() ?? '';
        if (driverId.isNotEmpty) {
          final driverData = await fetchDriverById(driverId);
          if (!mounted) return;
          if (driverData != null) {
            setState(() => _driverData = driverData['driver'] ?? driverData);
          }
        }
      }
    }
  }

  void _updateMarkers() {
    final markers = <gmaps.Marker>{};
    if (_driverLatLng != null) {
      markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId('driver'),
        position: _driverLatLng!,
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueGreen),
        infoWindow: const gmaps.InfoWindow(title: 'Your Driver'),
      ));
    }
    if (_myLatLng != null) {
      markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId('pickup'),
        position: _myLatLng!,
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueBlue),
        infoWindow: const gmaps.InfoWindow(title: 'Your Pickup'),
      ));
    }
    _markers = markers;
  }

  @override
  void dispose() {
    SocketService().onDriverLocationUpdated = null;
    SocketService().onDriverArrived = null;
    _model.dispose();
    super.dispose();
  }

  Future<void> _cancelRide() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await updateRideStatus(widget.rideId, 'cancel');
    if (mounted) context.goNamed('PassengersDashboardnew');
  }

  void _callDriver(String phone) {
    if (phone.isEmpty) return;
    launchUrl(Uri.parse('tel:$phone'));
  }

  void _smsDriver(String phone) {
    if (phone.isEmpty) return;
    launchUrl(Uri.parse('sms:$phone'));
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    if (p.isNotEmpty && p[0].isNotEmpty) return p[0][0].toUpperCase();
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final ride = _rideData;
    final driver = _driverData;

    final driverName = (driver?['display_name'] ??
            driver?['name'] ??
            ride?['driver']?['display_name'] ??
            ride?['driver_name'] ??
            '')
        .toString()
        .trim();
    final displayName = driverName.isNotEmpty ? driverName : 'Driver';
    final initials = _initials(displayName);
    final driverRating =
        (driver?['driver_rating'] ?? driver?['rating'] ?? '').toString();
    final vehicle = (driver?['vehicle_model'] ??
            driver?['car_model'] ??
            driver?['vehicle'] ??
            '')
        .toString()
        .trim();
    final plate = (driver?['plate_number'] ??
            driver?['license_plate'] ??
            driver?['vehicle_plate'] ??
            '')
        .toString()
        .trim();

    final driverPhone = (driver?['phone_number'] ?? driver?['phone'] ?? '').toString().trim();
    final mapCenter = _driverLatLng ?? _myLatLng ?? const gmaps.LatLng(6.5244, 3.3792);

    _updateMarkers();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // ── Map showing driver's live position ────────────────────────
            Positioned.fill(
              child: gmaps.GoogleMap(
                onMapCreated: (c) {
                  if (!_mapController.isCompleted) _mapController.complete(c);
                },
                initialCameraPosition: gmaps.CameraPosition(
                  target: mapCenter,
                  zoom: 14,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
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
                      _CircleBtn(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Driver status badge ───────────────────────────────────────
            Positioned(
              top: 90, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Driver is on the way',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_driverLatLng == null)
                        Text(
                          'Waiting for location…',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom driver info card ───────────────────────────────────
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

                    // Driver row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          width: 56, height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            initials,
                            style: GoogleFonts.inter(
                              color: theme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Name + rating
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (driverRating.isNotEmpty &&
                                  driverRating != '0') ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.star_rounded,
                                        color: const Color(0xFFF59E0B),
                                        size: 14),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        vehicle.isNotEmpty
                                            ? '$driverRating • $vehicle'
                                            : driverRating,
                                        style: GoogleFonts.inter(
                                          color: theme.secondaryText,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else if (vehicle.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  vehicle,
                                  style: GoogleFonts.inter(
                                    color: theme.secondaryText,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Chat + call
                        Row(
                          children: [
                            _CircleBtn(
                              icon: Icons.chat_bubble_rounded,
                              onTap: () => _smsDriver(driverPhone),
                            ),
                            const SizedBox(width: 8),
                            _CircleBtn(
                              icon: Icons.phone_rounded,
                              onTap: () => _callDriver(driverPhone),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Plate number card
                    if (plate.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: theme.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_car_rounded,
                                color: theme.primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              vehicle.isNotEmpty
                                  ? '$plate • $vehicle'
                                  : plate,
                              style: GoogleFonts.inter(
                                color: theme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushNamed('PDriverArrived',
                            queryParameters: {'rideId': widget.rideId}),
                        icon: const Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 18),
                        label: Text(
                          'Driver Arrived',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 42,
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
        width: 40, height: 40,
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
