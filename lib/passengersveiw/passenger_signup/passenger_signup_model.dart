import '/components/button2/button2_widget.dart';
import '/components/text_field2/text_field2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'passenger_signup_widget.dart' show PassengerSignupWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PassengerSignupModel extends FlutterFlowModel<PassengerSignupWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button.
  late Button2Model buttonModel1;
  // Model for TextField FullName.
  late TextField2Model textFieldModel1;
  // Model for TextField Email.
  late TextField2Model textFieldModel2;
  // Model for TextField Phone.
  late TextField2Model textFieldModel3;
  // Model for TextField Password.
  late TextField2Model textFieldModel4;
  // Model for TextField Retype Password.
  late TextField2Model textFieldModel5;
  // Model for Button Continue.
  late Button2Model buttonModel2;
  // Model for Button Login.
  late Button2Model buttonModel3;

  @override
  void initState(BuildContext context) {
    buttonModel1 = createModel(context, () => Button2Model());
    textFieldModel1 = createModel(context, () => TextField2Model());
    textFieldModel2 = createModel(context, () => TextField2Model());
    textFieldModel3 = createModel(context, () => TextField2Model());
    textFieldModel4 = createModel(context, () => TextField2Model());
    textFieldModel5 = createModel(context, () => TextField2Model());
    buttonModel2 = createModel(context, () => Button2Model());
    buttonModel3 = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    buttonModel1.dispose();
    textFieldModel1.dispose();
    textFieldModel2.dispose();
    textFieldModel3.dispose();
    textFieldModel4.dispose();
    textFieldModel5.dispose();
    buttonModel2.dispose();
    buttonModel3.dispose();
  }
}
