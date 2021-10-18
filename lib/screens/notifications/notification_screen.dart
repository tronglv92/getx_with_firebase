

import 'package:flutter/material.dart';
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

  Future<void> onPressCreate(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,

        builder: (BuildContext context) {
          return InkWell(
            onTap:(){
              AppFocus.unfocus(context);
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: 15.W,
                  right: 15.W,
                  top: 15.W,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 15.H),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20.H,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 100.W,
                          child: Text(
                            'Email ',
                            style: txt14RegularRoboto(),
                          )),
                      Text(
                        'test@gmail.com',
                        style: txt14RegularRoboto(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.H,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 100.W,
                          child: Text(
                            'Title ',
                            style: txt14RegularRoboto(),
                          )),
                      const Expanded(
                        child: ATextFieldForm(
                          hintText: 'Title',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.H,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 100.W,
                          child: Text(
                            'Message ',
                            style: txt14RegularRoboto(),
                          )),
                      const Expanded(
                        child: ATextFieldForm(
                          hintText: 'Title',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.H,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 100.W,
                          child: Text(
                            'Time ',
                            style: txt14RegularRoboto(),
                          )),
                      Text(
                        '12/2/2021',
                        style: txt14RegularRoboto(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.H,
                  ),
                  ElevatedButton(
                    child: const Text('Create notification'),
                    onPressed: () {
                      AppFocus.unfocus(context);
                      WPickerDate.showPicker(context);
                    },
                  )
                ],
              ),
            ),
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
                  child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: txt14RegularRoboto(),
                                  ),
                                  SizedBox(
                                    height: 10.H,
                                  ),
                                  Text(
                                    'Email',
                                    style: txt12RegularRoboto(),
                                  ),
                                ],
                              ),
                            ),
                            AButtonRoundedLong(
                                padding: EdgeInsets.symmetric(horizontal: 5.W),
                                child: Text(
                                  'Notify',
                                  style:
                                      txt10RegularRoboto(color: Colors.white),
                                ),
                                primary: Colors.blue,
                                borderRadius: 14,
                                onPress: () {
                                  onPressCreate(context);
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 5.H,
                ),
                padding: EdgeInsets.symmetric(vertical: 20.H),
                itemCount: 30,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
