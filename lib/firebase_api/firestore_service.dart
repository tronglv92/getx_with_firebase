import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

/*
This class represent all possible CRUD operation for FirebaseFirestore.
It contains all generic implementation needed based on the provided document
path and documentID,since most of the time in FirebaseFirestore design, we will have
documentID and path for any document and collections.
 */
class FireStoreService {
  FireStoreService._();

  static final FireStoreService instance = FireStoreService._();

  Future<void> set({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    logger.d('$path: $data');
    await reference.set(data);
  }

  Future<void> bulkSet({
    required String path,
    required List<Map<String, dynamic>> datas,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final batchSet = FirebaseFirestore.instance.batch();

//    for()
//    batchSet.

    logger.d('$path: $datas');
  }

  Future<void> deleteData({required String path}) async {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    logger.d('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    // ignore: always_specify_types
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    // ignore: always_specify_types
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    // ignore: always_specify_types
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((QuerySnapshot<Object?> snapshot) {
      final List<T> result = snapshot.docs
          .map((QueryDocumentSnapshot<Object?> snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          // ignore: always_specify_types
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<List<T>> collectionFuture<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    // ignore: always_specify_types
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    // ignore: always_specify_types
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    // ignore: always_specify_types
    final QuerySnapshot snapshots = await query.get();
    final List<T> result = snapshots.docs
        .map((snapshot) {
          return builder(snapshot.data() as Map<String, dynamic>, snapshot.id);
        })
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> collectionDocument<T>({
    required String path,
    Query Function(Query query)? queryBuilder,

  }) async {
    // ignore: always_specify_types
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    // ignore: always_specify_types
    final QuerySnapshot snapshots = await query.get();

    return snapshots.docs;
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);

    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return builder(snapshot.data(), snapshot.id);
    });
  }
}
