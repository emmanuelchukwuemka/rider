// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/mock_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DriverStruct extends FFSupabaseStruct {
  DriverStruct({
    String? name,
    String? email,
    String? phone,
    double? rating,
    String? carPlate,
    String? carModel,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _email = email,
        _phone = phone,
        _rating = rating,
        _carPlate = carPlate,
        _carModel = carModel,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  set rating(double? val) => _rating = val;

  void incrementRating(double amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "carPlate" field.
  String? _carPlate;
  String get carPlate => _carPlate ?? '';
  set carPlate(String? val) => _carPlate = val;

  bool hasCarPlate() => _carPlate != null;

  // "carModel" field.
  String? _carModel;
  String get carModel => _carModel ?? '';
  set carModel(String? val) => _carModel = val;

  bool hasCarModel() => _carModel != null;

  static DriverStruct fromMap(Map<String, dynamic> data) => DriverStruct(
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        rating: castToType<double>(data['rating']),
        carPlate: data['carPlate'] as String?,
        carModel: data['carModel'] as String?,
      );

  static DriverStruct? maybeFromMap(dynamic data) =>
      data is Map ? DriverStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'email': _email,
        'phone': _phone,
        'rating': _rating,
        'carPlate': _carPlate,
        'carModel': _carModel,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.double,
        ),
        'carPlate': serializeParam(
          _carPlate,
          ParamType.String,
        ),
        'carModel': serializeParam(
          _carModel,
          ParamType.String,
        ),
      }.withoutNulls;

  static DriverStruct fromSerializableMap(Map<String, dynamic> data) =>
      DriverStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.double,
          false,
        ),
        carPlate: deserializeParam(
          data['carPlate'],
          ParamType.String,
          false,
        ),
        carModel: deserializeParam(
          data['carModel'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DriverStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DriverStruct &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        rating == other.rating &&
        carPlate == other.carPlate &&
        carModel == other.carModel;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([name, email, phone, rating, carPlate, carModel]);
}

DriverStruct createDriverStruct({
  String? name,
  String? email,
  String? phone,
  double? rating,
  String? carPlate,
  String? carModel,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DriverStruct(
      name: name,
      email: email,
      phone: phone,
      rating: rating,
      carPlate: carPlate,
      carModel: carModel,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DriverStruct? updateDriverStruct(
  DriverStruct? driver, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    driver
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDriverStructData(
  Map<String, dynamic> firestoreData,
  DriverStruct? driver,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (driver == null) {
    return;
  }
  if (driver.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && driver.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final driverData = getDriverFirestoreData(driver, forFieldValue);
  final nestedData = driverData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = driver.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDriverFirestoreData(
  DriverStruct? driver, [
  bool forFieldValue = false,
]) {
  if (driver == null) {
    return {};
  }
  final firestoreData = mapToFirestore(driver.toMap());

  // Add any Firestore field values
  mapToFirestore(driver.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDriverListFirestoreData(
  List<DriverStruct>? drivers,
) =>
    drivers?.map((e) => getDriverFirestoreData(e, true)).toList() ?? [];
