import '/components/button2/button2_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'trip_in_progress10_widget.dart' show TripInProgress10Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TripInProgress10Model extends FlutterFlowModel<TripInProgress10Widget> {
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
  // Model for Button.
  late Button2Model buttonModel1;
  // Model for Button.
  late Button2Model buttonModel2;

  @override
  void initState(BuildContext context) {
    buttonModel1 = createModel(context, () => Button2Model());
    buttonModel2 = createModel(context, () => Button2Model());
  }

  @override
  void dispose() {
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
