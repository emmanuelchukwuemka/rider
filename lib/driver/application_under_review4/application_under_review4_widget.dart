import '/components/button2/button2_widget.dart';
import '/components/status_badge/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'application_under_review4_model.dart';
export 'application_under_review4_model.dart';

class ApplicationUnderReview4Widget extends StatefulWidget {
  const ApplicationUnderReview4Widget({super.key});

  static String routeName = 'ApplicationUnderReview4';
  static String routePath = '/applicationUnderReview4';

  @override
  State<ApplicationUnderReview4Widget> createState() =>
      _ApplicationUnderReview4WidgetState();
}

class _ApplicationUnderReview4WidgetState
    extends State<ApplicationUnderReview4Widget> {
  late ApplicationUnderReview4Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ApplicationUnderReview4Model());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60.0,
              ),
              Container(
                width: 240.0,
                height: 240.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: 180.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary10,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Lottie.network(
                      'https://dimg.dreamflow.cloud/v1/lottie/clock+and+magnifying+glass+scanning+documents',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                      animate: true,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Application Under Review',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                          lineHeight: 1.25,
                        ),
                  ),
                  Container(
                    width: 320.0,
                    child: Text(
                      'Our team is verifying your documents. This usually takes 24-48 hours. We\'ll notify you once your account is ready.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                            lineHeight: 1.5,
                          ),
                    ),
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
              wrapWithModel(
                model: _model.statusBadgeModel,
                updateCallback: () => safeSetState(() {}),
                child: StatusBadgeWidget(
                  bg: FlutterFlowTheme.of(context).secondaryBackground,
                  border: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  icon: Icon(
                    Icons.history_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                  label: 'In Progress',
                  status: 'pending',
                ),
              ),
              Spacer(),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    wrapWithModel(
                      model: _model.buttonModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: Button2Widget(
                        content: 'Refresh Status',
                        iconPresent: false,
                        iconEndPresent: false,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        variant: 'primary',
                        size: 'large',
                        fullWidth: true,
                        loading: false,
                        disabled: false,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.buttonModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: Button2Widget(
                        content: 'Contact Support',
                        icon: Icon(
                          Icons.support_agent_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 16.0,
                        ),
                        iconPresent: true,
                        iconEndPresent: false,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        variant: 'ghost',
                        size: 'medium',
                        fullWidth: false,
                        loading: false,
                        disabled: false,
                      ),
                    ),
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
              Container(
                height: 16.0,
              ),
            ].divide(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }
}
