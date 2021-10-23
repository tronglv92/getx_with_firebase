import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_getx_boilerplate/models/response/fcm_token_response.dart';
import 'package:flutter_getx_boilerplate/models/response/notification_response.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/models/response/users_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'firestore_path.dart';
import 'firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class NotificationDatabase {
  NotificationDatabase();

  final FireStoreService _fireStoreService = FireStoreService.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;


  Stream<List<NotificationResponse>> getAllNotificationsOfUser(
      {required String uid}) {
    return _fireStoreService.collectionStream(
            path: FireStorePath.notifications(),
            queryBuilder: (Query query){
              return query.orderBy('whenToNotify').where('uid',isEqualTo: uid);
            },
            builder: (Map<String, dynamic> data, String documentId) {
              return NotificationResponse.fromJson(data);
            });
    // logger.d("notifications length ",notifications);
    // return notifications;
  }

  Future<FcmTokenResponse?> fcmToken(String uid) async {
    return _fireStoreService.documentFuture(
        path: FireStorePath.fcmToken(uid),
        builder: (Map<String, dynamic>? data, String documentID) {
          if (data != null) {
            return FcmTokenResponse.fromJson(data);
          }
          return null;
        });
  }

  Future<void> updateFcmToken(String uid, String fcmToken) async {
    try {
      await _firebaseFirestore
          .doc(FireStorePath.fcmTokenCollections(uid, fcmToken))
          .set({'fcmToken': fcmToken});
    } catch (e) {
      logger.d('updateFcmToken e ', e);
    }
    return;
  }

  Future<void> addFcmToken(String uid, String fcmToken) async {
    try {
      await _firebaseFirestore
          .doc(FireStorePath.fcmTokenCollections(uid, fcmToken))
          .set({'fcmToken': fcmToken});
    } catch (e) {
      logger.d('updateFcmToken e ', e);
    }
    return;
  }

  Future<void> removeFcmToken(String uid) async {
    try {
      await _firebaseFirestore.doc(FireStorePath.fcmToken(uid)).delete();
    } catch (e) {
      logger.d('updateFcmToken e ', e);
    }
    return;
  }

  Future<void> sendNotifications(
      {required String uid,
      required String title,
      required String message}) async {
    HttpsCallable callable = _functions.httpsCallable('sendNotifications');
    final results = await callable(
        <String, dynamic>{'uid': uid, 'title': title, 'message': message});
  }
  Future<void> createNotification(
      {required String uid,
        required String message,
        required String title,
        required DateTime whenToNotify}) async {
    await _firebaseFirestore.collection(FireStorePath.notifications()).add({
      'message': message,
      'title': title,
      'uid': uid,
      'notificationSend':false,
      'whenToNotify':Timestamp.fromDate(whenToNotify)
    });
    return;
  }

  Future<void> scheduleNotifications() async {
    HttpsCallable callable = _functions.httpsCallable('scheduleNotification');
    final results = await callable();
  }
}
