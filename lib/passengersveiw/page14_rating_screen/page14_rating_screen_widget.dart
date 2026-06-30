import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page14_rating_screen_model.dart';
export 'page14_rating_screen_model.dart';

class Page14RatingScreenWidget extends StatefulWidget {
  const Page14RatingScreenWidget({super.key, this.rideId = ''});

  final String rideId;

  static String routeName = 'Page14RatingScreen';
  static String routePath = '/page14RatingScreen';

  @override
  State<Page14RatingScreenWidget> createState() =>
      _Page14RatingScreenWidgetState();
}

class _Page14RatingScreenWidgetState extends State<Page14RatingScreenWidget> {
  late Page14RatingScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _ride;
  bool _loading = true;
  int _selectedStars = 0;
  bool _submitting = false;
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Page14RatingScreenModel());
    _loadRide();
  }

  Future<void> _loadRide() async {
    if (widget.rideId.isNotEmpty) {
      final data = await fetchRideById(widget.rideId);
      if (mounted) setState(() { _ride = data; _loading = false; });
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

  String get _driverName => _ride?['driver_name'] ?? 'Driver';
  String get _firstName => _driverName.trim().split(' ').first;

  String get _initials {
    final parts = _driverName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return _driverName.isNotEmpty ? _driverName[0].toUpperCase() : '?';
  }

  Future<void> _submit() async {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }
    setState(() => _submitting = true);
    if (widget.rideId.isNotEmpty) {
      await rateRide(widget.rideId, _selectedStars);
    }
    if (mounted) {
      context.goNamed(PassengersDashboardnewWidget.routeName);
    }
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
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        // Icon + title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _initials,
                                style: GoogleFonts.inter(
                                  color: theme.primary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Rate your Driver',
                              textAlign: TextAlign.center,
                              style: theme.headlineMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold),
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'How was your trip with $_firstName?',
                              textAlign: TextAlign.center,
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                color: theme.secondaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final filled = i < _selectedStars;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedStars = i + 1),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  filled
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: filled ? theme.tertiary : theme.accent3,
                                  size: 44,
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 32),

                        // Comment
                        Text(
                          'Leave a comment (optional)',
                          style: theme.labelLarge.override(
                            font: GoogleFonts.inter(),
                            color: theme.primaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _commentCtrl,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Tell us about your experience...',
                            hintStyle: GoogleFonts.inter(
                                color: theme.secondaryText, fontSize: 14),
                            filled: true,
                            fillColor: theme.secondaryBackground,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: theme.alternate, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: theme.alternate, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: theme.primary, width: 1.5),
                            ),
                          ),
                          style: GoogleFonts.inter(
                              color: theme.primaryText, fontSize: 14),
                        ),

                        const SizedBox(height: 40),

                        FFButtonWidget(
                          onPressed: _submitting ? null : _submit,
                          text: _submitting ? 'Submitting…' : 'Submit',
                          options: FFButtonOptions(
                            height: 50,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 0),
                            color: theme.primary,
                            textStyle: theme.titleSmall.override(
                              font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w600),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        const SizedBox(height: 12),

                        FFButtonWidget(
                          onPressed: _submitting
                              ? null
                              : () => context.goNamed(
                                  PassengersDashboardnewWidget.routeName),
                          text: 'Skip',
                          options: FFButtonOptions(
                            height: 48,
                            color: theme.secondaryBackground,
                            textStyle: theme.titleSmall.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                              color: theme.primaryText,
                              letterSpacing: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: theme.alternate, width: 1),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
