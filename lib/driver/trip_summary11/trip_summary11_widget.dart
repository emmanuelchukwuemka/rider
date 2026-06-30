import '/backend/api_service.dart';
import '/components/button2/button2_widget.dart';
import '/components/fare_item/fare_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'trip_summary11_model.dart';
export 'trip_summary11_model.dart';

class TripSummary11Widget extends StatefulWidget {
  const TripSummary11Widget({
    super.key,
    this.rideId = '',
    this.fare = 0.0,
  });

  final String rideId;
  final double fare;

  static String routeName = 'TripSummary11';
  static String routePath = '/tripSummary11';

  @override
  State<TripSummary11Widget> createState() => _TripSummary11WidgetState();
}

class _TripSummary11WidgetState extends State<TripSummary11Widget> {
  late TripSummary11Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _ride;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TripSummary11Model());
    _loadRide();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadRide() async {
    if (widget.rideId.isEmpty) return;
    final data = await fetchRideById(widget.rideId);
    if (mounted && data != null) setState(() => _ride = data['ride'] ?? data);
  }

  double get _totalFare {
    if (widget.fare > 0) return widget.fare;
    return double.tryParse(
            (_ride?['estimated_fare'] ?? _ride?['fare'] ?? 0).toString()) ??
        0.0;
  }

  String get _fareStr =>
      _totalFare > 0 ? '₦${_totalFare.toStringAsFixed(0)}' : '—';

  String get _driverEarningsStr {
    final e = _totalFare * 0.85;
    return e > 0 ? '₦${e.toStringAsFixed(0)}' : '—';
  }

  String get _commissionStr {
    final c = _totalFare * 0.15;
    return c > 0 ? '-₦${c.toStringAsFixed(0)}' : '₦0';
  }

  String get _dropoffAddress =>
      (_ride?['dropoff_address'] ?? '—').toString().trim();

  String get _tripIdLabel {
    if (widget.rideId.isNotEmpty) {
      return 'Trip #${widget.rideId.length > 8 ? widget.rideId.substring(0, 8).toUpperCase() : widget.rideId.toUpperCase()}';
    }
    return 'Trip ID: —';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final netPayout = _totalFare * 0.85;
    final netPayoutStr = netPayout > 0 ? '₦${netPayout.toStringAsFixed(0)}' : '—';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: Colors.transparent,
                    icon: Icon(Icons.arrow_back_rounded,
                        color: theme.primaryText, size: 24.0),
                    onPressed: () => context.goNamed('DriverDashboard6'),
                  ),
                ),
              ),

              // Success animation + headline
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Lottie.network(
                      'https://dimg.dreamflow.cloud/v1/lottie/green+success+checkmark+animation',
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.contain,
                      repeat: false,
                      animate: true,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Trip Completed',
                      textAlign: TextAlign.center,
                      style: theme.headlineMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Thank you for the safe ride',
                      textAlign: TextAlign.center,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              // Total fare card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: theme.alternate, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Fare',
                          style: theme.labelLarge.override(
                            font: GoogleFonts.inter(),
                            color: theme.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _fareStr,
                          style: theme.headlineLarge.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w800),
                            fontWeight: FontWeight.w800,
                            color: theme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Earnings breakdown card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.alternate, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Earnings Breakdown',
                          style: theme.titleMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        wrapWithModel(
                          model: _model.fareItemModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: FareItemWidget(
                              label: 'Base Fare', value: _fareStr),
                        ),
                        wrapWithModel(
                          model: _model.fareItemModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: FareItemWidget(
                              label: 'Driver Earnings (85%)',
                              value: _driverEarningsStr),
                        ),
                        wrapWithModel(
                          model: _model.fareItemModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: FareItemWidget(
                              label: 'Platform Commission (15%)',
                              value: _commissionStr),
                        ),
                        wrapWithModel(
                          model: _model.fareItemModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: const FareItemWidget(
                              label: 'Wallet Deduction', value: '₦0'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                              height: 16.0,
                              thickness: 1.0,
                              color: theme.alternate),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Net Payout',
                              style: theme.titleMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              netPayoutStr,
                              style: theme.titleMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold),
                                fontWeight: FontWeight.bold,
                                color: theme.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Trip info card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: theme.alternate, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.history_edu_rounded,
                              color: theme.onSurface, size: 24.0),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _tripIdLabel,
                                style: theme.labelSmall.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                _dropoffAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                ),
              ),

              // Back to Dashboard button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () => context.goNamed('DriverDashboard6'),
                  child: wrapWithModel(
                    model: _model.buttonModel,
                    updateCallback: () => safeSetState(() {}),
                    child: Button2Widget(
                      content: 'Back to Dashboard',
                      iconPresent: false,
                      iconEndPresent: false,
                      color: theme.secondaryText,
                      variant: 'primary',
                      size: 'large',
                      fullWidth: true,
                      loading: false,
                      disabled: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
