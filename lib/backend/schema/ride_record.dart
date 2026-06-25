import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideRecord extends FirestoreRecord {
  RideRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "passenger_ref" field.
  DocumentReference? _passengerRef;
  DocumentReference? get passengerRef => _passengerRef;
  bool hasPassengerRef() => _passengerRef != null;

  // "status" field.
  RideStatus? _status;
  RideStatus? get status => _status;
  bool hasStatus() => _status != null;

  // "final_fare" field.
  double? _finalFare;
  double get finalFare => _finalFare ?? 0.0;
  bool hasFinalFare() => _finalFare != null;

  // "payment_method" field.
  PaymentMethod? _paymentMethod;
  PaymentMethod? get paymentMethod => _paymentMethod;
  bool hasPaymentMethod() => _paymentMethod != null;

  // "requested_at" field.
  DateTime? _requestedAt;
  DateTime? get requestedAt => _requestedAt;
  bool hasRequestedAt() => _requestedAt != null;

  // "accepted_at" field.
  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _acceptedAt;
  bool hasAcceptedAt() => _acceptedAt != null;

  // "started_at" field.
  DateTime? _startedAt;
  DateTime? get startedAt => _startedAt;
  bool hasStartedAt() => _startedAt != null;

  // "completed_at" field.
  DateTime? _completedAt;
  DateTime? get completedAt => _completedAt;
  bool hasCompletedAt() => _completedAt != null;

  // "cancelled_at" field.
  DateTime? _cancelledAt;
  DateTime? get cancelledAt => _cancelledAt;
  bool hasCancelledAt() => _cancelledAt != null;

  // "ride_type" field.
  Ridetype? _rideType;
  Ridetype? get rideType => _rideType;
  bool hasRideType() => _rideType != null;

  // "time" field.
  String? _time;
  String get time => _time ?? '';
  bool hasTime() => _time != null;

  // "users" field.
  DocumentReference? _users;
  DocumentReference? get users => _users;
  bool hasUsers() => _users != null;

  // "pickup" field.
  LatLng? _pickup;
  LatLng? get pickup => _pickup;
  bool hasPickup() => _pickup != null;

  // "dropoff" field.
  LatLng? _dropoff;
  LatLng? get dropoff => _dropoff;
  bool hasDropoff() => _dropoff != null;

  // "distanceKm" field.
  double? _distanceKm;
  double get distanceKm => _distanceKm ?? 0.0;
  bool hasDistanceKm() => _distanceKm != null;

  // "pickup_address" field.
  String? _pickupAddress;
  String get pickupAddress => _pickupAddress ?? '';
  bool hasPickupAddress() => _pickupAddress != null;

  // "dropoff_address" field.
  String? _dropoffAddress;
  String get dropoffAddress => _dropoffAddress ?? '';
  bool hasDropoffAddress() => _dropoffAddress != null;

  void _initializeFields() {
    _passengerRef = snapshotData['passenger_ref'] as DocumentReference?;
    _status = snapshotData['status'] is RideStatus
        ? snapshotData['status']
        : deserializeEnum<RideStatus>(snapshotData['status']);
    _finalFare = castToType<double>(snapshotData['final_fare']);
    _paymentMethod = snapshotData['payment_method'] is PaymentMethod
        ? snapshotData['payment_method']
        : deserializeEnum<PaymentMethod>(snapshotData['payment_method']);
    _requestedAt = snapshotData['requested_at'] as DateTime?;
    _acceptedAt = snapshotData['accepted_at'] as DateTime?;
    _startedAt = snapshotData['started_at'] as DateTime?;
    _completedAt = snapshotData['completed_at'] as DateTime?;
    _cancelledAt = snapshotData['cancelled_at'] as DateTime?;
    _rideType = snapshotData['ride_type'] is Ridetype
        ? snapshotData['ride_type']
        : deserializeEnum<Ridetype>(snapshotData['ride_type']);
    _time = snapshotData['time'] as String?;
    _users = snapshotData['users'] as DocumentReference?;
    _pickup = snapshotData['pickup'] as LatLng?;
    _dropoff = snapshotData['dropoff'] as LatLng?;
    _distanceKm = castToType<double>(snapshotData['distanceKm']);
    _pickupAddress = (snapshotData['pickup_address'] ?? snapshotData['pickupAddress']) as String?;
    _dropoffAddress = (snapshotData['dropoff_address'] ?? snapshotData['dropoffAddress']) as String?;
  }

  static CollectionReference get collection =>
      SupabaseFirestore.instance.collection('ride');

  static Stream<RideRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RideRecord.fromSnapshot(s));

  static Future<RideRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RideRecord.fromSnapshot(s));

  static RideRecord fromSnapshot(DocumentSnapshot snapshot) => RideRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RideRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RideRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RideRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RideRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRideRecordData({
  DocumentReference? passengerRef,
  RideStatus? status,
  double? finalFare,
  PaymentMethod? paymentMethod,
  DateTime? requestedAt,
  DateTime? acceptedAt,
  DateTime? startedAt,
  DateTime? completedAt,
  DateTime? cancelledAt,
  Ridetype? rideType,
  String? time,
  DocumentReference? users,
  LatLng? pickup,
  LatLng? dropoff,
  double? distanceKm,
  String? pickupAddress,
  String? dropoffAddress,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'passenger_ref': passengerRef,
      'status': status,
      'final_fare': finalFare,
      'payment_method': paymentMethod,
      'requested_at': requestedAt,
      'accepted_at': acceptedAt,
      'started_at': startedAt,
      'completed_at': completedAt,
      'cancelled_at': cancelledAt,
      'ride_type': rideType,
      'time': time,
      'users': users,
      'pickup': pickup,
      'dropoff': dropoff,
      'distanceKm': distanceKm,
      'pickup_address': pickupAddress,
      'dropoff_address': dropoffAddress,
    }.withoutNulls,
  );

  return firestoreData;
}

class RideRecordDocumentEquality implements Equality<RideRecord> {
  const RideRecordDocumentEquality();

  @override
  bool equals(RideRecord? e1, RideRecord? e2) {
    return e1?.passengerRef == e2?.passengerRef &&
        e1?.status == e2?.status &&
        e1?.finalFare == e2?.finalFare &&
        e1?.paymentMethod == e2?.paymentMethod &&
        e1?.requestedAt == e2?.requestedAt &&
        e1?.acceptedAt == e2?.acceptedAt &&
        e1?.startedAt == e2?.startedAt &&
        e1?.completedAt == e2?.completedAt &&
        e1?.cancelledAt == e2?.cancelledAt &&
        e1?.rideType == e2?.rideType &&
        e1?.time == e2?.time &&
        e1?.users == e2?.users &&
        e1?.pickup == e2?.pickup &&
        e1?.dropoff == e2?.dropoff &&
        e1?.distanceKm == e2?.distanceKm;
  }

  @override
  int hash(RideRecord? e) => const ListEquality().hash([
        e?.passengerRef,
        e?.status,
        e?.finalFare,
        e?.paymentMethod,
        e?.requestedAt,
        e?.acceptedAt,
        e?.startedAt,
        e?.completedAt,
        e?.cancelledAt,
        e?.rideType,
        e?.time,
        e?.users,
        e?.pickup,
        e?.dropoff,
        e?.distanceKm
      ]);

  @override
  bool isValidKey(Object? o) => o is RideRecord;
}
