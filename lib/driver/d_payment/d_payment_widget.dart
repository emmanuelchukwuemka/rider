import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import '/auth/custom_auth/auth_util.dart';
import 'd_payment_model.dart';
export 'd_payment_model.dart';

class DPaymentWidget extends StatefulWidget {
  const DPaymentWidget({super.key});

  static String routeName = 'DPayment';
  static String routePath = '/d_payment';

  @override
  State<DPaymentWidget> createState() => _DPaymentWidgetState();
}

class _DPaymentWidgetState extends State<DPaymentWidget> {
  late DPaymentModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DPaymentModel());
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
          'Payment',
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
        child: StreamBuilder<List<UserDriverRecord>>(
          stream: queryUserDriverRecord(
            queryBuilder: (q) => q.where('uid', isEqualTo: currentUserUid),
            singleRecord: true,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final driverRecords = snapshot.data!;
            final driverRecord = driverRecords.isNotEmpty ? driverRecords.first : null;
            final walletBalance = driverRecord?.walletBalance ?? 0.0;

            return Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x33000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Available Balance',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).info,
                              ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          '₦${walletBalance.toStringAsFixed(2)}',
                          style: FlutterFlowTheme.of(context).displaySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).info,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  FFButtonWidget(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Withdrawal functionality coming soon!')),
                      );
                    },
                    text: 'Cash Out',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 55.0,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                      elevation: 2.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Recent Transactions',
                    style: FlutterFlowTheme.of(context).titleLarge,
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: Center(
                      child: Text(
                        'No recent transactions.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
