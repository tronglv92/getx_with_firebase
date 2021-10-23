import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_getx_boilerplate/models/response/error_response.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_dialog_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../my_app.dart';

showLoading() {
  EasyLoading.show(status: 'loading...');
}

hideLoading() {
  EasyLoading.dismiss();
}

void showError(String? message, {String? title}) {
  Get.dialog(WDialogAlert(
    title: title ?? 'Error ',
    content: message ?? '',
    onCancelPressed: () {
      Get.back();
    },
    onConfirmPressed: () {
      Get.back();
    },
  ));
}

Future<void> showNotification(
    {required String? title, required String? message}) async {
  const String yourChannelId = "com.tronglv.getfirebase";
  const String yourChannelName = 'Get Firebase';
  const String? channelDescription = 'Your channel description';
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    yourChannelId,
    yourChannelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    message,
    platformChannelSpecifics,
  );
}
