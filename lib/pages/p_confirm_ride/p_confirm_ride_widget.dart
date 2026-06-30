import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'p_confirm_ride_model.dart';
export 'p_confirm_ride_model.dart';

class PConfirmRideWidget extends StatefulWidget {
  const PConfirmRideWidget({
    super.key,
    this.rideId = '',
    this.pickupLat = 0.0,
    this.pickupLng = 0.0,
    this.dropoffLat = 0.0,
    this.dropoffLng = 0.0,
    this.pickupAddress = '',
    this.dropoffAddress = '',
    this.fare = 0.0,
    this.distanceKm = 0.0,
  });

  final String rideId;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String pickupAddress;
  final String dropoffAddress;
  final double fare;
  final double distanceKm;

  static String routeName = 'PConfirmRide';
  static String routePath = '/pConfirmRide';

  @override
  State<PConfirmRideWidget> createState() => _PConfirmRideWidgetState();
}

class _PConfirmRideWidgetState extends State<PConfirmRideWidget> {
  late PConfirmRideModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  Set<gmaps.Marker> _markers = {};
  Set<gmaps.Polyline> _polylines = {};

  static const String _mapsApiKey = 'AIzaSyBxfvdzTRzp_I7ce4KOg7ZX8ZcJntgUbhM';

  gmaps.LatLng get _pickupLatLng =>
      gmaps.LatLng(widget.pickupLat, widget.pickupLng);
  gmaps.LatLng get _dropoffLatLng =>
      gmaps.LatLng(widget.dropoffLat, widget.dropoffLng);

  bool get _hasPickup => widget.pickupLat != 0.0 || widget.pickupLng != 0.0;
  bool get _hasDropoff =>
      widget.dropoffLat != 0.0 || widget.dropoffLng != 0.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PConfirmRideModel());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildMapContent();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _buildMapContent() async {
    if (!_hasPickup) return;

    final theme = FlutterFlowTheme.of(context);

    final pickupIcon = await gmaps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/pickup_marker.png',
    ).catchError((_) => gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueGreen));

    final dropoffIcon = await gmaps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/dropoff_marker.png',
    ).catchError((_) => gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueRed));

    final markers = <gmaps.Marker>{
      gmaps.Marker(
        markerId: const gmaps.MarkerId('pickup'),
        position: _pickupLatLng,
        icon: pickupIcon,
        infoWindow: gmaps.InfoWindow(title: 'Pickup'),
      ),
    };

    if (_hasDropoff) {
      markers.add(gmaps.Marker(
        markerId: const gmaps.MarkerId('dropoff'),
        position: _dropoffLatLng,
        icon: dropoffIcon,
        infoWindow: gmaps.InfoWindow(title: 'Destination'),
      ));
      _fetchRoute();
    }

    if (mounted) setState(() => _markers = markers);

    // Animate camera to fit both points
    final ctrl = await _mapController.future;
    if (_hasDropoff) {
      final bounds = gmaps.LatLngBounds(
        southwest: gmaps.LatLng(
          math.min(widget.pickupLat, widget.dropoffLat),
          math.min(widget.pickupLng, widget.dropoffLng),
        ),
        northeast: gmaps.LatLng(
          math.max(widget.pickupLat, widget.dropoffLat),
          math.max(widget.pickupLng, widget.dropoffLng),
        ),
      );
      ctrl.animateCamera(
          gmaps.CameraUpdate.newLatLngBounds(bounds, 60));
    } else {
      ctrl.animateCamera(
          gmaps.CameraUpdate.newLatLngZoom(_pickupLatLng, 15));
    }
  }

  Future<void> _fetchRoute() async {
    if (!_hasPickup || !_hasDropoff) return;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${widget.pickupLat},${widget.pickupLng}'
        '&destination=${widget.dropoffLat},${widget.dropoffLng}'
        '&key=$_mapsApiKey',
      );
      final resp = await http.get(url).timeout(const Duration(seconds: 10));
      if (!mounted) return;
      final data = json.decode(resp.body);
      final routes = data['routes'] as List?;
      if (routes == null || routes.isEmpty) return;
      final points = routes[0]['overview_polyline']['points'] as String;
      final decoded = _decodePolyline(points);
      if (mounted) {
        setState(() {
          _polylines = {
            gmaps.Polyline(
              polylineId: const gmaps.PolylineId('route'),
              points: decoded,
              color: FlutterFlowTheme.of(context).primary,
              width: 4,
            ),
          };
        });
      }
    } catch (_) {}
  }

  List<gmaps.LatLng> _decodePolyline(String encoded) {
    final result = <gmaps.LatLng>[];
    int idx = 0, lat = 0, lng = 0;
    while (idx < encoded.length) {
      int b, shift = 0, result0 = 0;
      do {
        b = encoded.codeUnitAt(idx++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1);
      shift = 0;
      result0 = 0;
      do {
        b = encoded.codeUnitAt(idx++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1);
      result.add(gmaps.LatLng(lat / 1e5, lng / 1e5));
    }
    return result;
  }

  String get _fareStr {
    if (widget.fare <= 0) return '—';
    return '₦${widget.fare.toStringAsFixed(0)}';
  }

  String get _distanceStr {
    if (widget.distanceKm <= 0) return '—';
    return '${widget.distanceKm.toStringAsFixed(1)} km';
  }

  String get _pickupDisplay =>
      widget.pickupAddress.isNotEmpty ? widget.pickupAddress : 'Current Location';

  String get _dropoffDisplay =>
      widget.dropoffAddress.isNotEmpty ? widget.dropoffAddress : 'Destination';

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // ── Scrollable content ──────────────────────────────────────
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Map ───────────────────────────────────────────────
                  SizedBox(
                    height: 280,
                    child: Stack(
                      children: [
                        gmaps.GoogleMap(
                          initialCameraPosition: gmaps.CameraPosition(
                            target: _hasPickup
                                ? _pickupLatLng
                                : const gmaps.LatLng(6.5244, 3.3792),
                            zoom: 14,
                          ),
                          onMapCreated: (ctrl) {
                            if (!_mapController.isCompleted) {
                              _mapController.complete(ctrl);
                            }
                          },
                          markers: _markers,
                          polylines: _polylines,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                        ),
                        // Gradient fade at bottom
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.55, 1.0],
                                colors: [
                                  Colors.transparent,
                                  theme.primaryBackground,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: 48,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Icon(Icons.arrow_back_rounded,
                                  color: theme.primaryText, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Details ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Pickup / Dropoff
                        Container(
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: theme.alternate, width: 1),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _locationRow(
                                theme,
                                icon: Icons.radio_button_checked,
                                iconColor: theme.primary,
                                label: 'Pickup',
                                address: _pickupDisplay,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 11),
                                child: Container(
                                    height: 28,
                                    width: 1.5,
                                    color: theme.alternate),
                              ),
                              _locationRow(
                                theme,
                                icon: Icons.location_on_rounded,
                                iconColor: theme.error,
                                label: 'Destination',
                                address: _dropoffDisplay,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Ride type + fare
                        Container(
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: theme.alternate, width: 1),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: theme.primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Icon(Icons.directions_car_rounded,
                                    color: theme.primary, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('QuickDrop',
                                        style: theme.titleMedium.override(
                                          font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600),
                                          color: theme.primaryText,
                                          letterSpacing: 0,
                                        )),
                                    const SizedBox(height: 2),
                                    Text(
                                      _distanceStr,
                                      style: theme.bodySmall.override(
                                        font: GoogleFonts.inter(),
                                        color: theme.secondaryText,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _fareStr,
                                style: theme.titleLarge.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                  color: theme.primary,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Payment method
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Method',
                                style: theme.labelLarge.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.secondaryText,
                                  letterSpacing: 0,
                                )),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: theme.alternate, width: 1),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: theme.primary,
                                      size: 24),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Personal Wallet',
                                            style: theme.bodyMedium.override(
                                              font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600),
                                              letterSpacing: 0,
                                            )),
                                        Text('Cash on delivery',
                                            style: theme.bodySmall.override(
                                              font: GoogleFonts.inter(),
                                              color: theme.secondaryText,
                                              letterSpacing: 0,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded,
                                      color: theme.secondaryText, size: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Confirm button (fixed bottom) ───────────────────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: theme.secondaryBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 1, color: theme.alternate),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                      child: FFButtonWidget(
                        onPressed: () {
                          context.pushNamed(
                            'Page10SearchingforDriverr',
                            queryParameters: {
                              'rideId': serializeParam(widget.rideId, ParamType.String),
                              'pickupAddress': serializeParam(widget.pickupAddress, ParamType.String),
                              'fare': serializeParam(widget.fare, ParamType.double),
                            },
                          );
                        },
                        text: 'Confirm QuickDrop ✦',
                        options: FFButtonOptions(
                          height: 52,
                          color: theme.primary,
                          textStyle: theme.titleSmall.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600),
                            color: theme.onPrimary,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                          borderRadius: BorderRadius.circular(12),
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

  Widget _locationRow(
    FlutterFlowTheme theme, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.labelSmall.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    letterSpacing: 0,
                  )),
              const SizedBox(height: 2),
              Text(
                address,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: theme.primaryText,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
