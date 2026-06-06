class Timestamp {
  final DateTime date;
  Timestamp(this.date);
  DateTime toDate() => date;
}

class GeoPoint {
  final double latitude;
  final double longitude;
  GeoPoint(this.latitude, this.longitude);
}

class DocumentReference {
  final String path;
  DocumentReference(this.path);
  
  String get id => path.split('/').last;
  DocumentReference get parent => DocumentReference('');

  Map<String, dynamic> get _mockData => {};

  Stream<DocumentSnapshot> snapshots() => Stream.value(DocumentSnapshot(this, _mockData));
  
  Future<DocumentSnapshot> get() async {
    // Dynamically fetch from local API if path represents a collection/id
    try {
      if (path.isNotEmpty && path.contains('/')) {
        final segments = path.split('/');
        final collectionName = segments[0];
        final docId = segments[1];
        if (docId != 'unknown' && docId != 'mock_id') {
          // Import http dynamically or use standard api_service
          // But to avoid cyclical dependencies, return empty for now,
          // as FlutterFlow lists use fetchCollection
        }
      }
    } catch (e) {
      print('Mock Firestore get() error: $e');
    }
    return DocumentSnapshot(this, _mockData);
  }

  Future<void> update(Map<String, dynamic> data) async {}
  Future<void> set(Map<String, dynamic> data) async {}
  Future<void> delete() async {}
}

class FieldValue {
  static FieldValue delete() => FieldValue();
  static FieldValue serverTimestamp() => FieldValue();
  static FieldValue increment(int n) => FieldValue();
}

class DocumentSnapshot {
  final DocumentReference reference;
  final Map<String, dynamic> _data;
  DocumentSnapshot(this.reference, this._data);
  
  Map<String, dynamic>? data() => _data;
  bool get exists => true;
}

class Query {
  List<DocumentSnapshot> get _mockDocs {
    return [];
  }

  Stream<QuerySnapshot> snapshots() => Stream.value(QuerySnapshot(_mockDocs));
  Future<QuerySnapshot> get() async => QuerySnapshot(_mockDocs);
  Query where(dynamic field, {dynamic isEqualTo, dynamic isNotEqualTo, dynamic isLessThan, dynamic isLessThanOrEqualTo, dynamic isGreaterThan, dynamic isGreaterThanOrEqualTo, dynamic arrayContains, List<dynamic>? arrayContainsAny, List<dynamic>? whereIn, List<dynamic>? whereNotIn, bool? isNull}) => this;
  Query orderBy(dynamic field, {bool descending = false}) => this;
  Query limit(int length) => this;
}

class CollectionReference extends Query {
  final String path;
  CollectionReference(this.path);
  DocumentReference doc([String? path]) => DocumentReference(this.path + "/" + (path ?? "mock_id"));
  Future<DocumentReference> add(Map<String, dynamic> data) async => doc();
}

class QuerySnapshot {
  final List<DocumentSnapshot> docs;
  QuerySnapshot(this.docs);
}

class SupabaseFirestore {
  static final SupabaseFirestore instance = SupabaseFirestore();
  CollectionReference collection(String path) => CollectionReference(path);
  DocumentReference doc(String path) => DocumentReference(path);
}
