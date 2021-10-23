import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/notification_response.dart';

import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/screens/notifications/views/create_notify_dialog.dart';
import 'package:flutter_getx_boilerplate/screens/scheno/schedule_controller.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';

import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/utils/focus.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_button_rounded_long.dart';

import 'package:flutter_getx_boilerplate/shared/widgets/w_keyboard_dismiss.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_picker_date.dart';

import 'package:get/get.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  ScheduleScreen({Key? key}) : super(key: key);

  Future<void> onPressItem() async {
    controller.getAllNotificationsOfUser();
  }

  Future<void> onPressDate(BuildContext context) async {
    AppFocus.unfocus(context);
    DateTime? dateSelect = await WPickerDate.showPicker(context);
    controller.dateSelected = dateSelect;
  }

  Future<void> onPressCreate(
      {required BuildContext context, required UserResponse? user}) async {
    if (user != null) {
      showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return CreateNotifyDialog(
              user: user,
              showTime: true,
              titleController: controller.titleController,
              messageController: controller.messageController,
              date: controller.dateSelected,
              onPressCreate: () {
                controller.createNotifications();
                Get.back();
              },
              onPressDate: () {
                onPressDate(context);
              },
            );
          });
    } else {
      showError("User is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          iconSize: 25,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Schedule Notifications",
          style: txt18BoldRoboto(color: Colors.white),
        ),
      ),
      body: WKeyboardDismiss(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<NotificationResponse>>(
                    stream: controller.getAllNotificationsOfUser(),
                    initialData: [],
                    builder: (BuildContext ctx, snapshot) {
                      if (snapshot.hasError) {
                        //return error message
                        logger.d(
                            'getAllNotificationsOfUser error ', snapshot.error);
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      if (!snapshot.hasData) {
                        //return a loader
                        return const Center(
                            child: Text(''
                                'Loading'));
                      }
                      logger.d("snapshot length ", snapshot.data?.length);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          NotificationResponse notification =
                              snapshot.data![index];

                          return InkWell(
                            onTap: onPressItem,
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.W, vertical: 8.H),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.title,
                                      style: txt18BoldRoboto(),
                                    ),
                                    SizedBox(
                                      height: 5.H,
                                    ),
                                    Text(
                                      notification.message,
                                      style: txt14RegularRoboto(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data?.length ?? 0,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.H, horizontal: 15.W),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10.H,
                          );
                        },
                      );
                    }),
              ),
              AButtonRoundedLong(
                child: Text('Test notify'),
                onPress: () {
                  controller.testNotification();
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onPressCreate(context: context, user: controller.getCurrentUser());
        },
        child: const Icon(
          Icons.notification_add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
