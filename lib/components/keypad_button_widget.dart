import '/components/button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'keypad_button_model.dart';
export 'keypad_button_model.dart';

class KeypadButtonWidget extends StatefulWidget {
  const KeypadButtonWidget({
    super.key,
    String? digit,
  }) : this.digit = digit ?? '1';

  final String digit;

  @override
  State<KeypadButtonWidget> createState() => _KeypadButtonWidgetState();
}

class _KeypadButtonWidgetState extends State<KeypadButtonWidget> {
  late KeypadButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KeypadButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
        child: ButtonWidget(
          content: valueOrDefault<String>(
            widget!.digit,
            '1',
          ),
          icon_present: false,
          icon_end_present: false,
          variant: 'ghost',
          size: 'large',
          full_width: false,
          loading: false,
          disabled: false,
        ),
      ),
    );
  }
}
