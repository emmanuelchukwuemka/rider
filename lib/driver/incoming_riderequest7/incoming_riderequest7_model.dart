import '/components/location_node_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/button/button_widget.dart';
import '/pages/hex_stat_cell/hex_stat_cell_widget.dart';
import 'dart:ui';
import 'incoming_riderequest7_widget.dart' show IncomingRiderequest7Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class IncomingRiderequest7Model
    extends FlutterFlowModel<IncomingRiderequest7Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for LocationNode.
  late LocationNodeModel locationNodeModel1;
  // Model for LocationNode.
  late LocationNodeModel locationNodeModel2;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel1;
  // Model for HexStatCell.
  late HexStatCellModel hexStatCellModel2;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;

  @override
  void initState(BuildContext context) {
    locationNodeModel1 = createModel(context, () => LocationNodeModel());
    locationNodeModel2 = createModel(context, () => LocationNodeModel());
    hexStatCellModel1 = createModel(context, () => HexStatCellModel());
    hexStatCellModel2 = createModel(context, () => HexStatCellModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    locationNodeModel1.dispose();
    locationNodeModel2.dispose();
    hexStatCellModel1.dispose();
    hexStatCellModel2.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
