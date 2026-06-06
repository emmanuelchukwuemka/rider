import '/components/location_entry_widget.dart';
import '/components/shelf_header_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import 'dart:ui';
import 'p_set_destination_widget.dart' show PSetDestinationWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PSetDestinationModel extends FlutterFlowModel<PSetDestinationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextFieldModel textFieldModel1;
  // Model for TextField.
  late TextFieldModel textFieldModel2;
  // Model for ShelfHeader.
  late ShelfHeaderModel shelfHeaderModel;
  // Model for LocationEntry.
  late LocationEntryModel locationEntryModel1;
  // Model for LocationEntry.
  late LocationEntryModel locationEntryModel2;
  // Model for LocationEntry.
  late LocationEntryModel locationEntryModel3;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    textFieldModel1 = createModel(context, () => TextFieldModel());
    textFieldModel2 = createModel(context, () => TextFieldModel());
    shelfHeaderModel = createModel(context, () => ShelfHeaderModel());
    locationEntryModel1 = createModel(context, () => LocationEntryModel());
    locationEntryModel2 = createModel(context, () => LocationEntryModel());
    locationEntryModel3 = createModel(context, () => LocationEntryModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    textFieldModel1.dispose();
    textFieldModel2.dispose();
    shelfHeaderModel.dispose();
    locationEntryModel1.dispose();
    locationEntryModel2.dispose();
    locationEntryModel3.dispose();
    buttonModel.dispose();
  }
}
