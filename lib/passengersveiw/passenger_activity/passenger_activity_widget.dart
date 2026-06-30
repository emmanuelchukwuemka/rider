import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_activity_model.dart';
export 'passenger_activity_model.dart';

class PassengerActivityWidget extends StatefulWidget {
  const PassengerActivityWidget({super.key});

  @override
  State<PassengerActivityWidget> createState() =>
      _PassengerActivityWidgetState();
}

class _PassengerActivityWidgetState extends State<PassengerActivityWidget> {
  late PassengerActivityModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _rides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengerActivityModel());
    _loadHistory();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final rides = await fetchUserRideHistory(currentUserUid);
    if (mounted) setState(() { _rides = rides; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_rounded,
                color: theme.primaryText, size: 24.0),
          ),
          title: Text(
            'Activity',
            style: theme.headlineMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(theme.primary)))
              : _rides.isEmpty
                  ? Center(
                      child: Text(
                        'No past rides found.',
                        style: theme.bodyLarge.override(
                          font: GoogleFonts.inter(color: theme.secondaryText),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadHistory,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        itemCount: _rides.length,
                        itemBuilder: (context, index) {
                          final ride = _rides[index];
                          final pickup =
                              (ride['pickup_address'] ?? '').toString().trim();
                          final dropoff =
                              (ride['dropoff_address'] ?? '').toString().trim();
                          final fare = double.tryParse(
                                  (ride['estimated_fare'] ?? ride['fare'] ?? 0)
                                      .toString()) ??
                              0.0;
                          DateTime? createdAt;
                          final raw = ride['requested_at'] ??
                              ride['created_at'] ??
                              ride['createdAt'];
                          if (raw != null) {
                            createdAt = DateTime.tryParse(raw.toString());
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: theme.alternate, width: 1.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          createdAt != null
                                              ? dateTimeFormat(
                                                  'MMM d, h:mm a', createdAt)
                                              : '—',
                                          style: theme.labelMedium,
                                        ),
                                        Text(
                                          fare > 0
                                              ? '₦${fare.toStringAsFixed(0)}'
                                              : '—',
                                          style: theme.titleMedium.override(
                                            font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                        height: 24.0,
                                        thickness: 1.0,
                                        color: theme.alternate),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: BoxDecoration(
                                                  color: theme.primary,
                                                  shape: BoxShape.circle),
                                            ),
                                            Container(
                                                width: 2.0,
                                                height: 24.0,
                                                color: theme.alternate),
                                            Container(
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: BoxDecoration(
                                                  color: theme.error,
                                                  shape: BoxShape.circle),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pickup.isNotEmpty
                                                    ? pickup
                                                    : 'Pickup location',
                                                style: theme.bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 16.0),
                                              Text(
                                                dropoff.isNotEmpty
                                                    ? dropoff
                                                    : 'Dropoff location',
                                                style: theme.bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
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
                      ),
                    ),
        ),
      ),
    );
  }
}
