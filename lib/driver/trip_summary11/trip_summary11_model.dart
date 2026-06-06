import '/components/button2/button2_widget.dart';
import '/components/fare_item/fare_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'trip_summary11_widget.dart' show TripSummary11Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TripSummary11Model extends FlutterFlowModel<TripSummary11Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for FareItem.
  late FareItemModel fareItemModel1;
  // Model for FareItem.
  late FareItemModel fareItemModel2;
  // Model for FareItem.
  late FareItemModel fareItemModel3;
  // Model for FareItem.
  late FareItemModel fareItemModel4;
  // Model for Button.
  late Button2Model buttonModel;

  @override
  void initState(BuildContext context) {
    fareItemModel1 = createModel(context, () => FareItemModel());
    fareItemModel2 = createModel(context, () => FareItemModel());
    fareItemModel3 = createModel(context, () => FareItemModel());
    fareItemModel4 = createModel(context, () => FareItemModel());
    buttonModel = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    fareItemModel1.dispose();
    fareItemModel2.dispose();
    fareItemModel3.dispose();
    fareItemModel4.dispose();
    buttonModel.dispose();
  }
}
