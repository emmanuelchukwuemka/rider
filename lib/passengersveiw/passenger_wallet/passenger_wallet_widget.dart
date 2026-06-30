import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_wallet_model.dart';
export 'passenger_wallet_model.dart';

class PassengerWalletWidget extends StatefulWidget {
  const PassengerWalletWidget({super.key});

  @override
  State<PassengerWalletWidget> createState() => _PassengerWalletWidgetState();
}

class _PassengerWalletWidgetState extends State<PassengerWalletWidget> {
  late PassengerWalletModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _rides = [];
  double _walletBalance = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengerWalletModel());
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final results = await Future.wait([fetchUserById(uid), fetchUserRideHistory(uid)]);
    final user = results[0] as Map<String, dynamic>?;
    final rides = results[1] as List<Map<String, dynamic>>;
    if (!mounted) return;
    setState(() {
      _walletBalance = (user?['wallet_balance'] ?? user?['walletBalance'] ?? user?['balance'] ?? 0).toDouble();
      _rides = rides;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = _rides.fold<double>(0.0, (sum, r) {
      final fare = r['fare'] ?? r['final_fare'] ?? r['price'] ?? 0;
      return sum + (double.tryParse(fare.toString()) ?? 0.0);
    });
    final displayBalance = _walletBalance > 0 ? _walletBalance : totalSpent;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
          title: Text(
            'Wallet',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet Balance',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  color: FlutterFlowTheme.of(context).info,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                          child: Text(
                            '₦${displayBalance.toStringAsFixed(2)}',
                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                  font: GoogleFonts.inter(
                                    color: FlutterFlowTheme.of(context).info,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FFButtonWidget(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Online payment coming soon')),
                                );
                              },
                              text: 'Add Funds',
                              icon: Icon(Icons.add_circle_outline_rounded, size: 15.0),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                color: FlutterFlowTheme.of(context).info,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      font: GoogleFonts.interTight(
                                        color: FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Withdrawal coming soon')),
                                );
                              },
                              text: 'Withdraw',
                              icon: Icon(Icons.arrow_circle_down_rounded, size: 15.0),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                color: Color(0x33FFFFFF),
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      font: GoogleFonts.interTight(
                                        color: FlutterFlowTheme.of(context).info,
                                      ),
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 16.0),
                  child: Text(
                    'Recent Transactions',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
                Expanded(
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        )
                      : _rides.isEmpty
                          ? Center(
                              child: Text(
                                'No recent transactions.',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _rides.length,
                              itemBuilder: (context, index) {
                                final ride = _rides[index];
                                final fare = ride['fare'] ?? ride['final_fare'] ?? ride['price'] ?? 0;
                                final fareVal = double.tryParse(fare.toString()) ?? 0.0;
                                final createdAt = ride['created_at'] ?? ride['requested_at'] ?? '';
                                String formattedTime = createdAt.toString();
                                if (createdAt.isNotEmpty) {
                                  try {
                                    final dt = DateTime.parse(createdAt.toString());
                                    formattedTime = dateTimeFormat('MMM d, h:mm a', dt);
                                  } catch (_) {}
                                }
                                return _buildTransactionItem(
                                  context,
                                  'Ride Payment',
                                  formattedTime,
                                  '-₦${fareVal.toStringAsFixed(0)}',
                                  true,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, String title, String time, String amount, bool isDebit) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
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
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: isDebit ? Color(0x33FF5963) : Color(0x3339D2C0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDebit ? Icons.directions_car_rounded : Icons.account_balance_wallet_rounded,
                      color: isDebit ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).success,
                      size: 24.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            time,
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                amount,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.inter(
                        color: isDebit ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).success,
                        fontWeight: FontWeight.bold,
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
