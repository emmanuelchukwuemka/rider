import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'd_settings_model.dart';
export 'd_settings_model.dart';

class DSettingsWidget extends StatefulWidget {
  const DSettingsWidget({super.key});

  static String routeName = 'DSettings';
  static String routePath = '/d_settings';

  @override
  State<DSettingsWidget> createState() => _DSettingsWidgetState();
}

class _DSettingsWidgetState extends State<DSettingsWidget> {
  late DSettingsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DSettingsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isSwitch,
    required bool switchValue,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.inter(),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      subtitle,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSwitch)
            Switch.adaptive(
              value: switchValue,
              onChanged: (newValue) {},
              activeColor: FlutterFlowTheme.of(context).primary,
              activeTrackColor: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
              inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
              inactiveThumbColor: FlutterFlowTheme.of(context).secondaryText,
            )
          else
            Icon(
              Icons.chevron_right_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
        ],
      ),
    );
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
          'Settings',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 16.0),
                child: Text(
                  'Preferences',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Color(0x0D000000),
                        offset: Offset(0.0, 4.0),
                      )
                    ],
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        context,
                        icon: Icons.notifications_active_rounded,
                        iconColor: Colors.blueAccent,
                        title: 'Push Notifications',
                        subtitle: 'Receive alerts for new rides',
                        isSwitch: true,
                        switchValue: true,
                      ),
                      Divider(height: 1.0, thickness: 1.0, color: FlutterFlowTheme.of(context).alternate),
                      _buildSettingItem(
                        context,
                        icon: Icons.email_rounded,
                        iconColor: Colors.orangeAccent,
                        title: 'Email Updates',
                        subtitle: 'Weekly summaries and tips',
                        isSwitch: true,
                        switchValue: false,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 16.0),
                child: Text(
                  'Privacy & Security',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Color(0x0D000000),
                        offset: Offset(0.0, 4.0),
                      )
                    ],
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        context,
                        icon: Icons.location_on_rounded,
                        iconColor: Colors.green,
                        title: 'Location Services',
                        subtitle: 'Required for ride requests',
                        isSwitch: true,
                        switchValue: true,
                      ),
                      Divider(height: 1.0, thickness: 1.0, color: FlutterFlowTheme.of(context).alternate),
                      _buildSettingItem(
                        context,
                        icon: Icons.lock_rounded,
                        iconColor: Colors.redAccent,
                        title: 'Privacy Policy',
                        subtitle: 'Read our policies',
                        isSwitch: false,
                        switchValue: false,
                      ),
                      Divider(height: 1.0, thickness: 1.0, color: FlutterFlowTheme.of(context).alternate),
                      _buildSettingItem(
                        context,
                        icon: Icons.article_rounded,
                        iconColor: Colors.purpleAccent,
                        title: 'Terms of Service',
                        subtitle: 'Rules and guidelines',
                        isSwitch: false,
                        switchValue: false,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
