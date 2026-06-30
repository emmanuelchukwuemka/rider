import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/place.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '/backend/schema/util/mock_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'page7_schedule_ride_model.dart';
export 'page7_schedule_ride_model.dart';

class Page7ScheduleRideWidget extends StatefulWidget {
  const Page7ScheduleRideWidget({
    super.key,
    this.ride,
    this.mapDropoff,
  });

  final DocumentReference? ride;
  final LatLng? mapDropoff;

  static String routeName = 'Page7ScheduleRide';
  static String routePath = '/page7ScheduleRide';

  @override
  State<Page7ScheduleRideWidget> createState() =>
      _Page7ScheduleRideWidgetState();
}

class _Page7ScheduleRideWidgetState extends State<Page7ScheduleRideWidget> {
  late Page7ScheduleRideModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;

  static const String _placesApiKey = 'AIzaSyAMK0gm6FqImxY1oLDQ72UcTuZzybFl7Lw';
  String get _apiKey => _placesApiKey;
  late GoogleMapsPlaces _places;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page7ScheduleRideModel());
    _places = GoogleMapsPlaces(apiKey: _apiKey);

    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: false).then((loc) {
      if (!mounted) return;
      safeSetState(() {
        currentUserLocationValue = loc;
        _model.placePickerValue1 = FFPlace(
          latLng: loc,
          name: 'Current Location',
          address: 'Current Location',
          city: '',
          state: '',
          country: '',
          zipCode: '',
        );
      });
    });

    if (widget.mapDropoff != null) {
      _model.placePickerValue2 = FFPlace(
        latLng: widget.mapDropoff!,
        name: 'Selected on Map',
        address: 'Selected on Map',
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _places.dispose();
    _model.dispose();
    super.dispose();
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _calculateFare(double distanceKm) => 500 + (distanceKm * 150);

  Future<void> _openLocationSearch(bool isPickup) async {
    final theme = FlutterFlowTheme.of(context);
    final TextEditingController searchController = TextEditingController();
    List<Prediction> suggestions = [];
    bool searching = false;
    Timer? debounce;

    final selected = await showModalBottomSheet<FFPlace>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          void onChanged(String query) {
            debounce?.cancel();
            if (query.isEmpty) {
              setModalState(() => suggestions = []);
              return;
            }
            debounce = Timer(const Duration(milliseconds: 350), () async {
              setModalState(() => searching = true);
              final result = await _places.autocomplete(query, language: 'en');
              setModalState(() {
                suggestions = result.isOkay ? result.predictions : [];
                searching = false;
              });
            });
          }

          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) => Container(
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.alternate, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      onChanged: onChanged,
                      style: theme.bodyMedium.override(font: GoogleFonts.inter(), color: theme.primaryText),
                      decoration: InputDecoration(
                        hintText: isPickup ? 'Pickup location' : 'Destination',
                        hintStyle: theme.bodyMedium.override(font: GoogleFonts.inter(), color: theme.secondaryText),
                        prefixIcon: Icon(Icons.search, color: theme.secondaryText),
                        filled: true,
                        fillColor: theme.secondaryBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: searching
                        ? const Center(child: CircularProgressIndicator())
                        : suggestions.isEmpty
                            ? Center(child: Text(searchController.text.isEmpty ? 'Start typing to search' : 'No results', style: theme.bodyMedium.override(font: GoogleFonts.inter(), color: theme.secondaryText)))
                            : ListView.separated(
                                controller: scrollController,
                                itemCount: suggestions.length,
                                separatorBuilder: (_, __) => Divider(height: 1, color: theme.alternate),
                                itemBuilder: (_, i) {
                                  final p = suggestions[i];
                                  return ListTile(
                                    leading: Icon(Icons.location_on_outlined, color: theme.secondaryText),
                                    title: Text(p.structuredFormatting?.mainText ?? p.description ?? '', style: theme.bodyMedium.override(font: GoogleFonts.inter(fontWeight: FontWeight.w600), color: theme.primaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    subtitle: Text(p.structuredFormatting?.secondaryText ?? '', style: theme.bodySmall.override(font: GoogleFonts.inter(), color: theme.secondaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    onTap: () async {
                                      if (p.placeId == null) return;
                                      final detail = await _places.getDetailsByPlaceId(p.placeId!);
                                      final loc = detail.result.geometry?.location;
                                      final place = FFPlace(
                                        latLng: LatLng(loc?.lat ?? 0, loc?.lng ?? 0),
                                        name: detail.result.name,
                                        address: detail.result.formattedAddress ?? '',
                                        city: '',
                                        state: '',
                                        country: '',
                                        zipCode: '',
                                      );
                                      Navigator.pop(ctx, place);
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );

    debounce?.cancel();
    if (selected != null && mounted) {
      safeSetState(() {
        if (isPickup) {
          _model.placePickerValue1 = selected;
        } else {
          _model.placePickerValue2 = selected;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  fillColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    context.safePop();
                                  },
                                ),
                                Text(
                                  'Schedule a Ride',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                        lineHeight: 1.3,
                                      ),
                                ),
                              ].divide(SizedBox(width: 16.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Pickup location field
                              GestureDetector(
                                onTap: () => _openLocationSearch(true),
                                child: Row(
                                  children: [
                                    Icon(Icons.my_location_rounded, color: FlutterFlowTheme.of(context).primary, size: 20.0),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                                        ),
                                        child: Text(
                                          _model.placePickerValue1.name.isNotEmpty ? _model.placePickerValue1.name : 'Pickup Location',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            font: GoogleFonts.inter(),
                                            color: _model.placePickerValue1.name.isNotEmpty ? FlutterFlowTheme.of(context).primaryText : FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Dropoff location field
                              GestureDetector(
                                onTap: () => _openLocationSearch(false),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_rounded, color: FlutterFlowTheme.of(context).error, size: 20.0),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                                        ),
                                        child: Text(
                                          _model.placePickerValue2.name.isNotEmpty ? _model.placePickerValue2.name : 'Destination',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            font: GoogleFonts.inter(),
                                            color: _model.placePickerValue2.name.isNotEmpty ? FlutterFlowTheme.of(context).primaryText : FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Select Time',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                            lineHeight: 1.35,
                          ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          ),
                        );
                        if (picked != null && mounted) {
                          safeSetState(() => _selectedTime = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: _selectedTime != null
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).alternate,
                            width: _selectedTime != null ? 2.0 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: _selectedTime != null
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondaryText,
                              size: 20.0,
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Tap to select time',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: _selectedTime != null ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                    color: _selectedTime != null
                                        ? FlutterFlowTheme.of(context).primaryText
                                        : FlutterFlowTheme.of(context).secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Select Date',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                                lineHeight: 1.35,
                              ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                            ),
                            child: FlutterFlowCalendar(
                              color: FlutterFlowTheme.of(context).primary,
                              iconColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              weekFormat: false,
                              weekStartsMonday: false,
                              twoRowHeader: true,
                              initialDate: _model.datePicked,
                              rowHeight: 48.0,
                              onChange: (DateTimeRange? newSelectedDate) {
                                safeSetState(() => _model.calendarSelectedDay =
                                    newSelectedDate);
                              },
                              titleStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                              dayOfWeekStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                              dateStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              selectedDateStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              inactiveDateStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Your ride will arrive at your selected time',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.47,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ),
                      ),
                    ),
                      FFButtonWidget(
                        onPressed: _isSubmitting ? null : () async {
                          // Validate all fields
                          final selectedDate = _model.calendarSelectedDay?.start;
                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a date from the calendar')),
                            );
                            return;
                          }
                          if (_selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a time')),
                            );
                            return;
                          }
                          if (_model.placePickerValue1.latLng == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a pickup location')),
                            );
                            return;
                          }
                          if (_model.placePickerValue2.latLng == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a destination')),
                            );
                            return;
                          }

                          // Combine date + time into a single DateTime
                          final scheduledDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );

                          if (scheduledDateTime.isBefore(DateTime.now())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a future date and time')),
                            );
                            return;
                          }

                          setState(() => _isSubmitting = true);

                          final pickupLat = _model.placePickerValue1.latLng!.latitude;
                          final pickupLng = _model.placePickerValue1.latLng!.longitude;
                          final dropoffLat = _model.placePickerValue2.latLng!.latitude;
                          final dropoffLng = _model.placePickerValue2.latLng!.longitude;
                          final distKm = _haversineKm(pickupLat, pickupLng, dropoffLat, dropoffLng);
                          final estimatedFare = _calculateFare(distKm);

                          final rideData = {
                            'passenger_ref': currentUserUid,
                            'pickup_address': _model.placePickerValue1.address.isNotEmpty
                                ? _model.placePickerValue1.address
                                : _model.placePickerValue1.name,
                            'dropoff_address': _model.placePickerValue2.address.isNotEmpty
                                ? _model.placePickerValue2.address
                                : _model.placePickerValue2.name,
                            'pickup_lat': pickupLat,
                            'pickup_lng': pickupLng,
                            'dropoff_lat': dropoffLat,
                            'dropoff_lng': dropoffLng,
                            'scheduled_time': scheduledDateTime.toIso8601String(),
                            'estimated_fare': estimatedFare.toStringAsFixed(0),
                          };

                          final response = await scheduleRide(rideData);
                          if (!mounted) return;
                          setState(() => _isSubmitting = false);

                          if (response != null && response['_error'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ride scheduled successfully!')),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response?['_error']?.toString() ?? 'Failed to schedule ride. Please try again.')),
                            );
                          }
                        },
                      text: _isSubmitting ? 'Scheduling…' : 'Schedule Ride',
                      options: FFButtonOptions(
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Container(
                      height: 24.0,
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
