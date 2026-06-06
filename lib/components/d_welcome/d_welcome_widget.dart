import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import '/pages/hex_stat_cell/hex_stat_cell_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_palette/material_palette.dart';
import 'package:provider/provider.dart';
import 'd_welcome_model.dart';
export 'd_welcome_model.dart';

class DWelcomeWidget extends StatefulWidget {
  const DWelcomeWidget({super.key});

  static String routeName = 'DWelcome';
  static String routePath = '/dWelcome';

  @override
  State<DWelcomeWidget> createState() => _DWelcomeWidgetState();
}

class _DWelcomeWidgetState extends State<DWelcomeWidget> {
  late DWelcomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DWelcomeModel());
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
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 480.0,
                child: Stack(
                  alignment: AlignmentDirectional(-1.0, -1.0),
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return RadialFbmGradientShaderFill(
                          width: constraints.maxWidth.isFinite
                              ? constraints.maxWidth
                              : 200.0,
                          height: constraints.maxHeight.isFinite
                              ? constraints.maxHeight
                              : 200.0,
                          params: ShaderParams(values: {
                            'gradientCenterX': 0.5,
                            'gradientCenterY': 0.2,
                            'gradientScale': 2.67,
                            'gradientOffset': -0.01,
                            'noiseIntensity': 0.43,
                            'ditherStrength': 0.0,
                            'ditherScale': 0.42,
                            'animSpeed': 0.42,
                            'octaves': 8.0,
                            'lacunarity': 2.16,
                            'persistence': 0.34,
                            'noiseScale': 2.93,
                            'colorCount': 4.0,
                            'softness': 0.82,
                            'exposure': 1.05,
                            'contrast': 1.16,
                            'bumpStrength': 1.6,
                            'lightDirX': 0.5,
                            'lightDirY': 0.06,
                            'lightDirZ': 0.79,
                            'lightIntensity': 1.06,
                            'ambient': 0.77,
                            'specular': 0.78,
                            'shininess': 101.49,
                            'metallic': 0.4,
                            'roughness': 0.4,
                            'edgeFade': 0.54,
                            'edgeFadeMode': 0.0
                          }, colors: {
                            'color0': Color(0x33158D0D),
                            'color1':
                                FlutterFlowTheme.of(context).primaryBackground,
                            'color2': FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            'color3':
                                FlutterFlowTheme.of(context).primaryBackground,
                            'color4': Color(0x00808080),
                            'color5': Color(0x00808080),
                            'color6': Color(0x00808080),
                            'color7': Color(0x00808080),
                            'color8': Color(0x00808080),
                            'color9': Color(0x00808080)
                          }),
                          animationMode: ShaderAnimationMode.continuous,
                          cache: false,
                        );
                      },
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(9999.0),
                                shape: BoxShape.rectangle,
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.local_taxi_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 40.0,
                              ),
                            ),
                          ].divide(SizedBox(height: 24.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Drive and earn with QuickDrop',
                      textAlign: TextAlign.center,
                      style:
                          FlutterFlowTheme.of(context).headlineLarge.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .fontStyle,
                                lineHeight: 1.2,
                              ),
                    ),
                    Text(
                      'Join our community of professional drivers. Set your own schedule and maximize your daily earnings with ease.',
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
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    wrapWithModel(
                      model: _model.hexStatCellModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: HexStatCellWidget(
                        icon: Icon(
                          Icons.payments_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 18.0,
                        ),
                        label: 'Weekly',
                        value: 'Payouts',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.hexStatCellModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: HexStatCellWidget(
                        icon: Icon(
                          Icons.schedule_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 18.0,
                        ),
                        label: 'Flexible',
                        value: 'Hours',
                      ),
                    ),
                    wrapWithModel(
                      model: _model.hexStatCellModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: HexStatCellWidget(
                        icon: Icon(
                          Icons.security_rounded,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 18.0,
                        ),
                        label: 'Safety',
                        value: 'First',
                      ),
                    ),
                  ].divide(SizedBox(width: 16.0)),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        wrapWithModel(
                          model: _model.buttonModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ButtonWidget(
                            content: 'Continue',
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Already have a driver account?',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                    lineHeight: 1.4,
                                  ),
                            ),
                            Text(
                              'Log In',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                    lineHeight: 1.3,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ].divide(SizedBox(height: 16.0)),
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
