import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentDetailsRecord extends FirestoreRecord {
  PaymentDetailsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "cardLast4" field.
  String? _cardLast4;
  String get cardLast4 => _cardLast4 ?? '';
  bool hasCardLast4() => _cardLast4 != null;

  // "cardBrand" field.
  String? _cardBrand;
  String get cardBrand => _cardBrand ?? '';
  bool hasCardBrand() => _cardBrand != null;

  // "walletUsed" field.
  String? _walletUsed;
  String get walletUsed => _walletUsed ?? '';
  bool hasWalletUsed() => _walletUsed != null;

  // "cashAmount" field.
  int? _cashAmount;
  int get cashAmount => _cashAmount ?? 0;
  bool hasCashAmount() => _cashAmount != null;

  // "transactionId" field.
  int? _transactionId;
  int get transactionId => _transactionId ?? 0;
  bool hasTransactionId() => _transactionId != null;

  // "receiptUrl" field.
  String? _receiptUrl;
  String get receiptUrl => _receiptUrl ?? '';
  bool hasReceiptUrl() => _receiptUrl != null;

  // "paymentGateway" field.
  String? _paymentGateway;
  String get paymentGateway => _paymentGateway ?? '';
  bool hasPaymentGateway() => _paymentGateway != null;

  // "paymentTimestamp" field.
  DateTime? _paymentTimestamp;
  DateTime? get paymentTimestamp => _paymentTimestamp;
  bool hasPaymentTimestamp() => _paymentTimestamp != null;

  void _initializeFields() {
    _cardLast4 = snapshotData['cardLast4'] as String?;
    _cardBrand = snapshotData['cardBrand'] as String?;
    _walletUsed = snapshotData['walletUsed'] as String?;
    _cashAmount = castToType<int>(snapshotData['cashAmount']);
    _transactionId = castToType<int>(snapshotData['transactionId']);
    _receiptUrl = snapshotData['receiptUrl'] as String?;
    _paymentGateway = snapshotData['paymentGateway'] as String?;
    _paymentTimestamp = snapshotData['paymentTimestamp'] as DateTime?;
  }

  static CollectionReference get collection =>
      SupabaseFirestore.instance.collection('paymentDetails');

  static Stream<PaymentDetailsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PaymentDetailsRecord.fromSnapshot(s));

  static Future<PaymentDetailsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PaymentDetailsRecord.fromSnapshot(s));

  static PaymentDetailsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PaymentDetailsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PaymentDetailsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PaymentDetailsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PaymentDetailsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PaymentDetailsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPaymentDetailsRecordData({
  String? cardLast4,
  String? cardBrand,
  String? walletUsed,
  int? cashAmount,
  int? transactionId,
  String? receiptUrl,
  String? paymentGateway,
  DateTime? paymentTimestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'cardLast4': cardLast4,
      'cardBrand': cardBrand,
      'walletUsed': walletUsed,
      'cashAmount': cashAmount,
      'transactionId': transactionId,
      'receiptUrl': receiptUrl,
      'paymentGateway': paymentGateway,
      'paymentTimestamp': paymentTimestamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class PaymentDetailsRecordDocumentEquality
    implements Equality<PaymentDetailsRecord> {
  const PaymentDetailsRecordDocumentEquality();

  @override
  bool equals(PaymentDetailsRecord? e1, PaymentDetailsRecord? e2) {
    return e1?.cardLast4 == e2?.cardLast4 &&
        e1?.cardBrand == e2?.cardBrand &&
        e1?.walletUsed == e2?.walletUsed &&
        e1?.cashAmount == e2?.cashAmount &&
        e1?.transactionId == e2?.transactionId &&
        e1?.receiptUrl == e2?.receiptUrl &&
        e1?.paymentGateway == e2?.paymentGateway &&
        e1?.paymentTimestamp == e2?.paymentTimestamp;
  }

  @override
  int hash(PaymentDetailsRecord? e) => const ListEquality().hash([
        e?.cardLast4,
        e?.cardBrand,
        e?.walletUsed,
        e?.cashAmount,
        e?.transactionId,
        e?.receiptUrl,
        e?.paymentGateway,
        e?.paymentTimestamp
      ]);

  @override
  bool isValidKey(Object? o) => o is PaymentDetailsRecord;
}
