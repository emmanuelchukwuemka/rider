import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class DriverEditProfileModel extends FlutterFlowModel {
  final unfocusNode = FocusNode();
  
  TextEditingController? nameController;
  TextEditingController? phoneController;

  bool isDataUploading = false;
  String uploadedFileUrl = '';

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    nameController?.dispose();
    phoneController?.dispose();
  }
}
