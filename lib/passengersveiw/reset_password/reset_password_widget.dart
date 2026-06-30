import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reset_password_model.dart';
export 'reset_password_model.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key, this.email = ''});

  final String email;

  static String routeName = 'ResetPassword';
  static String routePath = '/resetPassword';

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  late ResetPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _otpCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _submitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResetPasswordModel());
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final otp = _otpCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (otp.isEmpty) {
      _snack('Please enter the OTP code sent to your email');
      return;
    }
    if (password.length < 8) {
      _snack('Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      _snack('Passwords do not match');
      return;
    }

    setState(() => _submitting = true);
    final result = await resetUserPassword(
      email: widget.email,
      otp: otp,
      newPassword: password,
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated! Please log in.')),
      );
      context.goNamed('PassengerSignup');
    } else {
      _snack(result['message']?.toString() ?? 'Failed to reset password');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () => context.safePop(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Reset Password',
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).headlineLarge.fontWeight,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      lineHeight: 1.2,
                    ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.email.isNotEmpty
                    ? 'Enter the code sent to ${widget.email} and choose a new password.'
                    : 'Enter the OTP code and choose a new password.',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      lineHeight: 1.5,
                    ),
              ),
              SizedBox(height: 32.0),
              _fieldLabel('OTP Code'),
              SizedBox(height: 8.0),
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                enabled: !_submitting,
                decoration: _inputDecoration(
                  context,
                  hint: 'Enter 6-digit code',
                  prefixIcon: Icons.pin_rounded,
                ),
              ),
              SizedBox(height: 20.0),
              _fieldLabel('New Password'),
              SizedBox(height: 8.0),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                enabled: !_submitting,
                decoration: _inputDecoration(
                  context,
                  hint: 'Enter new password',
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _fieldLabel('Confirm Password'),
              SizedBox(height: 8.0),
              TextField(
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                enabled: !_submitting,
                decoration: _inputDecoration(
                  context,
                  hint: 'Repeat new password',
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              FFButtonWidget(
                onPressed: _submitting ? null : _updatePassword,
                text: _submitting ? 'Updating…' : 'Update Password',
                options: FFButtonOptions(
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.interTight(),
                        color: Colors.white,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Spacer(),
              Container(
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.security_rounded,
                        color: FlutterFlowTheme.of(context).onSurface,
                        size: 20.0,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Password must be at least 8 characters long.',
                          maxLines: 2,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                lineHeight: 1.4,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: FlutterFlowTheme.of(context).labelLarge.override(
            font: GoogleFonts.inter(),
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            lineHeight: 1.3,
          ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: theme.labelMedium.override(font: GoogleFonts.inter()),
      prefixIcon: Icon(prefixIcon, color: theme.secondaryText, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.secondaryBackground,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
