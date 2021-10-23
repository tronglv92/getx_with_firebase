import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/utils/focus.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_text_field.dart';

class CreateNotifyDialog extends StatelessWidget {
  const CreateNotifyDialog(
      {Key? key,
      required this.user,
      required this.onPressCreate,
      required this.onPressDate,
      required this.titleController,
      required this.messageController,
      this.date,
      this.showTime = false})
      : super(key: key);
  final UserResponse user;
  final VoidCallback onPressDate;
  final VoidCallback onPressCreate;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final DateTime? date;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
                  user.email ?? '',
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
                Expanded(
                  child: ATextFieldForm(
                    hintText: 'Title',
                    controller: titleController,
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
                Expanded(
                  child: ATextFieldForm(
                    hintText: 'Message',
                    controller: messageController,
                  ),
                ),
              ],
            ),
            if (showTime == true)
              Column(
                children: [
                  SizedBox(
                    height: 15.H,
                  ),
                  InkWell(
                    onTap: () {
                      onPressDate();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                            width: 100.W,
                            child: Text(
                              'Time ',
                              style: txt14RegularRoboto(),
                            )),
                        Text(
                          date == null
                              ? 'Date notify'
                              : date?.toDDMMyyyyHHmm() ?? '',
                          style: txt14RegularRoboto(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 15.H,
            ),
            ElevatedButton(
              child: const Text('Create notification'),
              // onPressed: () {
              //   // AppFocus.unfocus(context);
              //   // WPickerDate.showPicker(context);
              // },
              onPressed: onPressCreate,
            )
          ],
        ),
      ),
    );
  }
}
