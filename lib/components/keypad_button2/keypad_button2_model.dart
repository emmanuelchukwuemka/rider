import '/components/button2/button2_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'keypad_button2_widget.dart' show KeypadButton2Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class KeypadButton2Model extends FlutterFlowModel<KeypadButton2Widget> {
  ///  State fields for stateful widgets in this component.

  // Model for Button.
  late Button2Model buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
