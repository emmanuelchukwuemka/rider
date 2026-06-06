import '/components/journey_step_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import 'dart:ui';
import 'p_trip_in_progress_widget.dart' show PTripInProgressWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PTripInProgressModel extends FlutterFlowModel<PTripInProgressWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for JourneyStep.
  late JourneyStepModel journeyStepModel1;
  // Model for JourneyStep.
  late JourneyStepModel journeyStepModel2;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for Button.
  late ButtonModel buttonModel3;

  @override
  void initState(BuildContext context) {
    buttonModel1 = createModel(context, () => ButtonModel());
    journeyStepModel1 = createModel(context, () => JourneyStepModel());
    journeyStepModel2 = createModel(context, () => JourneyStepModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    buttonModel3 = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    buttonModel1.dispose();
    journeyStepModel1.dispose();
    journeyStepModel2.dispose();
    buttonModel2.dispose();
    buttonModel3.dispose();
  }
}
