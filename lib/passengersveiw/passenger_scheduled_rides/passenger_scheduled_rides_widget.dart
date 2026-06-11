import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import 'passenger_scheduled_rides_model.dart';
export 'passenger_scheduled_rides_model.dart';

class PassengerScheduledRidesWidget extends StatefulWidget {
  const PassengerScheduledRidesWidget({super.key});

  @override
  State<PassengerScheduledRidesWidget> createState() =>
      _PassengerScheduledRidesWidgetState();
}

class _PassengerScheduledRidesWidgetState
    extends State<PassengerScheduledRidesWidget> {
  late PassengerScheduledRidesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool _isLoading = true;
  List<Map<String, dynamic>> _scheduledRides = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengerScheduledRidesModel());
    _loadScheduledRides();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadScheduledRides() async {
    if (currentUserUid.isNotEmpty) {
      final rides = await fetchCollection('rides/history/user/$currentUserUid');
      safeSetState(() {
        _scheduledRides = rides.where((ride) => ride['status'] == 'scheduled').toList();
        _isLoading = false;
      });
    } else {
      safeSetState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            context.safePop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
        ),
        title: Text(
          'Scheduled Rides',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
              ),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
          child: _isLoading 
            ? Center(child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).primary))
            : _scheduledRides.isEmpty 
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 90.0,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                              child: Text(
                                'No Scheduled Rides',
                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(32.0, 12.0, 32.0, 0.0),
                              child: Text(
                                'You don\'t have any upcoming scheduled rides at the moment. When you schedule a ride, it will appear here.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed('Page7ScheduleRide').then((_) => _loadScheduledRides());
                                },
                                text: 'Schedule a Ride',
                                options: FFButtonOptions(
                                  width: 200.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                                        color: Colors.white,
                                      ),
                                  elevation: 2.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: _scheduledRides.length,
                  itemBuilder: (context, index) {
                    final ride = _scheduledRides[index];
                    final requestedAtStr = ride['requested_at'] as String?;
                    DateTime? requestedAt;
                    if (requestedAtStr != null) {
                      requestedAt = DateTime.tryParse(requestedAtStr);
                    }
                    final dateStr = requestedAt != null ? DateFormat('MMM d, y h:mm a').format(requestedAt) : 'Unknown Time';
                    
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Scheduled for:',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Scheduled',
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              dateStr,
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: FlutterFlowTheme.of(context).error, size: 16.0),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Ride requested',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
