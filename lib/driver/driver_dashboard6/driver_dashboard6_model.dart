import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/hex_stat_card2/hex_stat_card2_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'driver_dashboard6_widget.dart' show DriverDashboard6Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DriverDashboard6Model extends FlutterFlowModel<DriverDashboard6Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for HexStatCard.
  late HexStatCard2Model hexStatCardModel1;
  // Model for HexStatCard.
  late HexStatCard2Model hexStatCardModel2;
  // Model for HexStatCard.
  late HexStatCard2Model hexStatCardModel3;
  // Model for HexStatCard.
  late HexStatCard2Model hexStatCardModel4;
  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {
    hexStatCardModel1 = createModel(context, () => HexStatCard2Model());
    hexStatCardModel2 = createModel(context, () => HexStatCard2Model());
    hexStatCardModel3 = createModel(context, () => HexStatCard2Model());
    hexStatCardModel4 = createModel(context, () => HexStatCard2Model());
  }

  @override
  void dispose() {
    hexStatCardModel1.dispose();
    hexStatCardModel2.dispose();
    hexStatCardModel3.dispose();
    hexStatCardModel4.dispose();
  }
}
