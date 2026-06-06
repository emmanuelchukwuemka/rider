import '/components/location_node_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'earnings_card_widget.dart' show EarningsCardWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EarningsCardModel extends FlutterFlowModel<EarningsCardWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for LocationNode.
  late LocationNodeModel locationNodeModel1;
  // Model for LocationNode.
  late LocationNodeModel locationNodeModel2;

  @override
  void initState(BuildContext context) {
    locationNodeModel1 = createModel(context, () => LocationNodeModel());
    locationNodeModel2 = createModel(context, () => LocationNodeModel());
  }

  @override
  void dispose() {
    locationNodeModel1.dispose();
    locationNodeModel2.dispose();
  }
}
