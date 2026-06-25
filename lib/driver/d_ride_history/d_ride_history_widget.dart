import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/backend.dart';
import '/pages/earnings_card/earnings_card_widget.dart';
import 'd_ride_history_model.dart';
export 'd_ride_history_model.dart';

class DRideHistoryWidget extends StatefulWidget {
  const DRideHistoryWidget({super.key});

  static String routeName = 'DRideHistory';
  static String routePath = '/d_ride_history';

  @override
  State<DRideHistoryWidget> createState() => _DRideHistoryWidgetState();
}

class _DRideHistoryWidgetState extends State<DRideHistoryWidget> {
  late DRideHistoryModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DRideHistoryModel());
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          'Ride History',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
              ),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: StreamBuilder<List<RideRecord>>(
          stream: queryRideRecord(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final rides = snapshot.data!;
            if (rides.isEmpty) {
              return Center(
                child: Text(
                  'No past rides found.',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: EarningsCardWidget(
                    amount: ride.finalFare.toStringAsFixed(0),
                    date: DateFormat('MMM d, h:mm a').format(ride.completedAt ?? ride.requestedAt ?? DateTime.now()),
                    destination: ride.dropoffAddress.isNotEmpty ? ride.dropoffAddress : '—',
                    pickup: ride.pickupAddress.isNotEmpty ? ride.pickupAddress : '—',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
