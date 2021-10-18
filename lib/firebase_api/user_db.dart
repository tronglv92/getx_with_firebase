import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/models/response/users_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'firestore_path.dart';
import 'firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/*
This is the main class access/call for any UI widgets that require to perform
any CRUD activities operation in FirebaseFirestore database.
This class work hand-in-hand with FirestoreService and FirestorePath.
Notes:
For cases where you need to have a special method such as bulk update specifically
on a field, then is ok to use custom code and write it here. For example,
setAllTodoComplete is require to change all todos item to have the complete status
changed to true.
 */
class UserDatabase {
  UserDatabase();

  final FireStoreService _fireStoreService = FireStoreService.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  //Method to create/update user
  Future<void> setUser(
          {required UserResponse user, required String uid}) async =>
      await _fireStoreService.set(
        path: FireStorePath.user(uid),
        data: user.toJson(),
      );

  Future<void> updatePhoto({required String photo, required String uid}) async {
    return _firebaseFirestore
        .doc(FireStorePath.user(uid))
        .update(<String, dynamic>{'photoUrl': photo});
  }

  Stream<UserResponse?> userStream(String uid) {
    return _fireStoreService.documentStream(
      path: FireStorePath.user(uid),
      builder: (Map<String, dynamic>? data, String documentId) {
        logger.e('user stream ', data);
        if (data == null) {
          return null;
        }
        return UserResponse.fromJson(data, documentId);
      },
    );
  }

  Future<void> sayHello() async {
    HttpsCallable callable = _functions.httpsCallable('sayHello');
    final results = await callable(<dynamic, String>{'name': 'test'});
    String data =
        results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
    logger.d("say hello ", data);
  }

  // Future<List<UserResponse>> getAllUsers(
  //     {required int limit, required int page}) async {
  //   List<UserResponse> users = [];
  //   if (page == 0) {
  //     var querySnapshots = await _firebaseFirestore
  //         .collection(FireStorePath.users())
  //         .limit(limit)
  //         .get();
  //     users = querySnapshots.docs
  //         .map((e) => UserResponse.fromJson(e.data()))
  //         .toList();
  //   }
  //   return users;
  // }
  Future<List<UserResponse>> getAllUsers() async {
    return _fireStoreService.collectionFuture(
      path: FireStorePath.users(),

      builder: (data, documentId) {
        return UserResponse.fromJson(data, documentId);
      },
      queryBuilder: (Query query) {
        return query.limit(2);
      },
      // sort: (UserResponse a,UserResponse b){
      //     return 0;
      // }
    );
  }





}
