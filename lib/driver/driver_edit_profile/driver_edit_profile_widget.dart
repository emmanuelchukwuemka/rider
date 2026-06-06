import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/components/button2/button2_widget.dart';
import '/backend/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'driver_edit_profile_model.dart';
export 'driver_edit_profile_model.dart';
import '/backend/backend.dart';
import '/auth/custom_auth/auth_util.dart';

class DriverEditProfileWidget extends StatefulWidget {
  const DriverEditProfileWidget({super.key});

  static String routeName = 'DriverEditProfile';
  static String routePath = '/driverEditProfile';

  @override
  State<DriverEditProfileWidget> createState() =>
      _DriverEditProfileWidgetState();
}

class _DriverEditProfileWidgetState extends State<DriverEditProfileWidget> {
  late DriverEditProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _currentPhotoUrl;
  String? _driverId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DriverEditProfileModel());
    _model.nameController ??= TextEditingController();
    _model.phoneController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _model.isDataUploading = true;
      });
      
      final uploadedUrl = await uploadProfileImage(image.path);
      
      if (uploadedUrl != null) {
        setState(() {
          _model.uploadedFileUrl = uploadedUrl;
          _currentPhotoUrl = baseUrl + uploadedUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
      
      setState(() {
        _model.isDataUploading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_driverId == null) return;
    
    setState(() {
      _model.isDataUploading = true;
    });

    Map<String, dynamic> updates = {
      'display_name': _model.nameController!.text,
      'phone_number': _model.phoneController!.text,
    };
    
    if (_model.uploadedFileUrl.isNotEmpty) {
      updates['photo_url'] = _model.uploadedFileUrl;
    }

    final success = await updateDriverProfile(_driverId!, updates);
    
    setState(() {
      _model.isDataUploading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      context.pop(); // Go back
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserDriverRecord>>(
      stream: queryUserDriverRecord(
        queryBuilder: (q) => q.where('uid', isEqualTo: currentUserUid),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final driverRecordList = snapshot.data!;
        final driverRecord = driverRecordList.isNotEmpty ? driverRecordList.first : null;
        
        if (driverRecord == null) {
          return Scaffold(
            body: Center(child: Text("Profile not found")),
          );
        }

        // Initialize controllers once
        if (_driverId == null) {
          _driverId = driverRecord.reference.id;
          _model.nameController?.text = driverRecord.displayName;
          _model.phoneController?.text = driverRecord.phoneNumber;
          _currentPhotoUrl = driverRecord.photoUrl.isNotEmpty 
              ? (driverRecord.photoUrl.startsWith('http') ? driverRecord.photoUrl : baseUrl + driverRecord.photoUrl)
              : 'https://dimg.dreamflow.cloud/v1/image/friendly%20passenger%20portrait';
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Text(
                'Edit Profile',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22.0,
                    ),
              ),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: CachedNetworkImage(
                                  imageUrl: _currentPhotoUrl!,
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (_model.isDataUploading)
                                Center(child: CircularProgressIndicator()),
                              Align(
                                alignment: AlignmentDirectional(1.0, 1.0),
                                child: Container(
                                  width: 32.0,
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: _model.nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                      child: TextFormField(
                        controller: _model.phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: _model.isDataUploading ? null : _saveChanges,
                        text: 'Save Changes',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.inter(),
                                color: Colors.white,
                              ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
