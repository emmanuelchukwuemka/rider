import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import '/auth/custom_auth/auth_util.dart';
import '/components/in_app_call/in_app_call_widget.dart';
import '/components/in_app_chat/in_app_chat_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'page12_trip_in_progress_model.dart';
export 'page12_trip_in_progress_model.dart';

class Page12TripInProgressWidget extends StatefulWidget {
  const Page12TripInProgressWidget({super.key, this.rideId = ''});

  final String rideId;

  static String routeName = 'Page12TripInProgress';
  static String routePath = '/page12TripInProgress';

  @override
  State<Page12TripInProgressWidget> createState() =>
      _Page12TripInProgressWidgetState();
}

class _Page12TripInProgressWidgetState
    extends State<Page12TripInProgressWidget> {
  late Page12TripInProgressModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<gmaps.GoogleMapController> _mapController = Completer();

  Map<String, dynamic>? _rideData;
  gmaps.LatLng? _myLatLng;
  gmaps.LatLng? _dropoffLatLng;
  Set<gmaps.Marker> _markers = {};
  Set<gmaps.Polyline> _polylines = {};

  String _etaText = '—';
  String _remainingText = '—';
  double _progress = 0.0;
  double _totalDistanceKm = 0;

  bool _isEnding = false;
  Timer? _locationTimer;

  static const _apiKey = 'AIzaSyAMK0gm6FqImxY1oLDQ72UcTuZzybFl7Lw';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page12TripInProgressModel());
    _init();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final loc = await getCurrentUserLocation(
        defaultLocation: const LatLng(6.5244, 3.3792), cached: false);
    if (!mounted) return;
    _myLatLng = gmaps.LatLng(loc.latitude, loc.longitude);

    if (widget.rideId.isNotEmpty) {
      final data = await fetchRideById(widget.rideId);
      if (!mounted) return;
      if (data != null) {
        final ride = data['ride'] ?? data;
        setState(() => _rideData = ride);

        _totalDistanceKm =
            _parseDouble(ride['distanceKm'] ?? ride['distance']) ?? 0;

        final lat = _parseDouble(ride['dropoffLat'] ?? ride['dropoff_lat']);
        final lng = _parseDouble(ride['dropoffLng'] ?? ride['dropoff_lng']);
        if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
          _dropoffLatLng = gmaps.LatLng(lat, lng);
          _updateMarker();
          if (_myLatLng != null) _fetchRoute(_myLatLng!, _dropoffLatLng!);
        }
      }
    }

    // Update driver location + route every 5 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final loc = await getCurrentUserLocation(
          defaultLocation: const LatLng(6.5244, 3.3792), cached: false);
      if (!mounted) return;
      _myLatLng = gmaps.LatLng(loc.latitude, loc.longitude);
      SocketService().updateLocation(loc.latitude, loc.longitude,
          driverId: currentUserUid);
      if (_dropoffLatLng != null) _fetchRoute(_myLatLng!, _dropoffLatLng!);
    });
  }

  void _updateMarker() {
    if (_dropoffLatLng == null) return;
    setState(() {
      _markers = {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('dropoff'),
          position: _dropoffLatLng!,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueRed),
          infoWindow: const gmaps.InfoWindow(title: 'Destination'),
        ),
      };
    });
  }

  Future<void> _fetchRoute(gmaps.LatLng origin, gmaps.LatLng dest) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${dest.latitude},${dest.longitude}'
          '&key=$_apiKey';
      final res = await http.get(Uri.parse(url));
      if (!mounted || res.statusCode != 200) return;
      final data = json.decode(res.body);
      final routes = data['routes'] as List?;
      if (routes == null || routes.isEmpty) return;

      final leg = routes[0]['legs']?[0];
      final durationSec =
          (leg?['duration']?['value'] as num?)?.toInt() ?? 0;
      final durationText = leg?['duration']?['text'] ?? '—';
      final distanceM =
          (leg?['distance']?['value'] as num?)?.toDouble() ?? 0;

      // ETA = now + remaining seconds
      final eta = DateTime.now().add(Duration(seconds: durationSec));
      final etaStr =
          '${eta.hour.toString().padLeft(2, '0')}:${eta.minute.toString().padLeft(2, '0')}';

      // Progress = proportion of total distance already covered
      final remainingKm = distanceM / 1000.0;
      double prog = 0.0;
      if (_totalDistanceKm > 0 && remainingKm < _totalDistanceKm) {
        prog = ((_totalDistanceKm - remainingKm) / _totalDistanceKm)
            .clamp(0.0, 1.0);
      }

      final encoded =
          routes[0]['overview_polyline']['points'] as String? ?? '';
      final points = _decodePolyline(encoded);
      if (!mounted) return;
      setState(() {
        _etaText = etaStr;
        _remainingText = durationText;
        _progress = prog;
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

      // Animate camera to fit both points
      if (_mapController.isCompleted) {
        final c = await _mapController.future;
        final bounds = gmaps.LatLngBounds(
          southwest: gmaps.LatLng(
            [origin.latitude, dest.latitude].reduce(math.min),
            [origin.longitude, dest.longitude].reduce(math.min),
          ),
          northeast: gmaps.LatLng(
            [origin.latitude, dest.latitude].reduce(math.max),
            [origin.longitude, dest.longitude].reduce(math.max),
          ),
        );
        c.animateCamera(gmaps.CameraUpdate.newLatLngBounds(bounds, 80));
      }
    } catch (e) {
      print('[TripInProgress] Route error: $e');
    }
  }

  List<gmaps.LatLng> _decodePolyline(String encoded) {
    final pts = <gmaps.LatLng>[];
    int i = 0, lat = 0, lng = 0;
    while (i < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(i++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(i++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      pts.add(gmaps.LatLng(lat / 1e5, lng / 1e5));
    }
    return pts;
  }

  double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }

  String get _passengerPhone =>
      (_rideData?['passenger_phone'] ?? '').toString().trim();

  Future<void> _callPassenger() async {
    final phone = _passengerPhone;
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passenger phone number not available')),
      );
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot call $phone')),
      );
    }
  }

  Future<void> _messagePassenger() async {
    final phone = _passengerPhone;
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passenger phone number not available')),
      );
      return;
    }
    final uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open messages for $phone')),
      );
    }
  }

  Future<void> _endRide() async {
    if (_isEnding) return;
    _locationTimer?.cancel();
    setState(() => _isEnding = true);

    bool ok = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken') ?? '';
      final res = await http.post(
        Uri.parse('$baseUrl/api/rides/${widget.rideId}/complete'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: json.encode({'driver_id': currentUserUid}),
      );
      ok = res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {}

    if (!ok) {
      ok = await updateRideStatus(
          widget.rideId, 'complete', {'driver_id': currentUserUid});
    }

    if (!mounted) return;
    context.pushNamed('PTripComplete',
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

    final passengerName =
        (ride?['passenger_name'] ?? ride?['passengerName'] ?? '')
            .toString()
            .trim();
    final displayName = passengerName.isNotEmpty ? passengerName : 'Passenger';
    final initials = _initials(displayName);

    final destination =
        (ride?['dropoff_address'] ?? ride?['dropoffAddress'] ?? '—')
            .toString()
            .trim();

    final initialPos = _dropoffLatLng ??
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
            // ── Full-screen native map with route ─────────────────────────
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

            // ── Top card: destination + ETA ───────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: theme.alternate, width: 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: theme.primaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: theme.alternate),
                              ),
                              child: Icon(Icons.arrow_back_rounded,
                                  color: theme.primaryText, size: 20.0),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'On the way to destination',
                                  style: theme.labelMedium.override(
                                    font: GoogleFonts.inter(),
                                    color: theme.secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                Text(
                                  destination,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.titleMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    color: theme.primaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_etaText != '—') ...[
                            const SizedBox(width: 12.0),
                            Container(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12.0, 8.0, 12.0, 8.0),
                              decoration: BoxDecoration(
                                color: theme.primary10,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _etaText,
                                    style: theme.titleMedium.override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold),
                                      color: theme.onPrimary,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  Text(
                                    'Arrival',
                                    style: theme.labelSmall.override(
                                      font: GoogleFonts.inter(),
                                      color: theme.onPrimary,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom card: progress + passenger + End Ride ──────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      24, 24, 24, MediaQuery.of(context).padding.bottom + 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress row
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _remainingText,
                                style: theme.titleMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.primaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                              Text(
                                _totalDistanceKm > 0
                                    ? '${_totalDistanceKm.toStringAsFixed(1)} km'
                                    : '',
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          LinearPercentIndicator(
                            percent: _progress,
                            lineHeight: 6.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: theme.primary,
                            backgroundColor: theme.alternate,
                            barRadius: const Radius.circular(3.0),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Passenger row
                      Row(
                        children: [
                          // Initials avatar (no hardcoded image)
                          Container(
                            width: 56.0,
                            height: 56.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: theme.primary, width: 2.0),
                            ),
                            child: Text(
                              initials,
                              style: GoogleFonts.inter(
                                color: theme.primary,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: theme.titleMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    color: theme.primaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star_rounded,
                                        color: theme.tertiary, size: 16.0),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      '5.0',
                                      style: theme.labelMedium.override(
                                        font: GoogleFonts.inter(),
                                        color: theme.secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              FlutterFlowIconButton(
                                borderColor: theme.alternate,
                                borderRadius: 8.0,
                                borderWidth: 1.0,
                                buttonSize: 40.0,
                                fillColor: theme.secondaryBackground,
                                icon: Icon(Icons.chat_bubble_rounded,
                                    color: theme.primary, size: 20.0),
                                onPressed: () {
                                  final ride = _rideData;
                                  final passengerName = (ride?['passenger_name'] ?? 'Passenger').toString().trim();
                                  final passengerId = (ride?['passenger_ref'] ?? '').toString();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => InAppChatWidget(
                                      rideId: widget.rideId,
                                      myId: currentUserUid,
                                      myName: 'Driver',
                                      myRole: 'driver',
                                      otherId: passengerId,
                                      otherName: passengerName.isNotEmpty ? passengerName : 'Passenger',
                                      otherRole: 'passenger',
                                    ),
                                  ));
                                },
                              ),
                              const SizedBox(width: 8.0),
                              FlutterFlowIconButton(
                                borderColor: theme.alternate,
                                borderRadius: 8.0,
                                borderWidth: 1.0,
                                buttonSize: 40.0,
                                fillColor: theme.secondaryBackground,
                                icon: Icon(Icons.call_rounded,
                                    color: theme.primary, size: 20.0),
                                onPressed: () {
                                  final ride = _rideData;
                                  final passengerName = (ride?['passenger_name'] ?? 'Passenger').toString().trim();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => InAppCallWidget(
                                      channelName: widget.rideId,
                                      callerName: 'Driver',
                                      receiverName: passengerName.isNotEmpty ? passengerName : 'Passenger',
                                    ),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Action buttons
                      Row(
                        children: [
                          FFButtonWidget(
                            onPressed: () {},
                            text: 'Safety',
                            options: FFButtonOptions(
                              width: 105.0,
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.zero,
                              color: Colors.transparent,
                              textStyle: theme.titleSmall.override(
                                font: GoogleFonts.interTight(),
                                color: const Color(0xFF158D0D),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                              elevation: 0.0,
                              borderSide:
                                  BorderSide(color: theme.alternate, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: GestureDetector(
                              onTap: _isEnding ? null : _endRide,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 40.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _isEnding
                                      ? const Color(0xFFE32023).withOpacity(0.6)
                                      : const Color(0xFFE32023),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _isEnding
                                    ? const SizedBox(
                                        width: 18, height: 18,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0))
                                    : Text(
                                        'End Ride',
                                        style: GoogleFonts.interTight(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
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
