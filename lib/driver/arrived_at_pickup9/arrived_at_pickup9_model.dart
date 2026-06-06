import '/components/button2/button2_widget.dart';
import '/components/location_node2/location_node2_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'arrived_at_pickup9_widget.dart' show ArrivedAtPickup9Widget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ArrivedAtPickup9Model extends FlutterFlowModel<ArrivedAtPickup9Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for LocationNode.
  late LocationNode2Model locationNodeModel1;
  // Model for LocationNode.
  late LocationNode2Model locationNodeModel2;
  // Model for Button.
  late Button2Model buttonModel;

  @override
  void initState(BuildContext context) {
    locationNodeModel1 = createModel(context, () => LocationNode2Model());
    locationNodeModel2 = createModel(context, () => LocationNode2Model());
    buttonModel = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    locationNodeModel1.dispose();
    locationNodeModel2.dispose();
    buttonModel.dispose();
  }
}
