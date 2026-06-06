import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import '/pages/hex_stat_cell/hex_stat_cell_widget.dart';
import 'dart:ui';
import 'd_welcome_widget.dart' show DWelcomeWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_palette/material_palette.dart';
import 'package:provider/provider.dart';

class DWelcomeModel extends FlutterFlowModel<DWelcomeWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel1;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel2;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel3;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    hexStatCellModel1 = createModel(context, () => HexStatCellModel());
    hexStatCellModel2 = createModel(context, () => HexStatCellModel());
    hexStatCellModel3 = createModel(context, () => HexStatCellModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    hexStatCellModel1.dispose();
    hexStatCellModel2.dispose();
    hexStatCellModel3.dispose();
    buttonModel.dispose();
  }
}
