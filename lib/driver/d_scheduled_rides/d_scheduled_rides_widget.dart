import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_service.dart';
import '/auth/custom_auth/auth_util.dart';
import '/components/scheduled_ride_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'd_scheduled_rides_model.dart';
export 'd_scheduled_rides_model.dart';

class DScheduledRidesWidget extends StatefulWidget {
  const DScheduledRidesWidget({super.key});

  static String routeName = 'DScheduledRides';
  static String routePath = '/dScheduledRides';

  @override
  State<DScheduledRidesWidget> createState() => _DScheduledRidesWidgetState();
}

class _DScheduledRidesWidgetState extends State<DScheduledRidesWidget> {
  late DScheduledRidesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DScheduledRidesModel());
    _loadScheduledRides();
  }

  Future<void> _acceptScheduledRide(String rideId) async {
    final ok = await updateRideStatus(rideId, 'accept',
        {'driver_ref': currentUserUid ?? ''});
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride accepted! You will be notified when it starts.')),
      );
      _loadScheduledRides();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to accept ride. Please try again.')),
      );
    }
  }

  Future<void> _loadScheduledRides() async {
    if (!mounted) return;
    setState(() => _model.isLoading = true);
    final rides = await fetchScheduledRides(status: 'pending');
    if (!mounted) return;
    final structs = rides.map((r) {
      DateTime? scheduledTime;
      final rawTime = r['scheduled_time'] ?? r['scheduledTime'];
      if (rawTime != null) scheduledTime = DateTime.tryParse(rawTime.toString());
      return RideModelStruct(
        rideId: r['id']?.toString() ?? '',
        pickupAddress: r['pickup_address']?.toString() ?? '',
        dropoffAddress: r['dropoff_address']?.toString() ?? '',
        estimatedFare: double.tryParse(r['estimated_fare']?.toString() ?? '0') ?? 0,
        scheduledTime: scheduledTime,
        status: r['status']?.toString() ?? 'Pending',
        passengerName: r['passenger_name']?.toString() ?? '',
        passengerPhone: r['passenger_phone']?.toString() ?? '',
      );
    }).toList();
    setState(() {
      _model.scheduledRides = structs;
      _model.isLoading = false;
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 16.0),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor: Colors.transparent,
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () => context.safePop(),
                              ),
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor: Colors.transparent,
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: _loadScheduledRides,
                              ),
                            ],
                          ),
                          Text(
                            'Scheduled Rides',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                  lineHeight: 1.25,
                                ),
                          ),
                          Text(
                            'Accept pre-booked trips for higher earnings',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                      lineHeight: 1.4,
                                    ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
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
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Container(
                          child: Builder(
                            builder: (context) {
                              if (_model.isLoading) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: CircularProgressIndicator(
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                );
                              }
                              if (_model.scheduledRides.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.calendar_today_outlined,
                                            size: 48,
                                            color: FlutterFlowTheme.of(context).secondaryText),
                                        const SizedBox(height: 16),
                                        Text('No scheduled rides yet',
                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                                  font: GoogleFonts.inter(),
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                )),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Passengers\' scheduled rides will appear here',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                font: GoogleFonts.inter(),
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(_model.scheduledRides.length, (i) {
                                  final ride = _model.scheduledRides[i];
                                  return ScheduledRideCardWidget(
                                    key: Key('scheduled_$i'),
                                    dateTime: ride.scheduledTime != null
                                        ? dateTimeFormat('MMM d, h:mm a', ride.scheduledTime)
                                        : '—',
                                    destination: ride.dropoffAddress.isNotEmpty ? ride.dropoffAddress : '—',
                                    fare: ride.estimatedFare > 0
                                        ? '₦${ride.estimatedFare.toStringAsFixed(0)}'
                                        : '—',
                                    pickup: ride.pickupAddress.isNotEmpty ? ride.pickupAddress : '—',
                                    status: ride.status,
                                    rideId: ride.rideId,
                                    onAccept: ride.rideId.isNotEmpty
                                        ? () => _acceptScheduledRide(ride.rideId)
                                        : null,
                                  );
                                }).divide(const SizedBox(height: 16.0)),
                              );
                            },
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
