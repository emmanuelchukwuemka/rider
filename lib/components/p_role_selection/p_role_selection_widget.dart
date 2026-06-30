import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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

  Widget _roleCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: theme.alternate, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 52.0,
              height: 52.0,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 26.0),
            ),
            const SizedBox(width: 16.0),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: theme.secondaryText,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: theme.secondaryText,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48.0),

                // Header
                Text(
                  'Continue as',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Choose how you want to use QuickDrop',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: theme.secondaryText,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48.0),

                // Passenger card
                _roleCard(
                  context: context,
                  icon: Icons.person_pin_circle_rounded,
                  iconBg: theme.primary.withOpacity(0.12),
                  iconColor: theme.primary,
                  title: 'Passenger',
                  subtitle: 'Request a ride and travel safely within Nigeria',
                  onTap: () => context.pushNamed('PPhoneLogin'),
                ),

                const SizedBox(height: 16.0),

                // Driver card
                _roleCard(
                  context: context,
                  icon: Icons.time_to_leave_rounded,
                  iconBg: const Color(0xFF1A1A2E).withOpacity(0.08),
                  iconColor: const Color(0xFF1A1A2E),
                  title: 'Driver',
                  subtitle:
                      'Earn money by providing rides on your own schedule',
                  onTap: () => context.pushNamed('DriverLogin002'),
                ),

                const Spacer(),

                // Footer
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'You can switch roles anytime in settings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: theme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Visit quickdrop.ng/support for help')),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help_outline_rounded,
                              size: 16.0, color: theme.secondaryText),
                          const SizedBox(width: 6.0),
                          Text(
                            'Need help?',
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              color: theme.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
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
