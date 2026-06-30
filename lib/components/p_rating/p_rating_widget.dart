import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_rating_model.dart';
export 'p_rating_model.dart';

class PRatingWidget extends StatefulWidget {
  const PRatingWidget({super.key, this.rideId = ''});

  final String rideId;

  static String routeName = 'PRating';
  static String routePath = '/pRating';

  @override
  State<PRatingWidget> createState() => _PRatingWidgetState();
}

class _PRatingWidgetState extends State<PRatingWidget> {
  late PRatingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _ride;
  bool _loading = true;
  int _selectedStars = 0;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PRatingModel());
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
    _model.dispose();
    super.dispose();
  }

  String get _passengerName => _ride?['passenger_name'] ?? 'Passenger';

  String get _initials {
    final parts = _passengerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return _passengerName.isNotEmpty ? _passengerName[0].toUpperCase() : '?';
  }

  Future<void> _submitRating() async {
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
      context.goNamed(DriverDashboard6Widget.routeName);
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

                        // Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Rate Your Passenger',
                              textAlign: TextAlign.center,
                              style: theme.headlineMedium.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold),
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'How was your trip with ${_passengerName.split(' ').first}?',
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

                        // Avatar + name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: theme.primary.withOpacity(0.4),
                                    width: 2),
                              ),
                              child: Text(
                                _initials,
                                style: GoogleFonts.inter(
                                  color: theme.primary,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _passengerName,
                              style: theme.titleLarge.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Stars
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tap to rate',
                              style: theme.labelLarge.override(
                                font: GoogleFonts.inter(),
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final filled = i < _selectedStars;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedStars = i + 1),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Icon(
                                      filled
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color: filled
                                          ? theme.tertiary
                                          : theme.accent3,
                                      size: 44,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Quick tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            'Polite',
                            'On Time',
                            'Quiet',
                            'Friendly',
                          ]
                              .map((tag) => _TagChip(
                                    label: tag,
                                    theme: theme,
                                  ))
                              .toList(),
                        ),

                        const SizedBox(height: 40),

                        // Submit
                        FFButtonWidget(
                          onPressed: _submitting ? null : _submitRating,
                          text: _submitting ? 'Submitting…' : 'Submit Rating',
                          options: FFButtonOptions(
                            height: 52,
                            color: theme.primary,
                            textStyle: theme.titleSmall.override(
                              font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                              color: theme.onPrimary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Skip
                        FFButtonWidget(
                          onPressed: _submitting
                              ? null
                              : () => context
                                  .goNamed(DriverDashboard6Widget.routeName),
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: theme.alternate, width: 1),
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

class _TagChip extends StatefulWidget {
  const _TagChip({required this.label, required this.theme});
  final String label;
  final FlutterFlowTheme theme;

  @override
  State<_TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<_TagChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: Container(
        height: 34,
        padding:
            const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _selected
              ? widget.theme.primary.withOpacity(0.12)
              : widget.theme.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selected
                ? widget.theme.primary
                : widget.theme.alternate,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selected) ...[
              Icon(Icons.check_rounded,
                  color: widget.theme.primary, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              widget.label,
              style: GoogleFonts.inter(
                color: _selected
                    ? widget.theme.primary
                    : widget.theme.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
