// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/mock_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideModelStruct extends FFSupabaseStruct {
  RideModelStruct({
    String? rideId,
    LatLng? pickupLocation,
    LatLng? dropoffLocation,
    String? pickupAddress,
    String? dropoffAddress,
    double? estimatedFare,
    DateTime? scheduledTime,
    String? status,
    DateTime? createdAt,
    double? distance,
    int? estimatedDuration,
    String? passengerName,
    String? passengerPhone,
    double? riderRating,
    String? vehicleType,
    String? notes,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _rideId = rideId,
        _pickupLocation = pickupLocation,
        _dropoffLocation = dropoffLocation,
        _pickupAddress = pickupAddress,
        _dropoffAddress = dropoffAddress,
        _estimatedFare = estimatedFare,
        _scheduledTime = scheduledTime,
        _status = status,
        _createdAt = createdAt,
        _distance = distance,
        _estimatedDuration = estimatedDuration,
        _passengerName = passengerName,
        _passengerPhone = passengerPhone,
        _riderRating = riderRating,
        _vehicleType = vehicleType,
        _notes = notes,
        super(firestoreUtilData);

  // "rideId" field.
  String? _rideId;
  String get rideId => _rideId ?? '';
  set rideId(String? val) => _rideId = val;

  bool hasRideId() => _rideId != null;

  // "pickupLocation" field.
  LatLng? _pickupLocation;
  LatLng? get pickupLocation => _pickupLocation;
  set pickupLocation(LatLng? val) => _pickupLocation = val;

  bool hasPickupLocation() => _pickupLocation != null;

  // "dropoffLocation" field.
  LatLng? _dropoffLocation;
  LatLng? get dropoffLocation => _dropoffLocation;
  set dropoffLocation(LatLng? val) => _dropoffLocation = val;

  bool hasDropoffLocation() => _dropoffLocation != null;

  // "pickupAddress" field.
  String? _pickupAddress;
  String get pickupAddress => _pickupAddress ?? '';
  set pickupAddress(String? val) => _pickupAddress = val;

  bool hasPickupAddress() => _pickupAddress != null;

  // "dropoffAddress" field.
  String? _dropoffAddress;
  String get dropoffAddress => _dropoffAddress ?? '';
  set dropoffAddress(String? val) => _dropoffAddress = val;

  bool hasDropoffAddress() => _dropoffAddress != null;

  // "estimatedFare" field.
  double? _estimatedFare;
  double get estimatedFare => _estimatedFare ?? 0.0;
  set estimatedFare(double? val) => _estimatedFare = val;

  void incrementEstimatedFare(double amount) =>
      estimatedFare = estimatedFare + amount;

  bool hasEstimatedFare() => _estimatedFare != null;

  // "scheduledTime" field.
  DateTime? _scheduledTime;
  DateTime? get scheduledTime => _scheduledTime;
  set scheduledTime(DateTime? val) => _scheduledTime = val;

  bool hasScheduledTime() => _scheduledTime != null;

  // "status" field.
  String? _status;
  String get status => _status ?? 'available';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "distance" field.
  double? _distance;
  double get distance => _distance ?? 0.0;
  set distance(double? val) => _distance = val;

  void incrementDistance(double amount) => distance = distance + amount;

  bool hasDistance() => _distance != null;

  // "estimatedDuration" field.
  int? _estimatedDuration;
  int get estimatedDuration => _estimatedDuration ?? 0;
  set estimatedDuration(int? val) => _estimatedDuration = val;

  void incrementEstimatedDuration(int amount) =>
      estimatedDuration = estimatedDuration + amount;

  bool hasEstimatedDuration() => _estimatedDuration != null;

  // "passengerName" field.
  String? _passengerName;
  String get passengerName => _passengerName ?? '';
  set passengerName(String? val) => _passengerName = val;

  bool hasPassengerName() => _passengerName != null;

  // "passengerPhone" field.
  String? _passengerPhone;
  String get passengerPhone => _passengerPhone ?? '';
  set passengerPhone(String? val) => _passengerPhone = val;

  bool hasPassengerPhone() => _passengerPhone != null;

  // "riderRating" field.
  double? _riderRating;
  double get riderRating => _riderRating ?? 5.0;
  set riderRating(double? val) => _riderRating = val;

  void incrementRiderRating(double amount) =>
      riderRating = riderRating + amount;

  bool hasRiderRating() => _riderRating != null;

  // "vehicleType" field.
  String? _vehicleType;
  String get vehicleType => _vehicleType ?? '';
  set vehicleType(String? val) => _vehicleType = val;

  bool hasVehicleType() => _vehicleType != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  set notes(String? val) => _notes = val;

  bool hasNotes() => _notes != null;

  static RideModelStruct fromMap(Map<String, dynamic> data) => RideModelStruct(
        rideId: data['rideId'] as String?,
        pickupLocation: data['pickupLocation'] as LatLng?,
        dropoffLocation: data['dropoffLocation'] as LatLng?,
        pickupAddress: data['pickupAddress'] as String?,
        dropoffAddress: data['dropoffAddress'] as String?,
        estimatedFare: castToType<double>(data['estimatedFare']),
        scheduledTime: data['scheduledTime'] as DateTime?,
        status: data['status'] as String?,
        createdAt: data['createdAt'] as DateTime?,
        distance: castToType<double>(data['distance']),
        estimatedDuration: castToType<int>(data['estimatedDuration']),
        passengerName: data['passengerName'] as String?,
        passengerPhone: data['passengerPhone'] as String?,
        riderRating: castToType<double>(data['riderRating']),
        vehicleType: data['vehicleType'] as String?,
        notes: data['notes'] as String?,
      );

  static RideModelStruct? maybeFromMap(dynamic data) => data is Map
      ? RideModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'rideId': _rideId,
        'pickupLocation': _pickupLocation,
        'dropoffLocation': _dropoffLocation,
        'pickupAddress': _pickupAddress,
        'dropoffAddress': _dropoffAddress,
        'estimatedFare': _estimatedFare,
        'scheduledTime': _scheduledTime,
        'status': _status,
        'createdAt': _createdAt,
        'distance': _distance,
        'estimatedDuration': _estimatedDuration,
        'passengerName': _passengerName,
        'passengerPhone': _passengerPhone,
        'riderRating': _riderRating,
        'vehicleType': _vehicleType,
        'notes': _notes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'rideId': serializeParam(
          _rideId,
          ParamType.String,
        ),
        'pickupLocation': serializeParam(
          _pickupLocation,
          ParamType.LatLng,
        ),
        'dropoffLocation': serializeParam(
          _dropoffLocation,
          ParamType.LatLng,
        ),
        'pickupAddress': serializeParam(
          _pickupAddress,
          ParamType.String,
        ),
        'dropoffAddress': serializeParam(
          _dropoffAddress,
          ParamType.String,
        ),
        'estimatedFare': serializeParam(
          _estimatedFare,
          ParamType.double,
        ),
        'scheduledTime': serializeParam(
          _scheduledTime,
          ParamType.DateTime,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'distance': serializeParam(
          _distance,
          ParamType.double,
        ),
        'estimatedDuration': serializeParam(
          _estimatedDuration,
          ParamType.int,
        ),
        'passengerName': serializeParam(
          _passengerName,
          ParamType.String,
        ),
        'passengerPhone': serializeParam(
          _passengerPhone,
          ParamType.String,
        ),
        'riderRating': serializeParam(
          _riderRating,
          ParamType.double,
        ),
        'vehicleType': serializeParam(
          _vehicleType,
          ParamType.String,
        ),
        'notes': serializeParam(
          _notes,
          ParamType.String,
        ),
      }.withoutNulls;

  static RideModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      RideModelStruct(
        rideId: deserializeParam(
          data['rideId'],
          ParamType.String,
          false,
        ),
        pickupLocation: deserializeParam(
          data['pickupLocation'],
          ParamType.LatLng,
          false,
        ),
        dropoffLocation: deserializeParam(
          data['dropoffLocation'],
          ParamType.LatLng,
          false,
        ),
        pickupAddress: deserializeParam(
          data['pickupAddress'],
          ParamType.String,
          false,
        ),
        dropoffAddress: deserializeParam(
          data['dropoffAddress'],
          ParamType.String,
          false,
        ),
        estimatedFare: deserializeParam(
          data['estimatedFare'],
          ParamType.double,
          false,
        ),
        scheduledTime: deserializeParam(
          data['scheduledTime'],
          ParamType.DateTime,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        distance: deserializeParam(
          data['distance'],
          ParamType.double,
          false,
        ),
        estimatedDuration: deserializeParam(
          data['estimatedDuration'],
          ParamType.int,
          false,
        ),
        passengerName: deserializeParam(
          data['passengerName'],
          ParamType.String,
          false,
        ),
        passengerPhone: deserializeParam(
          data['passengerPhone'],
          ParamType.String,
          false,
        ),
        riderRating: deserializeParam(
          data['riderRating'],
          ParamType.double,
          false,
        ),
        vehicleType: deserializeParam(
          data['vehicleType'],
          ParamType.String,
          false,
        ),
        notes: deserializeParam(
          data['notes'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RideModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RideModelStruct &&
        rideId == other.rideId &&
        pickupLocation == other.pickupLocation &&
        dropoffLocation == other.dropoffLocation &&
        pickupAddress == other.pickupAddress &&
        dropoffAddress == other.dropoffAddress &&
        estimatedFare == other.estimatedFare &&
        scheduledTime == other.scheduledTime &&
        status == other.status &&
        createdAt == other.createdAt &&
        distance == other.distance &&
        estimatedDuration == other.estimatedDuration &&
        passengerName == other.passengerName &&
        passengerPhone == other.passengerPhone &&
        riderRating == other.riderRating &&
        vehicleType == other.vehicleType &&
        notes == other.notes;
  }

  @override
  int get hashCode => const ListEquality().hash([
        rideId,
        pickupLocation,
        dropoffLocation,
        pickupAddress,
        dropoffAddress,
        estimatedFare,
        scheduledTime,
        status,
        createdAt,
        distance,
        estimatedDuration,
        passengerName,
        passengerPhone,
        riderRating,
        vehicleType,
        notes
      ]);
}

RideModelStruct createRideModelStruct({
  String? rideId,
  LatLng? pickupLocation,
  LatLng? dropoffLocation,
  String? pickupAddress,
  String? dropoffAddress,
  double? estimatedFare,
  DateTime? scheduledTime,
  String? status,
  DateTime? createdAt,
  double? distance,
  int? estimatedDuration,
  String? passengerName,
  String? passengerPhone,
  double? riderRating,
  String? vehicleType,
  String? notes,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RideModelStruct(
      rideId: rideId,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      estimatedFare: estimatedFare,
      scheduledTime: scheduledTime,
      status: status,
      createdAt: createdAt,
      distance: distance,
      estimatedDuration: estimatedDuration,
      passengerName: passengerName,
      passengerPhone: passengerPhone,
      riderRating: riderRating,
      vehicleType: vehicleType,
      notes: notes,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RideModelStruct? updateRideModelStruct(
  RideModelStruct? rideModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    rideModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRideModelStructData(
  Map<String, dynamic> firestoreData,
  RideModelStruct? rideModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (rideModel == null) {
    return;
  }
  if (rideModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && rideModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final rideModelData = getRideModelFirestoreData(rideModel, forFieldValue);
  final nestedData = rideModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = rideModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRideModelFirestoreData(
  RideModelStruct? rideModel, [
  bool forFieldValue = false,
]) {
  if (rideModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(rideModel.toMap());

  // Add any Firestore field values
  mapToFirestore(rideModel.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRideModelListFirestoreData(
  List<RideModelStruct>? rideModels,
) =>
    rideModels?.map((e) => getRideModelFirestoreData(e, true)).toList() ?? [];
