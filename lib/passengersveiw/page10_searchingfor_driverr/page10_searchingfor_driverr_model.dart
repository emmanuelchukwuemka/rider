import '/auth/custom_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/passenger_ride_cancellation_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'page10_searchingfor_driverr_widget.dart'
    show Page10SearchingforDriverrWidget;
import '/backend/schema/util/mock_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Page10SearchingforDriverrModel
    extends FlutterFlowModel<Page10SearchingforDriverrWidget> {
  ///  Local state fields for this page.

  List<LatLng> location = [];
  void addToLocation(LatLng item) => location.add(item);
  void removeFromLocation(LatLng item) => location.remove(item);
  void removeAtIndexFromLocation(int index) => location.removeAt(index);
  void insertAtIndexInLocation(int index, LatLng item) =>
      location.insert(index, item);
  void updateLocationAtIndex(int index, Function(LatLng) updateFn) =>
      location[index] = updateFn(location[index]);

  bool isupdated = true;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
