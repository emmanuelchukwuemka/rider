import '/components/text_field2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'page14_rating_screen_widget.dart' show Page14RatingScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Page14RatingScreenModel
    extends FlutterFlowModel<Page14RatingScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextField2Model textFieldModel;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextField2Model());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
  }
}
