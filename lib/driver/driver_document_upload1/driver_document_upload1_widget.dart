import '/components/button2/button2_widget.dart';
import '/components/hex_upload_card/hex_upload_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/components/button2/button2_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '/backend/api_service.dart';
import '/backend/backend.dart';
import '/auth/custom_auth/auth_util.dart';
import 'driver_document_upload1_model.dart';
export 'driver_document_upload1_model.dart';

class DriverDocumentUpload1Widget extends StatefulWidget {
  const DriverDocumentUpload1Widget({super.key});

  static String routeName = 'DriverDocumentUpload1';
  static String routePath = '/driverDocumentUpload1';

  @override
  State<DriverDocumentUpload1Widget> createState() =>
      _DriverDocumentUpload1WidgetState();
}

class _DriverDocumentUpload1WidgetState
    extends State<DriverDocumentUpload1Widget> {
  late DriverDocumentUpload1Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<int, XFile?> _selectedImages = {};
  bool _isUploading = false;

  Future<void> _pickImage(int type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages[type] = image;
      });
    }
  }

  Future<void> _submitDocuments() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one document.')));
      return;
    }
    setState(() => _isUploading = true);
    final updates = <String, dynamic>{};
    
    final typeToField = {
      1: 'license_image',
      2: 'national_id_image',
      3: 'registration_image',
      4: 'insurance_image',
      5: 'vehicle_exterior_image',
      6: 'selfie_image',
    };

    for (var entry in _selectedImages.entries) {
      final url = await uploadProfileImage(entry.value!.path);
      if (url != null) {
        updates[typeToField[entry.key]!] = url;
      }
    }

    String? driverId;
    try {
      final drivers = await fetchCollection('drivers');
      final driver = drivers.firstWhere((d) => d['uid'] == currentUserUid, orElse: () => {});
      driverId = driver['id'];
    } catch (_) {}

    if (driverId != null && updates.isNotEmpty) {
      await updateDriverProfile(driverId, updates);
    }

    setState(() => _isUploading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Documents uploaded successfully!')));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DriverDocumentUpload1Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                          Container(
                            height: 8.0,
                          ),
                          Text(
                            'Upload Documents',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                  lineHeight: 1.25,
                                ),
                          ),
                          Text(
                            'Please provide clear photos of the following documents to verify your account.',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.47,
                                ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                      Container(
                        height: 24.0,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => _pickImage(1),
                            child: wrapWithModel(
                              model: _model.hexUploadCardModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: HexUploadCardWidget(
                                description: 'Front and back of your valid license',
                                icon: Icon(Icons.badge_rounded, color: FlutterFlowTheme.of(context).success, size: 28.0),
                                name: 'Driver\'s License',
                                status: _selectedImages[1] != null ? 'uploaded' : 'pending',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _pickImage(2),
                            child: wrapWithModel(
                              model: _model.hexUploadCardModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: HexUploadCardWidget(
                                description: 'Government issued identification',
                                icon: Icon(Icons.person_pin_rounded, color: FlutterFlowTheme.of(context).primary, size: 28.0),
                                name: 'National ID / Passport',
                                status: _selectedImages[2] != null ? 'uploaded' : 'pending',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _pickImage(3),
                            child: wrapWithModel(
                              model: _model.hexUploadCardModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: HexUploadCardWidget(
                                description: 'Proof of ownership document',
                                icon: Icon(Icons.description_rounded, color: FlutterFlowTheme.of(context).primary, size: 28.0),
                                name: 'Vehicle Registration',
                                status: _selectedImages[3] != null ? 'uploaded' : 'pending',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _pickImage(4),
                            child: wrapWithModel(
                              model: _model.hexUploadCardModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: HexUploadCardWidget(
                                description: 'Current valid vehicle insurance',
                                icon: Icon(Icons.verified_user_rounded, color: FlutterFlowTheme.of(context).primary, size: 28.0),
                                name: 'Insurance Policy',
                                status: _selectedImages[4] != null ? 'uploaded' : 'pending',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _pickImage(5),
                            child: wrapWithModel(
                              model: _model.hexUploadCardModel5,
                              updateCallback: () => safeSetState(() {}),
                              child: HexUploadCardWidget(
                                description: 'Clear photo showing plate number',
                                icon: Icon(Icons.directions_car_rounded, color: FlutterFlowTheme.of(context).primary, size: 28.0),
                                name: 'Vehicle Exterior',
                                status: _selectedImages[5] != null ? 'uploaded' : 'pending',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _pickImage(6),
                            child: wrapWithModel(
                              model: _model.hexUploadCardModel6,
                              updateCallback: () => safeSetState(() {}),
                              child: HexUploadCardWidget(
                                description: 'A clear photo of your face',
                                icon: Icon(Icons.face_rounded, color: FlutterFlowTheme.of(context).primary, size: 28.0),
                                name: 'Selfie Verification',
                                status: _selectedImages[6] != null ? 'uploaded' : 'pending',
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                      Container(
                        height: 32.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: FlutterFlowTheme.of(context).onSurface,
                                  size: 20.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'All documents must be valid and clearly legible. Approval usually takes 24-48 hours.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 16.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 32.0,
                      ),
                      InkWell(
                        onTap: _isUploading ? null : _submitDocuments,
                        child: wrapWithModel(
                          model: _model.buttonModel,
                          updateCallback: () => safeSetState(() {}),
                          child: Button2Widget(
                            content: _isUploading ? 'Uploading...' : 'Submit Documents',
                            iconPresent: false,
                            iconEndPresent: false,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            variant: 'primary',
                            size: 'large',
                            fullWidth: true,
                            loading: false,
                            disabled: _isUploading,
                          ),
                        ),
                      ),
                      Container(
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
