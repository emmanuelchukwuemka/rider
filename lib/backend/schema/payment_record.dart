import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentRecord extends FirestoreRecord {
  PaymentRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "paymentMethod" field.
  PaymentMethod? _paymentMethod;
  PaymentMethod? get paymentMethod => _paymentMethod;
  bool hasPaymentMethod() => _paymentMethod != null;

  // "paymentStatus" field.
  PaymentStatus? _paymentStatus;
  PaymentStatus? get paymentStatus => _paymentStatus;
  bool hasPaymentStatus() => _paymentStatus != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "provider" field.
  String? _provider;
  String get provider => _provider ?? '';
  bool hasProvider() => _provider != null;

  // "masked_number" field.
  String? _maskedNumber;
  String get maskedNumber => _maskedNumber ?? '';
  bool hasMaskedNumber() => _maskedNumber != null;

  // "is_default" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  bool hasIsDefault() => _isDefault != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _paymentMethod = snapshotData['paymentMethod'] is PaymentMethod
        ? snapshotData['paymentMethod']
        : deserializeEnum<PaymentMethod>(snapshotData['paymentMethod']);
    _paymentStatus = snapshotData['paymentStatus'] is PaymentStatus
        ? snapshotData['paymentStatus']
        : deserializeEnum<PaymentStatus>(snapshotData['paymentStatus']);
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _provider = snapshotData['provider'] as String?;
    _maskedNumber = snapshotData['masked_number'] as String?;
    _isDefault = snapshotData['is_default'] as bool?;
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      SupabaseFirestore.instance.collection('payment');

  static Stream<PaymentRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PaymentRecord.fromSnapshot(s));

  static Future<PaymentRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PaymentRecord.fromSnapshot(s));

  static PaymentRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PaymentRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PaymentRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PaymentRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PaymentRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PaymentRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPaymentRecordData({
  PaymentMethod? paymentMethod,
  PaymentStatus? paymentStatus,
  DocumentReference? userRef,
  String? provider,
  String? maskedNumber,
  bool? isDefault,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'user_ref': userRef,
      'provider': provider,
      'masked_number': maskedNumber,
      'is_default': isDefault,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class PaymentRecordDocumentEquality implements Equality<PaymentRecord> {
  const PaymentRecordDocumentEquality();

  @override
  bool equals(PaymentRecord? e1, PaymentRecord? e2) {
    return e1?.paymentMethod == e2?.paymentMethod &&
        e1?.paymentStatus == e2?.paymentStatus &&
        e1?.userRef == e2?.userRef &&
        e1?.provider == e2?.provider &&
        e1?.maskedNumber == e2?.maskedNumber &&
        e1?.isDefault == e2?.isDefault &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(PaymentRecord? e) => const ListEquality().hash([
        e?.paymentMethod,
        e?.paymentStatus,
        e?.userRef,
        e?.provider,
        e?.maskedNumber,
        e?.isDefault,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is PaymentRecord;
}
