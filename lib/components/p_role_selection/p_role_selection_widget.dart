import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_role_selection_model.dart';
export 'p_role_selection_model.dart';

class PRoleSelectionWidget extends StatefulWidget {
  const PRoleSelectionWidget({super.key});

  static String routeName = 'PRoleSelection';
  static String routePath = '/pRoleSelection';

  @override
  State<PRoleSelectionWidget> createState() => _PRoleSelectionWidgetState();
}

class _PRoleSelectionWidgetState extends State<PRoleSelectionWidget> {
  late PRoleSelectionModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedRole = 'passenger'; // 'passenger' or 'driver'

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PRoleSelectionModel());
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top section: Logo and Welcome
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(9999.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary20 ?? const Color(0xFFE0E3E7),
                          width: 2.0,
                        ),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Icon(
                        Icons.taxi_alert_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 40.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      'Welcome to QuickDrop',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Choose how you want to use the platform today.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),

                // Middle section: Toggle
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRole = 'passenger';
                                  });
                                },
                                borderRadius: BorderRadius.circular(26.0),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'passenger'
                                        ? FlutterFlowTheme.of(context).primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26.0),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_pin_circle_rounded,
                                        color: _selectedRole == 'passenger'
                                            ? Colors.white
                                            : FlutterFlowTheme.of(context).secondaryText,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        'Passenger',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Inter',
                                          color: _selectedRole == 'passenger'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).secondaryText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRole = 'driver';
                                  });
                                },
                                borderRadius: BorderRadius.circular(26.0),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'driver'
                                        ? FlutterFlowTheme.of(context).primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26.0),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.time_to_leave_rounded,
                                        color: _selectedRole == 'driver'
                                            ? Colors.white
                                            : FlutterFlowTheme.of(context).secondaryText,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        'Driver',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Inter',
                                          color: _selectedRole == 'driver'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).secondaryText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(_selectedRole),
                        padding: EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 10.0,
                              offset: Offset(0, 4),
                            )
                          ]
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedRole == 'passenger'
                                  ? 'I want a ride'
                                  : 'I want to drive',
                              style: FlutterFlowTheme.of(context).titleLarge.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              _selectedRole == 'passenger'
                                  ? 'Find nearby drivers and get to your destination quickly and safely. Enjoy comfortable rides at your fingertips.'
                                  : 'Earn money by providing rides. Set your own schedule, be your own boss, and connect with passengers in your city.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                lineHeight: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom section: Continue Button
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        if (_selectedRole == 'passenger') {
                          context.pushNamed('Page1SplashScreen');
                        } else {
                          context.pushNamed('SplashScreen');
                        }
                      },
                      text: _selectedRole == 'passenger'
                          ? 'Continue as Passenger'
                          : 'Continue as Driver',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 56.0,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'You can always switch roles later in settings',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
