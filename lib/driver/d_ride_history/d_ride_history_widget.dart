import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  List<Map<String, dynamic>> _rides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DRideHistoryModel());
    _loadHistory();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final rides = await fetchDriverRideHistory(currentUserUid);
    if (mounted) setState(() { _rides = rides; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          buttonSize: 60.0,
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText, size: 30.0),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Ride History',
          style: theme.headlineMedium.override(
            font: GoogleFonts.inter(fontSize: 22.0),
            color: theme.primaryText,
            fontSize: 22.0,
          ),
        ),
        actions: [
          FlutterFlowIconButton(
            borderRadius: 8.0,
            buttonSize: 40.0,
            fillColor: Colors.transparent,
            icon: Icon(Icons.refresh_rounded, color: theme.primaryText, size: 24.0),
            onPressed: _loadHistory,
          ),
          const SizedBox(width: 8.0),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primary)))
            : _rides.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_rounded,
                            size: 48, color: theme.secondaryText),
                        const SizedBox(height: 16),
                        Text(
                          'No past rides yet.',
                          style: theme.titleMedium.override(
                            font: GoogleFonts.inter(),
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadHistory,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
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
                        final status =
                            (ride['status'] ?? '').toString();
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
                              border:
                                  Border.all(color: theme.alternate, width: 1.0),
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
                                        style: theme.labelMedium.override(
                                          font: GoogleFonts.inter(),
                                          color: theme.secondaryText,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: status.toLowerCase() ==
                                                      'completed'
                                                  ? theme.success.withOpacity(0.15)
                                                  : theme.alternate,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              status.isNotEmpty
                                                  ? status[0].toUpperCase() +
                                                      status.substring(1)
                                                  : '—',
                                              style: theme.labelSmall.override(
                                                font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600),
                                                color: status.toLowerCase() ==
                                                        'completed'
                                                    ? theme.success
                                                    : theme.secondaryText,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
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
                                                    fontWeight: FontWeight.w500),
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
                                                    fontWeight: FontWeight.w500),
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
    );
  }
}
