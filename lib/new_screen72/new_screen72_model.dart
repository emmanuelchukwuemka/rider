import '/backend/backend.dart';
import '/components/button21_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'new_screen72_widget.dart' show NewScreen72Widget;
import '/backend/schema/util/mock_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewScreen72Model extends FlutterFlowModel<NewScreen72Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for Button.
  late Button21Model buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => Button21Model());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
