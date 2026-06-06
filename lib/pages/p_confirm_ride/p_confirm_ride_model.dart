import '/components/location_node_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import 'dart:ui';
import 'p_confirm_ride_widget.dart' show PConfirmRideWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PConfirmRideModel extends FlutterFlowModel<PConfirmRideWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for LocationNode.
  late LocationNodeModel locationNodeModel1;
  // Model for LocationNode.
  late LocationNodeModel locationNodeModel2;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    locationNodeModel1 = createModel(context, () => LocationNodeModel());
    locationNodeModel2 = createModel(context, () => LocationNodeModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    locationNodeModel1.dispose();
    locationNodeModel2.dispose();
    buttonModel.dispose();
  }
}
