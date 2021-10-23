import 'package:flutter/widgets.dart';
import 'package:flutter_getx_boilerplate/firebase_api/notification_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';
import 'package:flutter_getx_boilerplate/models/response/fcm_token_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  NotificationController({required this.userDb, required this.notificationDb});

  UserDatabase userDb;
  NotificationDatabase notificationDb;
  RxList<UserResponse> users = <UserResponse>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  DateTime? dateSelected = DateTime.now();

  @override
  void onReady() {
    super.onReady();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    List<UserResponse> results = await userDb.getAllUsers();
    users.addAll(results);
  }



  Future<void> sendNotifications(UserResponse user) async {
    if (user.uid != null) {
      showLoading();
      await notificationDb.sendNotifications(uid: user.uid ?? '',title: titleController.text,message: messageController.text);
      hideLoading();
    }
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    messageController.dispose();
  }
}
