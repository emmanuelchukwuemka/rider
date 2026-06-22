import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/place.dart';
import 'dart:async';
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

    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: false)
        .then((loc) {
      if (!mounted) return;
      safeSetState(() {
        currentUserLocationValue = loc;
        _model.placePickerValue1 = FFPlace(
          latLng: loc,
          name: 'Current Location',
          address: 'Current Location',
          city: '', state: '', country: '', zipCode: '',
        );
      });
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
                                  currentUserLocationValue != null
                                      ? 'Current Location'
                                      : 'Getting location…',
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    color: theme.primaryText,
                                    letterSpacing: 0.0,
                                  ),
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
                        if (dropoffLat == 0.0 && dropoffLng == 0.0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a destination from the suggestions')),
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
                        final pickupAddr = _model.placePickerValue1.address.isNotEmpty
                            ? _model.placePickerValue1.address
                            : _model.placePickerValue1.name.isNotEmpty
                                ? _model.placePickerValue1.name
                                : 'Current Location';
                        final dropoffAddr = _model.placePickerValue2.address.isNotEmpty
                            ? _model.placePickerValue2.address
                            : _model.placePickerValue2.name;
                        final requestData = {
                          'passenger_id': currentUserUid,
                          'pickupLat': pickupLat,
                          'pickupLng': pickupLng,
                          'dropoffLat': dropoffLat,
                          'dropoffLng': dropoffLng,
                          'pickupAddress': pickupAddr,
                          'dropoffAddress': dropoffAddr,
                          'ride_type': 'standard',
                          'payment_method': 'cash',
                        };
                        final rideResponse = await requestRide(requestData);
                        if (!mounted) return;
                        setState(() => _isRequesting = false);
                        if (rideResponse != null && rideResponse['ride'] != null) {
                          final rideId = rideResponse['ride']['_id'].toString();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('activeRideId', rideId);
                          await prefs.setString('activeRideStatus', 'pending');
                          if (!mounted) return;
                          context.pushNamed(
                            'PConfirmRide',
                            queryParameters: {'rideId': rideId},
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

  Widget _buildSuggestions(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _suggestions.length,
      separatorBuilder: (_, __) => Divider(height: 1.0, color: theme.alternate),
      itemBuilder: (context, index) {
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
