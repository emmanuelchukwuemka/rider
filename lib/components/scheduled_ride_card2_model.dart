import '/components/button15_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'scheduled_ride_card2_widget.dart' show ScheduledRideCard2Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ScheduledRideCard2Model
    extends FlutterFlowModel<ScheduledRideCard2Widget> {
  ///  State fields for stateful widgets in this component.

  // Model for Button.
  late Button15Model buttonModel1;
  // Model for Button.
  late Button15Model buttonModel2;

  @override
  void initState(BuildContext context) {
    buttonModel1 = createModel(context, () => Button15Model());
    buttonModel2 = createModel(context, () => Button15Model());
  }

  @override
  void dispose() {
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
