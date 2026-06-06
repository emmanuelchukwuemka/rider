import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'page12_trip_in_progress_widget.dart' show Page12TripInProgressWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class Page12TripInProgressModel
    extends FlutterFlowModel<Page12TripInProgressWidget> {
  ///  Local state fields for this page.

  List<LatLng> location = [];
  void addToLocation(LatLng item) => location.add(item);
  void removeFromLocation(LatLng item) => location.remove(item);
  void removeAtIndexFromLocation(int index) => location.removeAt(index);
  void insertAtIndexInLocation(int index, LatLng item) =>
      location.insert(index, item);
  void updateLocationAtIndex(int index, Function(LatLng) updateFn) =>
      location[index] = updateFn(location[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
