import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import 'passengers_dashboardnew_widget.dart' show PassengersDashboardnewWidget;
import 'package:flutter/material.dart';

class PassengersDashboardnewModel
    extends FlutterFlowModel<PassengersDashboardnewWidget> {

  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
