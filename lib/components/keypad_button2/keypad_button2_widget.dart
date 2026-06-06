import '/components/button2/button2_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'keypad_button2_model.dart';
export 'keypad_button2_model.dart';

class KeypadButton2Widget extends StatefulWidget {
  const KeypadButton2Widget({
    super.key,
    String? digit,
  }) : this.digit = digit ?? '5';

  final String digit;

  @override
  State<KeypadButton2Widget> createState() => _KeypadButton2WidgetState();
}

class _KeypadButton2WidgetState extends State<KeypadButton2Widget> {
  late KeypadButton2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KeypadButton2Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9999.0),
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: wrapWithModel(
        model: _model.buttonModel,
        updateCallback: () => safeSetState(() {}),
        child: Button2Widget(
          content: valueOrDefault<String>(
            widget!.digit,
            '5',
          ),
          iconPresent: false,
          iconEndPresent: false,
          color: FlutterFlowTheme.of(context).secondaryText,
          variant: 'ghost',
          size: 'large',
          fullWidth: false,
          loading: false,
          disabled: false,
        ),
      ),
    );
  }
}
