import '/components/button12_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'scheduled_ride_card_widget.dart' show ScheduledRideCardWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ScheduledRideCardModel extends FlutterFlowModel<ScheduledRideCardWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Button.
  late Button12Model buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => Button12Model());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
