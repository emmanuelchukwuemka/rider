import 'schema/util/firestore_util.dart';
import 'package:flutter/material.dart';
import 'schema/users_record.dart';
import 'schema/user_driver_record.dart';
import 'schema/ride_record.dart';
import 'schema/ride_options_record.dart';
import 'schema/payment_record.dart';
import 'schema/payment_details_record.dart';
import 'schema/city_record.dart';
import 'schema/util/mock_firestore.dart';

export 'schema/users_record.dart';
export 'schema/user_driver_record.dart';
export 'schema/ride_record.dart';
export 'schema/ride_options_record.dart';
export 'schema/payment_record.dart';
export 'schema/payment_details_record.dart';
export 'schema/city_record.dart';
export 'schema/util/mock_firestore.dart';

import 'api_service.dart';

Stream<List<UsersRecord>> queryUsersRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('users');
  yield dataList.map((data) {
    return UsersRecord.getDocumentFromData(data, DocumentReference('users/${data['id'] ?? data['uid'] ?? 'unknown'}'));
  }).toList();
}

Stream<List<UserDriverRecord>> queryUserDriverRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('drivers');
  yield dataList.map((data) {
    return UserDriverRecord.getDocumentFromData(data, DocumentReference('drivers/${data['id'] ?? data['uid'] ?? 'unknown'}'));
  }).toList();
}

Stream<List<RideRecord>> queryRideRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('rides');
  yield dataList.map((data) {
    return RideRecord.getDocumentFromData(data, DocumentReference('rides/${data['id'] ?? 'unknown'}'));
  }).toList();
}

Stream<List<RideOptionsRecord>> queryRideOptionsRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('rideOptions');
  yield dataList.map((data) {
    return RideOptionsRecord.getDocumentFromData(data, DocumentReference('rideOptions/${data['id'] ?? 'unknown'}'));
  }).toList();
}

Stream<List<PaymentRecord>> queryPaymentRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('payments');
  yield dataList.map((data) {
    return PaymentRecord.getDocumentFromData(data, DocumentReference('payments/${data['id'] ?? 'unknown'}'));
  }).toList();
}

Stream<List<PaymentDetailsRecord>> queryPaymentDetailsRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('paymentDetails');
  yield dataList.map((data) {
    return PaymentDetailsRecord.getDocumentFromData(data, DocumentReference('paymentDetails/${data['id'] ?? 'unknown'}'));
  }).toList();
}

Stream<List<CityRecord>> queryCityRecord({Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) async* {
  final dataList = await fetchCollection('cities');
  yield dataList.map((data) {
    return CityRecord.getDocumentFromData(data, DocumentReference('cities/${data['id'] ?? 'unknown'}'));
  }).toList();
}

Future<int> queryUsersRecordCount({Query Function(Query)? queryBuilder}) async => 0;
Future<int> queryRideRecordCount({Query Function(Query)? queryBuilder}) async => 0;
Future<int> queryUserDriverRecordCount({Query Function(Query)? queryBuilder}) async => 0;

Stream<List<T>> queryCollection<T>(Query collection, RecordBuilder<T> recordBuilder, {Query Function(Query)? queryBuilder, int limit = -1, bool singleRecord = false}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().map((s) => s.docs.map((d) => recordBuilder(d)).toList());
}

Future<int> queryCollectionCount(Query collection, {Query Function(Query)? queryBuilder}) async => 0;

Stream<List<T>> queryCollectionPage<T>(Query collection, RecordBuilder<T> recordBuilder, {Query Function(Query)? queryBuilder, dynamic nextPageMarker, int pageSize = 10, required bool isStream}) {
  return queryCollection(collection, recordBuilder, queryBuilder: queryBuilder, limit: pageSize);
}


