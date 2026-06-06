import '/components/journey_step_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import 'dart:ui';
import 'p_driver_assigned_widget.dart' show PDriverAssignedWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PDriverAssignedModel extends FlutterFlowModel<PDriverAssignedWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for JourneyStep.
  late JourneyStepModel journeyStepModel1;
  // Model for JourneyStep.
  late JourneyStepModel journeyStepModel2;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => ButtonModel());
    journeyStepModel1 = createModel(context, () => JourneyStepModel());
    journeyStepModel2 = createModel(context, () => JourneyStepModel());
  }

  @override
  void dispose() {
    buttonModel.dispose();
    journeyStepModel1.dispose();
    journeyStepModel2.dispose();
  }
}
