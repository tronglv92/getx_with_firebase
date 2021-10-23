import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/screens/notifications/views/create_notify_dialog.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/utils/focus.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_button_rounded_long.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_input_form.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_text_field.dart';

import 'package:flutter_getx_boilerplate/shared/widgets/p_appbar_transparency.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_keyboard_dismiss.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_picker_date.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_picker_time.dart';

import 'package:get/get.dart';

import 'notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({Key? key}) : super(key: key);

  Future<void> onPressDate(BuildContext context) async {
    AppFocus.unfocus(context);
    DateTime? dateSelect= await WPickerDate.showPicker(context);
    controller.dateSelected=dateSelect;

  }

  Future<void> onPressCreate(
      {required BuildContext context, required UserResponse user}) async {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CreateNotifyDialog(
              user: user,
              titleController: controller.titleController,
              messageController: controller.messageController,
              date: controller.dateSelected,
              onPressCreate: () {
                controller.sendNotifications(user);
                Get.back();
              },
              onPressDate: () {
                onPressDate(context);
              },

          );
        });
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
          "Notifications",
          style: txt18BoldRoboto(color: Colors.white),
        ),
      ),
      body: WKeyboardDismiss(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Obx(() => ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          UserResponse user = controller.users[index];
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.W, vertical: 15.H),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.displayName ?? '',
                                            style: txt14RegularRoboto(),
                                          ),
                                          SizedBox(
                                            height: 10.H,
                                          ),
                                          Text(
                                            user.email ?? '',
                                            style: txt12RegularRoboto(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AButtonRoundedLong(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.W),
                                        child: Text(
                                          'Notify',
                                          style: txt10RegularRoboto(
                                              color: Colors.white),
                                        ),
                                        primary: Colors.blue,
                                        borderRadius: 14,
                                        onPress: () {
                                          onPressCreate(
                                              context: context, user: user);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: 5.H,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20.H),
                        itemCount: controller.users.length,
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
