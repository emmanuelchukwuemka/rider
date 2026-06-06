import '/components/button17_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'new_screen5_widget.dart' show NewScreen5Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewScreen5Model extends FlutterFlowModel<NewScreen5Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for Button.
  late Button17Model buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => Button17Model());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
