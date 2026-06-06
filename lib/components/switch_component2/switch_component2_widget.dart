import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'switch_component2_model.dart';
export 'switch_component2_model.dart';

class SwitchComponent2Widget extends StatefulWidget {
  const SwitchComponent2Widget({
    super.key,
    String? label,
    bool? labelPresent,
    String? variant,
    bool? active,
  })  : this.label = label ?? '',
        this.labelPresent = labelPresent ?? false,
        this.variant = variant ?? 'iOS',
        this.active = active ?? true;

  final String label;
  final bool labelPresent;
  final String variant;
  final bool active;

  @override
  State<SwitchComponent2Widget> createState() => _SwitchComponent2WidgetState();
}

class _SwitchComponent2WidgetState extends State<SwitchComponent2Widget> {
  late SwitchComponent2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SwitchComponent2Model());

    _model.switchValue = widget!.active ? true : false;
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (() {
          if (widget!.variant == 'iOS') {
            return true;
          } else if (widget!.variant == 'iOS 26+') {
            return false;
          } else {
            return true;
          }
        }())
          Switch.adaptive(
            value: _model.switchValue!,
            onChanged: (newValue) async {
              safeSetState(() => _model.switchValue = newValue!);
            },
            activeTrackColor: FlutterFlowTheme.of(context).primary,
            inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
            inactiveThumbColor: FlutterFlowTheme.of(context).primaryBackground,
          ),
        if (() {
          if (widget!.variant == 'iOS') {
            return false;
          } else if (widget!.variant == 'iOS 26+') {
            return true;
          } else {
            return false;
          }
        }())
          Container(
            width: widget!.variant == 'iOS 26+' ? 64.0 : 56.0,
            height: widget!.variant == 'iOS 26+' ? 28.0 : 32.0,
            decoration: BoxDecoration(
              color: widget!.active
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(valueOrDefault<double>(
                  widget!.variant == 'iOS 26+' ? 9999.0 : 16.0,
                  0.0,
                )),
                topRight: Radius.circular(valueOrDefault<double>(
                  widget!.variant == 'iOS 26+' ? 9999.0 : 16.0,
                  0.0,
                )),
                bottomLeft: Radius.circular(valueOrDefault<double>(
                  widget!.variant == 'iOS 26+' ? 9999.0 : 16.0,
                  0.0,
                )),
                bottomRight: Radius.circular(valueOrDefault<double>(
                  widget!.variant == 'iOS 26+' ? 9999.0 : 16.0,
                  0.0,
                )),
              ),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  valueOrDefault<double>(
                    widget!.variant == 'iOS 26+' ? 2.0 : 3.0,
                    0.0,
                  ),
                  valueOrDefault<double>(
                    widget!.variant == 'iOS 26+' ? 2.0 : 3.0,
                    0.0,
                  ),
                  valueOrDefault<double>(
                    widget!.variant == 'iOS 26+' ? 2.0 : 3.0,
                    0.0,
                  ),
                  valueOrDefault<double>(
                    widget!.variant == 'iOS 26+' ? 2.0 : 3.0,
                    0.0,
                  )),
              child: Container(
                child: Container(
                  width: widget!.variant == 'iOS 26+' ? 39.0 : 26.0,
                  height: widget!.variant == 'iOS 26+' ? 24.0 : 26.0,
                  decoration: BoxDecoration(
                    color: () {
                      if (widget!.active) {
                        return FlutterFlowTheme.of(context).onPrimary;
                      } else if (widget!.variant == 'iOS 26+') {
                        return FlutterFlowTheme.of(context).secondaryBackground;
                      } else {
                        return FlutterFlowTheme.of(context).primaryBackground;
                      }
                    }(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(valueOrDefault<double>(
                        widget!.variant == 'iOS 26+' ? 9999.0 : 13.0,
                        0.0,
                      )),
                      topRight: Radius.circular(valueOrDefault<double>(
                        widget!.variant == 'iOS 26+' ? 9999.0 : 13.0,
                        0.0,
                      )),
                      bottomLeft: Radius.circular(valueOrDefault<double>(
                        widget!.variant == 'iOS 26+' ? 9999.0 : 13.0,
                        0.0,
                      )),
                      bottomRight: Radius.circular(valueOrDefault<double>(
                        widget!.variant == 'iOS 26+' ? 9999.0 : 13.0,
                        0.0,
                      )),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ),
          ),
        if (valueOrDefault<bool>(
          widget!.labelPresent,
          false,
        ))
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
            child: Container(
              child: Text(
                widget!.label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      lineHeight: 1.47,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
