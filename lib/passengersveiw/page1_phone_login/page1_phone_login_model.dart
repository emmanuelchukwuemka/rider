import '/components/button2/button2_widget.dart';
import '/components/text_field2/text_field2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'page1_phone_login_widget.dart' show Page1PhoneLoginWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Page1PhoneLoginModel extends FlutterFlowModel<Page1PhoneLoginWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button (top-right "Become a Driver").
  late Button2Model buttonModel1;
  // Model for email TextField.
  late TextField2Model textFieldModel1;
  // Model for "Send OTP" Button.
  late Button2Model buttonModel3;

  @override
  void initState(BuildContext context) {
    buttonModel1 = createModel(context, () => Button2Model());
    textFieldModel1 = createModel(context, () => TextField2Model());
    buttonModel3 = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    buttonModel1.dispose();
    textFieldModel1.dispose();
    buttonModel3.dispose();
  }
}
