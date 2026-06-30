import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '/backend/socket_service.dart';
import 'page10_searchingfor_driverr_model.dart';
export 'page10_searchingfor_driverr_model.dart';

class Page10SearchingforDriverrWidget extends StatefulWidget {
  const Page10SearchingforDriverrWidget({
    super.key,
    required this.rideId,
    this.pickupAddress = '',
    this.fare = 0.0,
  });

  final String rideId;
  final String pickupAddress;
  final double fare;

  static String routeName = 'Page10SearchingforDriverr';
  static String routePath = '/page10SearchingforDriverr';

  @override
  State<Page10SearchingforDriverrWidget> createState() =>
      _Page10SearchingforDriverrWidgetState();
}

class _Page10SearchingforDriverrWidgetState
    extends State<Page10SearchingforDriverrWidget> {
  late Page10SearchingforDriverrModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  Timer? _pollTimer;
  Timer? _countdownTimer;
  bool _navigated = false;
  Map<String, dynamic>? _rideData;

  // 2-minute search window
  static const int _searchSeconds = 120;
  int _secondsLeft = _searchSeconds;

  String get _countdownText {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page10SearchingforDriverrModel());

    fetchRideById(widget.rideId).then((data) {
      if (data != null && mounted) setState(() => _rideData = data['ride'] ?? data);
    });

    SocketService().initSocket(currentUserUid, 'passenger');

    SocketService().onRideAccepted = (data) {
      if (!mounted || _navigated) return;
      _navigated = true;
      _pollTimer?.cancel();
      _countdownTimer?.cancel();
      final rideId = (data != null && data['ride'] != null)
          ? data['ride']['_id']?.toString() ?? widget.rideId
          : widget.rideId;
      context.pushNamed('PDriverOnTheWay',
          queryParameters: {'rideId': rideId});
    };

    // Fallback poll every 5 s in case socket event was missed
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted || _navigated) return;
      final ride = await fetchRideById(widget.rideId);
      if (ride == null || !mounted || _navigated) return;
      final status = (ride['ride']?['status'] ?? ride['status'])?.toString().toLowerCase() ?? '';
      if (status == 'accepted' || status == 'in_progress' || status == 'arrived') {
        _navigated = true;
        _pollTimer?.cancel();
        _countdownTimer?.cancel();
        context.pushNamed('PDriverOnTheWay',
            queryParameters: {'rideId': widget.rideId});
      }
    });

    // Auto-cancel countdown: 2 minutes to find a driver
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted || _navigated) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        _countdownTimer?.cancel();
        _pollTimer?.cancel();
        _navigated = true;
        // Cancel ride on backend — it will emit ride_cancelled to all drivers
        await updateRideStatus(widget.rideId, 'cancel');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No driver found nearby. Please try again.'),
            duration: Duration(seconds: 4),
          ),
        );
        context.pushNamed('PassengersDashboardnew');
      }
    });

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: false)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    SocketService().onRideAccepted = null;
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          alignment: AlignmentDirectional(-1.0, -1.0),
          children: [
            Container(
              child: FlutterFlowGoogleMap(
                controller: _model.mapGoogleMapsController,
                onCameraIdle: (latLng) =>
                    safeSetState(() => _model.mapGoogleMapsCenter = latLng),
                initialLocation: _model.mapGoogleMapsCenter ??=
                    currentUserLocationValue!,
                markers: _model.location
                    .map(
                      (marker) => FlutterFlowMarker(
                        marker.serialize(),
                        marker,
                      ),
                    )
                    .toList(),
                markerColor: GoogleMarkerColor.violet,
                mapType: MapType.normal,
                style: GoogleMapStyle.standard,
                initialZoom: 15.0,
                allowInteraction: true,
                allowZoom: true,
                showZoomControls: false,
                showLocation: currentUserLocationValue != null,
                showCompass: false,
                showMapToolbar: false,
                showTraffic: true,
                centerMapOnMarkerTap: true,
                mapTakesGesturePreference: false,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    FlutterFlowTheme.of(context).background80,
                    FlutterFlowTheme.of(context).primaryBackground
                  ],
                  stops: [0.0, 0.7, 1.0],
                  begin: AlignmentDirectional(0.0, -1.0),
                  end: AlignmentDirectional(0, 1.0),
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          Lottie.network(
                            'https://dimg.dreamflow.cloud/v1/lottie/concentric+green+pulsing+circles+sonar+effect',
                            width: 180.0,
                            height: 180.0,
                            fit: BoxFit.contain,
                            animate: _model.isupdated,
                          ),
                          Container(
                            width: 64.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(9999.0),
                              shape: BoxShape.rectangle,
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.taxi_alert_rounded,
                              color: FlutterFlowTheme.of(context).onPrimary,
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 32.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Searching for your driver...',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
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
                                color: FlutterFlowTheme.of(context).primaryText,
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
                        Text(
                          'We\'re connecting you with the nearest available captain',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    SizedBox(height: 16.0),
                    // Countdown ring
                    Container(
                      width: 80.0,
                      height: 80.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80.0,
                            height: 80.0,
                            child: CircularProgressIndicator(
                              value: _secondsLeft / _searchSeconds,
                              strokeWidth: 5.0,
                              backgroundColor: FlutterFlowTheme.of(context).alternate,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _secondsLeft > 30
                                    ? FlutterFlowTheme.of(context).primary
                                    : _secondsLeft > 10
                                        ? Colors.orange
                                        : FlutterFlowTheme.of(context).error,
                              ),
                            ),
                          ),
                          Text(
                            _countdownText,
                            style: GoogleFonts.inter(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                      child: Container(
                        child: Container(
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
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(9999.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          (_rideData?['pickup_address'] as String?)?.isNotEmpty == true
                                              ? _rideData!['pickup_address'] as String
                                              : widget.pickupAddress.isNotEmpty
                                                  ? widget.pickupAddress
                                                  : '—',
                                          maxLines: 1,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                                lineHeight: 1.4,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                  Divider(
                                    height: 16.0,
                                    thickness: 1.0,
                                    indent: 0.0,
                                    endIndent: 0.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.electric_car_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 20.0,
                                          ),
                                          Text(
                                            (_rideData?['ride_type'] as String?)?.isNotEmpty == true
                                                ? _rideData!['ride_type'] as String
                                                : (_rideData?['rideType'] as String?)?.isNotEmpty == true
                                                    ? _rideData!['rideType'] as String
                                                    : 'Car',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                  lineHeight: 1.3,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                      Text(
                                        () {
                                          final fetched = (_rideData?['fare'] ?? _rideData?['amount']) as num?;
                                          if (fetched != null && fetched > 0) return '₦ ${fetched.toStringAsFixed(0)}';
                                          if (widget.fare > 0) return '₦ ${widget.fare.toStringAsFixed(0)}';
                                          return '—';
                                        }(),
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                              lineHeight: 1.35,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Cancel Ride?',
                                style: FlutterFlowTheme.of(context).titleMedium),
                            content: Text(
                                'Are you sure you want to cancel this ride request?',
                                style: FlutterFlowTheme.of(context).bodyMedium),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text('No',
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context).secondaryText)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text('Yes, Cancel',
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context).error)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && mounted) {
                          _navigated = true;
                          _pollTimer?.cancel();
                          _countdownTimer?.cancel();
                          await updateRideStatus(widget.rideId, 'cancel');
                          if (mounted) context.pushNamed('PassengersDashboardnew');
                        }
                      },
                      text: 'Cancel Request',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFFE16767),
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Container(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.support_agent_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 16.0,
                                    ),
                                    Text(
                                      'Need help? Contact Support',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                            lineHeight: 1.3,
                                          ),
                                    ),
                                  ].divide(SizedBox(width: 4.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                    Container(
                      height: 16.0,
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
