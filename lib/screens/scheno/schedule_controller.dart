
import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/firebase_api/notification_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/notification_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'package:get/get.dart';

class ScheduleController extends GetxController {
  ScheduleController(
      {required this.notifyDb, required this.authController});

  NotificationDatabase notifyDb;
  FirebaseAuthController authController;
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  DateTime? dateSelected = DateTime.now();

  UserResponse? getCurrentUser() {
    return authController.currentUser.value;
  }

  @override
  void onReady() {
    logger.d("ScheduleNotificationController onReady ");
    super.onReady();

  }

  Stream<List<NotificationResponse>> getAllNotificationsOfUser()  {

    return notifyDb.getAllNotificationsOfUser(
        uid: authController.currentUser.value?.uid ?? '');
  }

  Future<void> createNotifications() async {
    if (titleController.text.isEmpty) {
      showError('Title is empty');
      return;
    }
    if (messageController.text.isEmpty) {
      showError('Message is empty');
      return;
    }

    UserResponse? currentUser = getCurrentUser();
    if (currentUser != null && currentUser.uid != null) {
      showLoading();

      await notifyDb.createNotification(
          uid: currentUser.uid ?? '',
          message: messageController.text,
          title: titleController.text,
          whenToNotify: dateSelected ?? DateTime.now());
      logger.d("createNotification success ");
      hideLoading();
    } else {
      logger.d("Can't get uid user");
    }
  }

  Future<void> testNotification()async{
    await notifyDb.scheduleNotifications();
  }
  @override
  void onClose() {
    super.onClose();
  }
}
