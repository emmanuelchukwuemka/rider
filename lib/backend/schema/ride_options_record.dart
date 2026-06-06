import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideOptionsRecord extends FirestoreRecord {
  RideOptionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "price" field.
  String? _price;
  String get price => _price ?? '';
  bool hasPrice() => _price != null;

  // "features" field.
  String? _features;
  String get features => _features ?? '';
  bool hasFeatures() => _features != null;

  // "numbersofseats" field.
  String? _numbersofseats;
  String get numbersofseats => _numbersofseats ?? '';
  bool hasNumbersofseats() => _numbersofseats != null;

  // "rideTo" field.
  DocumentReference? _rideTo;
  DocumentReference? get rideTo => _rideTo;
  bool hasRideTo() => _rideTo != null;

  // "rideFrom" field.
  DocumentReference? _rideFrom;
  DocumentReference? get rideFrom => _rideFrom;
  bool hasRideFrom() => _rideFrom != null;

  void _initializeFields() {
    _type = snapshotData['Type'] as String?;
    _price = snapshotData['price'] as String?;
    _features = snapshotData['features'] as String?;
    _numbersofseats = snapshotData['numbersofseats'] as String?;
    _rideTo = snapshotData['rideTo'] as DocumentReference?;
    _rideFrom = snapshotData['rideFrom'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      SupabaseFirestore.instance.collection('RideOptions');

  static Stream<RideOptionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RideOptionsRecord.fromSnapshot(s));

  static Future<RideOptionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RideOptionsRecord.fromSnapshot(s));

  static RideOptionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RideOptionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RideOptionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RideOptionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RideOptionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RideOptionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRideOptionsRecordData({
  String? type,
  String? price,
  String? features,
  String? numbersofseats,
  DocumentReference? rideTo,
  DocumentReference? rideFrom,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Type': type,
      'price': price,
      'features': features,
      'numbersofseats': numbersofseats,
      'rideTo': rideTo,
      'rideFrom': rideFrom,
    }.withoutNulls,
  );

  return firestoreData;
}

class RideOptionsRecordDocumentEquality implements Equality<RideOptionsRecord> {
  const RideOptionsRecordDocumentEquality();

  @override
  bool equals(RideOptionsRecord? e1, RideOptionsRecord? e2) {
    return e1?.type == e2?.type &&
        e1?.price == e2?.price &&
        e1?.features == e2?.features &&
        e1?.numbersofseats == e2?.numbersofseats &&
        e1?.rideTo == e2?.rideTo &&
        e1?.rideFrom == e2?.rideFrom;
  }

  @override
  int hash(RideOptionsRecord? e) => const ListEquality().hash([
        e?.type,
        e?.price,
        e?.features,
        e?.numbersofseats,
        e?.rideTo,
        e?.rideFrom
      ]);

  @override
  bool isValidKey(Object? o) => o is RideOptionsRecord;
}
