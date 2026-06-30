import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'p_trip_complete_model.dart';
export 'p_trip_complete_model.dart';

class PTripCompleteWidget extends StatefulWidget {
  const PTripCompleteWidget({super.key, this.rideId = ''});

  final String rideId;

  static String routeName = 'PTripComplete';
  static String routePath = '/pTripComplete';

  @override
  State<PTripCompleteWidget> createState() => _PTripCompleteWidgetState();
}

class _PTripCompleteWidgetState extends State<PTripCompleteWidget> {
  late PTripCompleteModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _ride;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PTripCompleteModel());
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('activeRideId');
      prefs.remove('activeRideStatus');
    });
    _loadRide();
  }

  Future<void> _loadRide() async {
    if (widget.rideId.isNotEmpty) {
      final data = await fetchRideById(widget.rideId);
      if (mounted) setState(() { _ride = data; _loading = false; });
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String get _from => _ride?['pickup_address'] ?? '—';
  String get _to   => _ride?['dropoff_address'] ?? '—';
  String get _driverName => _ride?['driver_name'] ?? '—';
  String get _fare {
    final f = _ride?['fare'] ?? _ride?['final_fare'];
    if (f == null) return '—';
    final n = (f is num) ? f.toDouble() : double.tryParse(f.toString()) ?? 0.0;
    return '₦${n.toStringAsFixed(0)}';
  }
  String get _distance {
    final d = _ride?['distanceKm'];
    if (d == null) return '—';
    final km = (d is num) ? d.toDouble() : double.tryParse(d.toString()) ?? 0.0;
    return '${km.toStringAsFixed(1)} km';
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
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
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.check_rounded,
                                color: FlutterFlowTheme.of(context).onPrimary,
                                size: 44.0,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Trip Complete!',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold),
                                    color:
                                        FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'You have safely arrived at your destination',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Trip Summary',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Divider(
                                  height: 24.0,
                                  thickness: 1.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                Column(
                                  children: [
                                    _summaryRow(context, 'From', _from),
                                    const SizedBox(height: 12.0),
                                    _summaryRow(context, 'To', _to),
                                    const SizedBox(height: 12.0),
                                    _summaryRow(context, 'Distance', _distance),
                                    const SizedBox(height: 12.0),
                                    _summaryRow(
                                        context, 'Driver', _driverName),
                                  ],
                                ),
                                Divider(
                                  height: 24.0,
                                  thickness: 1.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Fare',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      _fare,
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        FFButtonWidget(
                          onPressed: () {
                            context.pushNamed(
                              Page14RatingScreenWidget.routeName,
                              queryParameters: {
                                'rideId': serializeParam(
                                    widget.rideId, ParamType.String),
                              },
                            );
                          },
                          text: 'Rate Your Driver',
                          icon: Icon(
                            Icons.star_rounded,
                            color: FlutterFlowTheme.of(context).onPrimary,
                            size: 18.0,
                          ),
                          options: FFButtonOptions(
                            height: 52.0,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600),
                                  color:
                                      FlutterFlowTheme.of(context).onPrimary,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        FFButtonWidget(
                          onPressed: () {
                            context.goNamed(
                                PassengersDashboardnewWidget.routeName);
                          },
                          text: 'Go to Dashboard',
                          options: FFButtonOptions(
                            height: 52.0,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
