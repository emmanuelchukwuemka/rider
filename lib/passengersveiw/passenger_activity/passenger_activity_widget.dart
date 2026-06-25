import '/auth/custom_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_activity_model.dart';
export 'passenger_activity_model.dart';

class PassengerActivityWidget extends StatefulWidget {
  const PassengerActivityWidget({super.key});

  @override
  State<PassengerActivityWidget> createState() => _PassengerActivityWidgetState();
}

class _PassengerActivityWidgetState extends State<PassengerActivityWidget> {
  late PassengerActivityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengerActivityModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
          title: Text(
            'Activity',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: StreamBuilder<List<RideRecord>>(
              stream: queryRideRecord(
                queryBuilder: (rideRecord) => rideRecord
                    .where('users', isEqualTo: currentUserReference)
                    .orderBy('created_at', descending: true),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }
                List<RideRecord> rides = snapshot.data!;
                if (rides.isEmpty) {
                  return Center(
                    child: Text(
                      'No past rides found.',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.inter(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: rides.length,
                  itemBuilder: (context, listViewIndex) {
                    final ride = rides[listViewIndex];
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateTimeFormat('MMM d, h:mm a', ride.requestedAt ?? DateTime.now()),
                                    style: FlutterFlowTheme.of(context).labelMedium,
                                  ),
                                  Text(
                                    '₦${ride.finalFare.toStringAsFixed(2)}',
                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                          font: GoogleFonts.inter(
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 24.0,
                                thickness: 1.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 8.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 2.0,
                                        height: 24.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).alternate,
                                        ),
                                      ),
                                      Container(
                                        width: 8.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).error,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ride.pickupAddress.isNotEmpty
                                                ? ride.pickupAddress
                                                : 'Pickup Location',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                            child: Text(
                                              ride.dropoffAddress.isNotEmpty
                                                  ? ride.dropoffAddress
                                                  : 'Dropoff Location',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
