import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import '/pages/earnings_card/earnings_card_widget.dart';
import '/pages/hex_stat_cell/hex_stat_cell_widget.dart';
import 'dart:ui';
import 'd_earnings_widget.dart' show DEarningsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DEarningsModel extends FlutterFlowModel<DEarningsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button.
  late ButtonModel buttonModel;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel1;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel2;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel3;
  // Model for EarningsCard.
  late EarningsCardModel earningsCardModel1;
  // Model for EarningsCard.
  late EarningsCardModel earningsCardModel2;
  // Model for EarningsCard.
  late EarningsCardModel earningsCardModel3;
  // Model for EarningsCard.
  late EarningsCardModel earningsCardModel4;
  // Model for EarningsCard.
  late EarningsCardModel earningsCardModel5;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => ButtonModel());
    hexStatCellModel1 = createModel(context, () => HexStatCellModel());
    hexStatCellModel2 = createModel(context, () => HexStatCellModel());
    hexStatCellModel3 = createModel(context, () => HexStatCellModel());
    earningsCardModel1 = createModel(context, () => EarningsCardModel());
    earningsCardModel2 = createModel(context, () => EarningsCardModel());
    earningsCardModel3 = createModel(context, () => EarningsCardModel());
    earningsCardModel4 = createModel(context, () => EarningsCardModel());
    earningsCardModel5 = createModel(context, () => EarningsCardModel());
  }

  @override
  void dispose() {
    buttonModel.dispose();
    hexStatCellModel1.dispose();
    hexStatCellModel2.dispose();
    hexStatCellModel3.dispose();
    earningsCardModel1.dispose();
    earningsCardModel2.dispose();
    earningsCardModel3.dispose();
    earningsCardModel4.dispose();
    earningsCardModel5.dispose();
  }
}
