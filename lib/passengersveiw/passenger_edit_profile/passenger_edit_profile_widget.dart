import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'passenger_edit_profile_model.dart';
export 'passenger_edit_profile_model.dart';

class PassengerEditProfileWidget extends StatefulWidget {
  const PassengerEditProfileWidget({super.key});

  static String routeName = 'PassengerEditProfile';
  static String routePath = '/passengerEditProfile';

  @override
  State<PassengerEditProfileWidget> createState() => _PassengerEditProfileWidgetState();
}

class _PassengerEditProfileWidgetState extends State<PassengerEditProfileWidget> {
  late PassengerEditProfileModel _model;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _dobController = TextEditingController();

  String? _profileImagePath;
  String? _selectedGender;
  bool _saving = false;

  final List<String> _genders = ['Male', 'Female', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassengerEditProfileModel());
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('display_name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone_number') ?? '';
      _stateController.text = prefs.getString('profile_state') ?? '';
      _countryController.text = prefs.getString('profile_country') ?? '';
      _dobController.text = prefs.getString('profile_dob') ?? '';
      _selectedGender = prefs.getString('profile_gender');
      _profileImagePath = prefs.getString('profile_image_path');
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', image.path);
      setState(() => _profileImagePath = image.path);
    }
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: FlutterFlowTheme.of(context).primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Full name is required'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid') ?? '';

    final profileData = {
      'display_name': name,
      'phone_number': _phoneController.text.trim(),
      'state': _stateController.text.trim(),
      'country': _countryController.text.trim(),
      'dob': _dobController.text.trim(),
      if (_selectedGender != null) 'gender': _selectedGender,
    };

    // Save to backend DB
    final result = userId.isNotEmpty ? await updatePassengerProfile(userId, profileData) : null;

    // Always save locally as cache
    await prefs.setString('display_name', name);
    await prefs.setString('phone_number', _phoneController.text.trim());
    await prefs.setString('profile_state', _stateController.text.trim());
    await prefs.setString('profile_country', _countryController.text.trim());
    await prefs.setString('profile_dob', _dobController.text.trim());
    if (_selectedGender != null) await prefs.setString('profile_gender', _selectedGender!);

    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result != null ? 'Profile saved to database' : 'Profile saved locally'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );
      context.safePop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _dobController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20.0),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Edit Profile',
            style: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: _saving ? null : _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Photo
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FlutterFlowTheme.of(context).alternate,
                        boxShadow: [
                          BoxShadow(blurRadius: 10.0, color: Color(0x33000000), offset: Offset(0, 4))
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9999.0),
                        child: _profileImagePath != null
                            ? Image.file(File(_profileImagePath!), fit: BoxFit.cover)
                            : Icon(Icons.person_rounded, size: 50.0, color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: FlutterFlowTheme.of(context).primary,
                            border: Border.all(color: Colors.white, width: 2.0),
                          ),
                          child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: Text(
                    'Change Photo',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              _sectionLabel('Personal Information'),
              SizedBox(height: 12.0),

              _buildField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'e.g. Chidi Okonkwo',
                icon: Icons.person_outline_rounded,
              ),
              SizedBox(height: 16.0),
              _buildField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'e.g. chidi@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              _buildField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'e.g. +234 800 000 0000',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),

              // Gender Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    hint: Text('Select gender', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryText)),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.wc_rounded, color: FlutterFlowTheme.of(context).secondaryText, size: 20.0),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2.0),
                      ),
                    ),
                    items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) => setState(() => _selectedGender = val),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Date of Birth
              _buildField(
                controller: _dobController,
                label: 'Date of Birth',
                hint: 'DD/MM/YYYY',
                icon: Icons.cake_outlined,
                readOnly: true,
                onTap: _pickDob,
              ),
              SizedBox(height: 32.0),

              _sectionLabel('Location'),
              SizedBox(height: 12.0),

              _buildField(
                controller: _stateController,
                label: 'State / Province',
                hint: 'e.g. Lagos',
                icon: Icons.location_city_outlined,
              ),
              SizedBox(height: 16.0),
              _buildField(
                controller: _countryController,
                label: 'Country',
                hint: 'e.g. Nigeria',
                icon: Icons.flag_outlined,
              ),
              SizedBox(height: 40.0),

              FFButtonWidget(
                onPressed: _saving ? null : _saveProfile,
                text: _saving ? 'Saving...' : 'Save Changes',
                options: FFButtonOptions(
                  height: 54.0,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  elevation: 0.0,
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: FlutterFlowTheme.of(context).labelLarge.override(
        font: GoogleFonts.inter(fontWeight: FontWeight.w700),
        color: FlutterFlowTheme.of(context).primaryText,
        letterSpacing: 0.0,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
          ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
            prefixIcon: Icon(icon, color: FlutterFlowTheme.of(context).secondaryText, size: 20.0),
            suffixIcon: readOnly && onTap != null
                ? Icon(Icons.calendar_today_outlined, color: FlutterFlowTheme.of(context).secondaryText, size: 18.0)
                : null,
            filled: true,
            fillColor: readOnly
                ? FlutterFlowTheme.of(context).alternate.withOpacity(0.3)
                : FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2.0),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(),
            color: readOnly
                ? FlutterFlowTheme.of(context).secondaryText
                : FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
          ),
        ),
      ],
    );
  }
}
