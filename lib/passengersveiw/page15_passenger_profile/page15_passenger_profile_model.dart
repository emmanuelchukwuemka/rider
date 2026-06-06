import '/auth/custom_auth/auth_util.dart';
import '/components/settings_option2_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'page15_passenger_profile_widget.dart' show Page15PassengerProfileWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Page15PassengerProfileModel
    extends FlutterFlowModel<Page15PassengerProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SettingsOption.
  late SettingsOption2Model settingsOptionModel1;
  // Model for SettingsOption.
  late SettingsOption2Model settingsOptionModel2;
  // Model for SettingsOption.
  late SettingsOption2Model settingsOptionModel3;
  // Model for SettingsOption.
  late SettingsOption2Model settingsOptionModel4;
  // Model for SettingsOption.
  late SettingsOption2Model settingsOptionModel5;

  @override
  void initState(BuildContext context) {
    settingsOptionModel1 = createModel(context, () => SettingsOption2Model());
    settingsOptionModel2 = createModel(context, () => SettingsOption2Model());
    settingsOptionModel3 = createModel(context, () => SettingsOption2Model());
    settingsOptionModel4 = createModel(context, () => SettingsOption2Model());
    settingsOptionModel5 = createModel(context, () => SettingsOption2Model());
  }

  @override
  void dispose() {
    settingsOptionModel1.dispose();
    settingsOptionModel2.dispose();
    settingsOptionModel3.dispose();
    settingsOptionModel4.dispose();
    settingsOptionModel5.dispose();
  }
}
