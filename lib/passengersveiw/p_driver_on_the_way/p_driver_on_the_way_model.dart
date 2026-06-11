import '/components/journey_step_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'p_driver_on_the_way_widget.dart' show PDriverOnTheWayWidget;
import 'package:flutter/material.dart';

class PDriverOnTheWayModel extends FlutterFlowModel<PDriverOnTheWayWidget> {
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  late JourneyStepModel journeyStepModel1;
  late JourneyStepModel journeyStepModel2;

  @override
  void initState(BuildContext context) {
    journeyStepModel1 = createModel(context, () => JourneyStepModel());
    journeyStepModel2 = createModel(context, () => JourneyStepModel());
  }

  @override
  void dispose() {
    journeyStepModel1.dispose();
    journeyStepModel2.dispose();
  }
}
