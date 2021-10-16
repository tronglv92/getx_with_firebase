import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/local/role.dart';

import 'package:flutter_getx_boilerplate/screens/profile/profile_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/common.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_button_rounded_long.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_circle_photo.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_input_form.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_option_selected.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_popup_picker_image.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/image_viewer/image_viewer.dart';

import 'package:flutter_getx_boilerplate/shared/widgets/p_appbar_transparency.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_keyboard_dismiss.dart';

import 'package:get/get.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> onPressPhoto(
      {required BuildContext context, required String photo}) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ImageViewer(
          imageProviders: [
            NetworkImage(photo),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PAppBarTransparency(
      child: WKeyboardDismiss(
        child: SafeArea(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 30.W),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: controller.onPressClose,
                      icon: const Icon(Icons.close),
                      iconSize: 30.W,
                      color: Colors.black,
                    ),
                    Text(
                      'Profile Info',
                      style: txt18RegularRoboto(),
                    ),
                    SizedBox(
                      width: 30.W,
                    )
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.H),
                        Obx(() => Center(
                              child: Hero(
                                tag: 'profile',
                                child: ACirclePhoto(
                                    onPressPhoto: controller.photoUrl.value
                                                ?.isNullOrEmpty ==
                                            false
                                        ? () {
                                            onPressPhoto(
                                                context: context,
                                                photo:
                                                    controller.photoUrl.value!);
                                          }
                                        : null,
                                    photoUrl: controller.photoUrl.value,
                                    showLoading: controller.showLoadingPhoto,
                                    onPressEdit: () {
                                      controller.onPressEditPhoto(context);
                                    }),
                              ),
                            )),
                        SizedBox(height: 30.H),
                        //FIRST NAME
                        Padding(
                          padding: EdgeInsets.only(left: 30.W),
                          child: Text(
                            'Name',
                            style: txt14RegularRoboto(),
                          ),
                        ),
                        SizedBox(height: 10.H),
                        AInputForm(
                          hintText: 'Enter your name',
                          controller: controller.nameController,
                        ),

                        //PHONE
                        SizedBox(height: 25.H),

                        Padding(
                          padding: EdgeInsets.only(left: 30.W),
                          child: Text(
                            'Mobile number',
                            style: txt14RegularRoboto(),
                          ),
                        ),
                        SizedBox(height: 10.H),
                        AInputForm.phone(
                          hintText: 'Enter your phone',
                          controller: controller.phoneController,
                        ),
                        //EMAIL
                        SizedBox(height: 25.H),
                        Padding(
                          padding: EdgeInsets.only(left: 30.W),
                          child: Text(
                            'Email',
                            style: txt14RegularRoboto(),
                          ),
                        ),
                        SizedBox(height: 10.H),
                        AInputForm.email(
                          hintText: 'Enter your email',
                          controller: controller.emailController,
                          enabled: false,
                        ),

                        //Role
                        SizedBox(height: 25.H),
                        Padding(
                          padding: EdgeInsets.only(left: 30.W),
                          child: Text(
                            'You are',
                            style: txt14RegularRoboto(),
                          ),
                        ),
                        SizedBox(height: 10.H),
                        Obx(() => Row(
                              children: [
                                AOption(
                                  label: 'User',
                                  isSelected: controller.roleId.value ==
                                      Role.user.value,
                                  onPress: () {
                                    controller.onPressRole(Role.user.value);
                                  },
                                ),
                                SizedBox(
                                  width: 50.W,
                                ),
                                AOption(
                                  label: 'Store',
                                  isSelected: controller.roleId.value ==
                                      Role.store.value,
                                  onPress: () {
                                    controller.onPressRole(Role.store.value);
                                  },
                                )
                              ],
                            )),

                        //Role
                        SizedBox(height: 80.H),

                        AButtonRoundedLong(
                          onPress: controller.onCompletedProfile,
                          child: Text(
                            'Complete',
                            style: txt14RegularRoboto(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
