import '/components/button2/button2_widget.dart';
import '/components/text_field2/text_field2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import 'page1_phone_login_model.dart';
export 'page1_phone_login_model.dart';

class Page1PhoneLoginWidget extends StatefulWidget {
  const Page1PhoneLoginWidget({super.key});

  static String routeName = 'Page1PhoneLogin';
  static String routePath = '/Page1PhoneLogin';

  @override
  State<Page1PhoneLoginWidget> createState() => _Page1PhoneLoginWidgetState();
}

class _Page1PhoneLoginWidgetState extends State<Page1PhoneLoginWidget> {
  late Page1PhoneLoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page1PhoneLoginModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = _model.textFieldModel1.inputTextController?.text.trim() ?? '';
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    safeSetState(() => _isLoading = true);
    final status = await requestLoginOtp(email);
    safeSetState(() => _isLoading = false);

    if (!mounted) return;

    if (status == 'success') {
      context.pushNamed(
        'ConfirmPhoneNumberPage',
        queryParameters: {'email': email},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Please try again.')),
      );
    }
  }

  Future<void> _googleSignIn() async {
    safeSetState(() => _isGoogleLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final result = await googleLogin(googleAuth.idToken!);
          if (!mounted) return;
          if (result != null && result['token'] != null) {
            final userId = result['user']?['id'] ?? '';
            await saveAuthData(result['token'], userId, googleUser.email);
            await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
            context.pushNamed('PassengersDashboardnew');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result?['error'] ?? 'Google sign-in failed.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) safeSetState(() => _isGoogleLoading = false);
    }
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
          child: SingleChildScrollView(
            primary: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top row: back + become a driver
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: Colors.transparent,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () => context.safePop(),
                      ),
                      InkWell(
                        onTap: () => context.pushNamed('DriverLogin002'),
                        child: wrapWithModel(
                          model: _model.buttonModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: Button2Widget(
                            content: 'Drive with us',
                            iconPresent: false,
                            iconEndPresent: false,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            variant: 'ghost',
                            size: 'medium',
                            fullWidth: false,
                            loading: false,
                            disabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Icon + label
                  Column(
                    children: [
                      Container(
                        width: 64.0,
                        height: 64.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary10,
                          borderRadius: BorderRadius.circular(9999.0),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.directions_car_rounded,
                          color: FlutterFlowTheme.of(context).onSurface,
                          size: 32.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QUICKDROP',
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: FlutterFlowTheme.of(context).onSurface,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Heading
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in or create account',
                        style: FlutterFlowTheme.of(context).headlineLarge.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.bold,
                              lineHeight: 1.2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your email — we\'ll send you a one-time code',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              lineHeight: 1.5,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Email field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).primaryText,
                              lineHeight: 1.3,
                            ),
                      ),
                      const SizedBox(height: 8),
                      wrapWithModel(
                        model: _model.textFieldModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: TextField2Widget(
                          label: '',
                          labelPresent: false,
                          helper: '',
                          helperPresent: false,
                          hint: 'you@example.com',
                          value: '',
                          leadingIcon: const Icon(Icons.email_outlined),
                          leadingIconPresent: true,
                          trailingIconPresent: false,
                          maxLines: 1,
                          variant: 'outlined',
                          error: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Send OTP button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : InkWell(
                          onTap: _sendOtp,
                          child: wrapWithModel(
                            model: _model.buttonModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: Button2Widget(
                              content: 'Send OTP',
                              iconPresent: false,
                              iconEndPresent: false,
                              color: Colors.white,
                              variant: 'primary',
                              size: 'large',
                              fullWidth: true,
                              loading: false,
                              disabled: false,
                            ),
                          ),
                        ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Google sign-in button
                  _isGoogleLoading
                      ? const Center(child: CircularProgressIndicator())
                      : FFButtonWidget(
                          onPressed: _googleSignIn,
                          text: 'Continue with Google',
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20.0,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: EdgeInsets.zero,
                            iconPadding: EdgeInsets.zero,
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.inter(
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),

                  const SizedBox(height: 24),

                  // Footer note
                  Center(
                    child: Text(
                      'New users are automatically registered',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
