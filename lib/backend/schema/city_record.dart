import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CityRecord extends FirestoreRecord {
  CityRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Latlng" field.
  LatLng? _latlng;
  LatLng? get latlng => _latlng;
  bool hasLatlng() => _latlng != null;

  // "pin_image" field.
  String? _pinImage;
  String get pinImage => _pinImage ?? '';
  bool hasPinImage() => _pinImage != null;

  // "location_name" field.
  String? _locationName;
  String get locationName => _locationName ?? '';
  bool hasLocationName() => _locationName != null;

  void _initializeFields() {
    _latlng = snapshotData['Latlng'] as LatLng?;
    _pinImage = snapshotData['pin_image'] as String?;
    _locationName = snapshotData['location_name'] as String?;
  }

  static CollectionReference get collection =>
      SupabaseFirestore.instance.collection('City');

  static Stream<CityRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CityRecord.fromSnapshot(s));

  static Future<CityRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CityRecord.fromSnapshot(s));

  static CityRecord fromSnapshot(DocumentSnapshot snapshot) => CityRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CityRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CityRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CityRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CityRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCityRecordData({
  LatLng? latlng,
  String? pinImage,
  String? locationName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Latlng': latlng,
      'pin_image': pinImage,
      'location_name': locationName,
    }.withoutNulls,
  );

  return firestoreData;
}

class CityRecordDocumentEquality implements Equality<CityRecord> {
  const CityRecordDocumentEquality();

  @override
  bool equals(CityRecord? e1, CityRecord? e2) {
    return e1?.latlng == e2?.latlng &&
        e1?.pinImage == e2?.pinImage &&
        e1?.locationName == e2?.locationName;
  }

  @override
  int hash(CityRecord? e) =>
      const ListEquality().hash([e?.latlng, e?.pinImage, e?.locationName]);

  @override
  bool isValidKey(Object? o) => o is CityRecord;
}
