import '/components/settings_option_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import 'dart:ui';
import 'p_profile_widget.dart' show PProfileWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PProfileModel extends FlutterFlowModel<PProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel1;
  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel2;
  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel3;
  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel4;
  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel5;
  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel6;
  // Model for SettingsOption.
  late SettingsOptionModel settingsOptionModel7;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    settingsOptionModel1 = createModel(context, () => SettingsOptionModel());
    settingsOptionModel2 = createModel(context, () => SettingsOptionModel());
    settingsOptionModel3 = createModel(context, () => SettingsOptionModel());
    settingsOptionModel4 = createModel(context, () => SettingsOptionModel());
    settingsOptionModel5 = createModel(context, () => SettingsOptionModel());
    settingsOptionModel6 = createModel(context, () => SettingsOptionModel());
    settingsOptionModel7 = createModel(context, () => SettingsOptionModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    settingsOptionModel1.dispose();
    settingsOptionModel2.dispose();
    settingsOptionModel3.dispose();
    settingsOptionModel4.dispose();
    settingsOptionModel5.dispose();
    settingsOptionModel6.dispose();
    settingsOptionModel7.dispose();
    buttonModel.dispose();
  }
}
