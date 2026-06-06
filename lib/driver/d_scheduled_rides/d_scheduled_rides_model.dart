import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/scheduled_ride_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'd_scheduled_rides_widget.dart' show DScheduledRidesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DScheduledRidesModel extends FlutterFlowModel<DScheduledRidesWidget> {
  ///  Local state fields for this page.

  List<RideModelStruct> scheduledRides = [];
  void addToScheduledRides(RideModelStruct item) => scheduledRides.add(item);
  void removeFromScheduledRides(RideModelStruct item) =>
      scheduledRides.remove(item);
  void removeAtIndexFromScheduledRides(int index) =>
      scheduledRides.removeAt(index);
  void insertAtIndexInScheduledRides(int index, RideModelStruct item) =>
      scheduledRides.insert(index, item);
  void updateScheduledRidesAtIndex(
          int index, Function(RideModelStruct) updateFn) =>
      scheduledRides[index] = updateFn(scheduledRides[index]);

  bool isLoading = false;

  String selectedRideId = '\"\"';

  LatLng? driverLocation;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
