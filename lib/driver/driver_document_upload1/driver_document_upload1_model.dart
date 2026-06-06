import '/components/button2/button2_widget.dart';
import '/components/hex_upload_card/hex_upload_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'driver_document_upload1_widget.dart' show DriverDocumentUpload1Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DriverDocumentUpload1Model
    extends FlutterFlowModel<DriverDocumentUpload1Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for HexUploadCard.
  late HexUploadCardModel hexUploadCardModel1;
  // Model for HexUploadCard.
  late HexUploadCardModel hexUploadCardModel2;
  // Model for HexUploadCard.
  late HexUploadCardModel hexUploadCardModel3;
  // Model for HexUploadCard.
  late HexUploadCardModel hexUploadCardModel4;
  // Model for HexUploadCard.
  late HexUploadCardModel hexUploadCardModel5;
  // Model for HexUploadCard.
  late HexUploadCardModel hexUploadCardModel6;
  // Model for Button.
  late Button2Model buttonModel;

  @override
  void initState(BuildContext context) {
    hexUploadCardModel1 = createModel(context, () => HexUploadCardModel());
    hexUploadCardModel2 = createModel(context, () => HexUploadCardModel());
    hexUploadCardModel3 = createModel(context, () => HexUploadCardModel());
    hexUploadCardModel4 = createModel(context, () => HexUploadCardModel());
    hexUploadCardModel5 = createModel(context, () => HexUploadCardModel());
    hexUploadCardModel6 = createModel(context, () => HexUploadCardModel());
    buttonModel = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    hexUploadCardModel1.dispose();
    hexUploadCardModel2.dispose();
    hexUploadCardModel3.dispose();
    hexUploadCardModel4.dispose();
    hexUploadCardModel5.dispose();
    hexUploadCardModel6.dispose();
    buttonModel.dispose();
  }
}
