import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/backend/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/place.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'page6_set_destination_model.dart';
export 'page6_set_destination_model.dart';

class Page6SetDestinationWidget extends StatefulWidget {
  const Page6SetDestinationWidget({super.key, this.mapDropoff});

  final LatLng? mapDropoff;

  static String routeName = 'Page6SetDestination';
  static String routePath = '/page6SetDestination';

  @override
  State<Page6SetDestinationWidget> createState() =>
      _Page6SetDestinationWidgetState();
}

class _Page6SetDestinationWidgetState
    extends State<Page6SetDestinationWidget> {
  late Page6SetDestinationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  String? _resolvedPickupAddress;

  final TextEditingController _dropoffController = TextEditingController();
  final FocusNode _dropoffFocus = FocusNode();

  List<Prediction> _suggestions = [];
  bool _isSearching = false;
  bool _isRequesting = false;
  Timer? _debounce;

  static const String _placesApiKey = 'AIzaSyAMK0gm6FqImxY1oLDQ72UcTuZzybFl7Lw';

  String get _apiKey => _placesApiKey;

  late GoogleMapsPlaces _places;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page6SetDestinationModel());
    _places = GoogleMapsPlaces(apiKey: _apiKey);

    // Connect socket early so it's registered before the ride request is sent
    SocketService().initSocket(currentUserUid, 'passenger');

    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: false)
        .then((loc) async {
      if (!mounted) return;
      // Set coords immediately so the map centers
      safeSetState(() {
        currentUserLocationValue = loc;
        _model.placePickerValue1 = FFPlace(
          latLng: loc,
          name: 'Current Location',
          address: '',
          city: '', state: '', country: '', zipCode: '',
        );
      });
      // Resolve real address in background
      if (loc.latitude != 0.0 || loc.longitude != 0.0) {
        final addr = await _reverseGeocode(loc.latitude, loc.longitude);
        if (addr != null && mounted) {
          safeSetState(() {
            _resolvedPickupAddress = addr;
            _model.placePickerValue1 = FFPlace(
              latLng: loc,
              name: addr,
              address: addr,
              city: '', state: '', country: '', zipCode: '',
            );
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dropoffFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _dropoffController.dispose();
    _dropoffFocus.dispose();
    _places.dispose();
    _model.dispose();
    super.dispose();
  }

  double _haversineKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLng = (lng2 - lng1) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _calculateFare(double distanceKm) {
    // Base fare ₦500 + ₦150/km
    return 500 + (distanceKm * 150);
  }

  void _onDropoffChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      setState(() => _isSearching = true);
      final loc = currentUserLocationValue;
      final result = await _places.autocomplete(
        query,
        language: 'en',
        location: loc != null
            ? Location(lat: loc.latitude, lng: loc.longitude)
            : null,
        radius: loc != null ? 50000 : null, // 50km bias around user
      );
      if (!mounted) return;
      setState(() {
        _suggestions = result.isOkay ? result.predictions : [];
        _isSearching = false;
      });
    });
  }

  void _useTypedAddress() {
    final text = _dropoffController.text.trim();
    if (text.isEmpty) return;
    safeSetState(() {
      _model.placePickerValue2 = FFPlace(
        latLng: const LatLng(0, 0),
        name: text,
        address: text,
        city: '', state: '', country: '', zipCode: '',
      );
      _suggestions = [];
    });
    _dropoffFocus.unfocus();
  }

  Future<void> _selectDropoff(Prediction p) async {
    if (p.placeId == null) return;
    setState(() => _isSearching = true);
    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    if (!mounted) return;
    final loc = detail.result.geometry?.location;
    final name = detail.result.name.isNotEmpty
        ? detail.result.name
        : p.structuredFormatting?.mainText ?? p.description ?? '';
    final address = detail.result.formattedAddress?.isNotEmpty == true
        ? detail.result.formattedAddress!
        : p.description ?? name;
    safeSetState(() {
      _model.placePickerValue2 = FFPlace(
        latLng: LatLng(loc?.lat ?? 0, loc?.lng ?? 0),
        name: name,
        address: address,
        city: '', state: '', country: '', zipCode: '',
      );
      _dropoffController.text = name;
      _suggestions = [];
      _isSearching = false;
    });
    _dropoffFocus.unfocus();
  }

  static const String _mapsApiKey = 'AIzaSyBxfvdzTRzp_I7ce4KOg7ZX8ZcJntgUbhM';

  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_mapsApiKey');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'OK' &&
            (data['results'] as List).isNotEmpty) {
          return (data['results'] as List)[0]['formatted_address'] as String?;
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => _suggestions = []);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 16.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Row(
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(Icons.arrow_back_rounded,
                                color: theme.primaryText, size: 24.0),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 16.0),
                          Text('Where to?',
                              style: theme.titleLarge.override(
                                font: GoogleFonts.inter(
                                    fontWeight: theme.titleLarge.fontWeight,
                                    fontStyle: theme.titleLarge.fontStyle),
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                                lineHeight: 1.3,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 1.0, color: theme.alternate),
                ],
              ),
            ),

            // ── Location card ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.alternate, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Pickup row — read-only, shows current GPS location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24.0,
                            child: Center(
                              child: Container(
                                width: 10.0, height: 10.0,
                                decoration: BoxDecoration(
                                  color: theme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pickup',
                                    style: theme.labelSmall.override(
                                      font: GoogleFonts.inter(),
                                      color: theme.secondaryText,
                                      letterSpacing: 0.0,
                                    )),
                                const SizedBox(height: 2.0),
                                Text(
                                  _resolvedPickupAddress != null
                                      ? _resolvedPickupAddress!
                                      : currentUserLocationValue != null
                                          ? 'Getting address…'
                                          : 'Getting location…',
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    color: theme.primaryText,
                                    letterSpacing: 0.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (currentUserLocationValue == null)
                            SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: theme.primary,
                              ),
                            )
                          else
                            Icon(Icons.my_location_rounded,
                                color: theme.primary, size: 18.0),
                        ],
                      ),

                      // Connector line
                      Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Row(
                          children: [
                            Container(width: 1.0, height: 20.0, color: theme.alternate),
                            Expanded(child: Divider(height: 20.0, thickness: 1.0, color: theme.alternate)),
                          ],
                        ),
                      ),

                      // Dropoff row — editable with autocomplete
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24.0,
                            child: Center(
                              child: Container(
                                width: 10.0, height: 10.0,
                                decoration: BoxDecoration(
                                  color: theme.secondary,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Drop-off',
                                    style: theme.labelSmall.override(
                                      font: GoogleFonts.inter(),
                                      color: theme.secondaryText,
                                      letterSpacing: 0.0,
                                    )),
                                const SizedBox(height: 2.0),
                                TextField(
                                  controller: _dropoffController,
                                  focusNode: _dropoffFocus,
                                  onChanged: _onDropoffChanged,
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    color: theme.primaryText,
                                    letterSpacing: 0.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Where to?',
                                    hintStyle: theme.bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: theme.secondaryText,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_dropoffController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() {
                                _dropoffController.clear();
                                _model.placePickerValue2 = const FFPlace();
                                _suggestions = [];
                              }),
                              child: Icon(Icons.clear, size: 18.0, color: theme.secondaryText),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Suggestions / Recent places ──────────────────────────────
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _suggestions.isNotEmpty
                      ? _buildSuggestions(context)
                      : _buildRecentSection(context),
            ),

            // ── Confirm button ───────────────────────────────────────────
            Container(
              color: theme.primaryBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: 1.0, color: theme.alternate),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FFButtonWidget(
                      onPressed: _isRequesting ? null : () async {
                        final pickupLat = _model.placePickerValue1.latLng.latitude;
                        final pickupLng = _model.placePickerValue1.latLng.longitude;
                        if (pickupLat == 0.0 && pickupLng == 0.0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Waiting for your current location…')),
                          );
                          return;
                        }
                        final dropoffLat = _model.placePickerValue2.latLng.latitude;
                        final dropoffLng = _model.placePickerValue2.latLng.longitude;
                        final typedText = _dropoffController.text.trim();
                        final hasDropoffCoords = !(dropoffLat == 0.0 && dropoffLng == 0.0);
                        // Allow proceeding with a typed address even if it's not on the map
                        if (!hasDropoffCoords && typedText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter or select a destination')),
                          );
                          return;
                        }
                        if (currentUserUid.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please log in again to request a ride.')),
                          );
                          return;
                        }
                        setState(() => _isRequesting = true);
                        String pickupAddr = _model.placePickerValue1.address.isNotEmpty
                            ? _model.placePickerValue1.address
                            : _model.placePickerValue1.name.isNotEmpty
                                ? _model.placePickerValue1.name
                                : '';
                        if (pickupAddr.isEmpty) {
                          pickupAddr = await _reverseGeocode(pickupLat, pickupLng) ?? 'Current Location';
                        }
                        // If no autocomplete result was selected, fall back to typed text
                        final dropoffAddr = hasDropoffCoords
                            ? (_model.placePickerValue2.address.isNotEmpty
                                ? _model.placePickerValue2.address
                                : _model.placePickerValue2.name)
                            : typedText;
                        final effectiveDropoffLat = hasDropoffCoords ? dropoffLat : 0.0;
                        final effectiveDropoffLng = hasDropoffCoords ? dropoffLng : 0.0;
                        final distKm = (hasDropoffCoords && pickupLat != 0 && pickupLng != 0)
                            ? _haversineKm(pickupLat, pickupLng, effectiveDropoffLat, effectiveDropoffLng)
                            : 0.0;
                        final fare = _calculateFare(distKm);
                        final requestData = {
                          'passenger_id': currentUserUid,
                          'pickupLat': pickupLat,
                          'pickupLng': pickupLng,
                          'dropoffLat': effectiveDropoffLat,
                          'dropoffLng': effectiveDropoffLng,
                          'pickupAddress': pickupAddr,
                          'dropoffAddress': dropoffAddr,
                          'ride_type': 'standard',
                          'payment_method': 'cash',
                          'final_fare': fare,
                          'distanceKm': distKm,
                        };
                        final rideResponse = await requestRide(requestData);
                        if (!mounted) return;
                        setState(() => _isRequesting = false);
                        if (rideResponse != null && rideResponse['ride'] != null) {
                          final ride = rideResponse['ride'] as Map<String, dynamic>;
                          final rideId = ride['_id']?.toString() ?? ride['id']?.toString() ?? '';
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('activeRideId', rideId);
                          await prefs.setString('activeRideStatus', 'pending');
                          // Use locally calculated values (backend may return 0 at creation time)
                          final fareDouble = fare;
                          final distDouble = distKm;
                          if (!mounted) return;
                          context.pushNamed(
                            'PConfirmRide',
                            queryParameters: {
                              'rideId': serializeParam(rideId, ParamType.String),
                              'pickupLat': serializeParam(pickupLat, ParamType.double),
                              'pickupLng': serializeParam(pickupLng, ParamType.double),
                              'dropoffLat': serializeParam(effectiveDropoffLat, ParamType.double),
                              'dropoffLng': serializeParam(effectiveDropoffLng, ParamType.double),
                              'pickupAddress': serializeParam(pickupAddr, ParamType.String),
                              'dropoffAddress': serializeParam(dropoffAddr, ParamType.String),
                              'fare': serializeParam(fareDouble, ParamType.double),
                              'distanceKm': serializeParam(distDouble, ParamType.double),
                            },
                          );
                        } else {
                          final errorMsg = rideResponse?['_error'] ?? 'Failed to request ride. Please try again.';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMsg),
                              duration: const Duration(seconds: 6),
                            ),
                          );
                        }
                      },
                      text: _isRequesting ? 'Finding your ride…' : 'Confirm Destination',
                      options: FFButtonOptions(
                        height: 50.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _useTypedAddressRow(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final text = _dropoffController.text.trim();
    if (text.isEmpty) return const SizedBox.shrink();
    return InkWell(
      onTap: _useTypedAddress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.edit_location_alt_outlined,
                  color: theme.primary, size: 20.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use "$text"',
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: theme.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Continue with this address as typed',
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return ListView.separated(
      padding: EdgeInsets.zero,
      // +1 for the "use typed address" row at the bottom
      itemCount: _suggestions.length + 1,
      separatorBuilder: (_, __) => Divider(height: 1.0, color: theme.alternate),
      itemBuilder: (context, index) {
        if (index == _suggestions.length) {
          return _useTypedAddressRow(context);
        }
        final p = _suggestions[index];
        final main = p.structuredFormatting?.mainText ?? p.description ?? '';
        final secondary = p.structuredFormatting?.secondaryText ?? '';
        return InkWell(
          onTap: () => _selectDropoff(p),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Icons.location_on_outlined,
                      color: theme.secondaryText, size: 20.0),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(main,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            color: theme.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (secondary.isNotEmpty) ...[
                        const SizedBox(height: 2.0),
                        Text(secondary,
                            style: theme.bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: theme.secondaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasTyped = _dropoffController.text.trim().isNotEmpty;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTyped) ...[
            _useTypedAddressRow(context),
            Divider(height: 1.0, color: theme.alternate),
          ],
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 12.0),
            child: Text('Recent places',
                style: theme.labelLarge.override(
                  font: GoogleFonts.inter(),
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                )),
          ),
          for (final entry in [
            [Icons.home_rounded, 'Home', 'Add home address'],
            [Icons.work_rounded, 'Work', 'Add work address'],
          ])
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 4.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(entry[0] as IconData,
                        color: theme.primaryText, size: 20.0),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry[1] as String,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            color: theme.primaryText,
                          )),
                      Text(entry[2] as String,
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: theme.secondaryText,
                          )),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
