import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _RideSource =
          latLngFromString(prefs.getString('ff_RideSource')) ?? _RideSource;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _selectedLocation = 'Enter Destination';
  String get selectedLocation => _selectedLocation;
  set selectedLocation(String value) {
    _selectedLocation = value;
  }

  int _ridePrice = 4500;
  int get ridePrice => _ridePrice;
  set ridePrice(int value) {
    _ridePrice = value;
  }

  String _userRole = '';
  String get userRole => _userRole;
  set userRole(String value) {
    _userRole = value;
  }

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String _smscode = '';
  String get smscode => _smscode;
  set smscode(String value) {
    _smscode = value;
  }

  LatLng? _RideSource;
  LatLng? get RideSource => _RideSource;
  set RideSource(LatLng? value) {
    _RideSource = value;
    value != null
        ? prefs.setString('ff_RideSource', value.serialize())
        : prefs.remove('ff_RideSource');
  }

  int _timerDuration = 60;
  int get timerDuration => _timerDuration;
  set timerDuration(int value) {
    _timerDuration = value;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
  }

  String _selectedRideId = '';
  String get selectedRideId => _selectedRideId;
  set selectedRideId(String value) {
    _selectedRideId = value;
  }

  LatLng? _driverLocation = LatLng(6.452574299999999, 3.4042858);
  LatLng? get driverLocation => _driverLocation;
  set driverLocation(LatLng? value) {
    _driverLocation = value;
  }

  DateTime? _rideUpdateTime;
  DateTime? get rideUpdateTime => _rideUpdateTime;
  set rideUpdateTime(DateTime? value) {
    _rideUpdateTime = value;
  }

  LatLng? _pickuplocation;
  LatLng? get pickuplocation => _pickuplocation;
  set pickuplocation(LatLng? value) {
    _pickuplocation = value;
  }

  LatLng? _dropoffLocation;
  LatLng? get dropoffLocation => _dropoffLocation;
  set dropoffLocation(LatLng? value) {
    _dropoffLocation = value;
  }

  DateTime? _Scheduledride;
  DateTime? get Scheduledride => _Scheduledride;
  set Scheduledride(DateTime? value) {
    _Scheduledride = value;
  }

  int _price = 0;
  int get price => _price;
  set price(int value) {
    _price = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
