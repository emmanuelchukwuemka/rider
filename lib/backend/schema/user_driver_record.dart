import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserDriverRecord extends FirestoreRecord {
  UserDriverRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "role" field.
  Role? _role;
  Role? get role => _role;
  bool hasRole() => _role != null;

  // "is_online" field.
  OnlineStatus? _isOnline;
  OnlineStatus? get isOnline => _isOnline;
  bool hasIsOnline() => _isOnline != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  // "total_trips" field.
  int? _totalTrips;
  int get totalTrips => _totalTrips ?? 0;
  bool hasTotalTrips() => _totalTrips != null;

  // "driver_rating" field.
  double? _driverRating;
  double get driverRating => _driverRating ?? 0.0;
  bool hasDriverRating() => _driverRating != null;

  // "wallet_balance" field.
  double? _walletBalance;
  double get walletBalance => _walletBalance ?? 0.0;
  bool hasWalletBalance() => _walletBalance != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _role = snapshotData['role'] is Role
        ? snapshotData['role']
        : deserializeEnum<Role>(snapshotData['role']);
    _isOnline = snapshotData['is_online'] is OnlineStatus
        ? snapshotData['is_online']
        : deserializeEnum<OnlineStatus>(snapshotData['is_online']);
    _isActive = snapshotData['is_active'] as bool?;
    _totalTrips = castToType<int>(snapshotData['total_trips']);
    _driverRating = castToType<double>(snapshotData['driver_rating']);
    _walletBalance = castToType<double>(snapshotData['wallet_balance']);
    _location = snapshotData['location'] as LatLng?;
  }

  static CollectionReference get collection =>
      SupabaseFirestore.instance.collection('drivers');

  static Stream<UserDriverRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserDriverRecord.fromSnapshot(s));

  static Future<UserDriverRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserDriverRecord.fromSnapshot(s));

  static UserDriverRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserDriverRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserDriverRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserDriverRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserDriverRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserDriverRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserDriverRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  Role? role,
  OnlineStatus? isOnline,
  bool? isActive,
  int? totalTrips,
  double? driverRating,
  double? walletBalance,
  LatLng? location,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'role': role,
      'is_online': isOnline,
      'is_active': isActive,
      'total_trips': totalTrips,
      'driver_rating': driverRating,
      'wallet_balance': walletBalance,
      'location': location,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserDriverRecordDocumentEquality implements Equality<UserDriverRecord> {
  const UserDriverRecordDocumentEquality();

  @override
  bool equals(UserDriverRecord? e1, UserDriverRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.role == e2?.role &&
        e1?.isOnline == e2?.isOnline &&
        e1?.isActive == e2?.isActive &&
        e1?.totalTrips == e2?.totalTrips &&
        e1?.driverRating == e2?.driverRating &&
        e1?.walletBalance == e2?.walletBalance &&
        e1?.location == e2?.location;
  }

  @override
  int hash(UserDriverRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.role,
        e?.isOnline,
        e?.isActive,
        e?.totalTrips,
        e?.driverRating,
        e?.walletBalance,
        e?.location
      ]);

  @override
  bool isValidKey(Object? o) => o is UserDriverRecord;
}
