import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/lang/translation_service.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/screens/home/home_controller.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_button_rounded_long.dart';

import 'package:flutter_getx_boilerplate/shared/widgets/w_button_rounded.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeController controller = Get.find();
  final FirebaseAuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    // logger.d("Render Home Screen");
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'.tr),
      ),
      body: Center(child: Obx(
        () {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.W),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  value: controller.selectedLang.value,
                  items: _buildDropdownMenuItems(),
                  onChanged: (String? value) {
                    controller.onChangeLocate(value);
                  },
                ),
                Text(authController.currentUser.value?.email ?? 'khong co'),
                SizedBox(
                  height: 15.H,
                ),
                AButtonRoundedLong(
                    child: Text(
                      'Schedule Notifications',
                      style: txt14RegularRoboto(color: Colors.white),
                    ),
                    onPress: () {
                      Get.toNamed(AppRoutes.SCHEDULE_NOTIFICATION);
                    }),
                SizedBox(
                  height: 15.H,
                ),
                AButtonRoundedLong(
                    child: Text(
                      'Notifications',
                      style: txt14RegularRoboto(color: Colors.white),
                    ),
                    onPress: () {
                      Get.toNamed(AppRoutes.NOTIFICATION);
                    }),
                SizedBox(
                  height: 15.H,
                ),
                AButtonRoundedLong(
                    child: Text(
                      'Add Notifications',
                      style: txt14RegularRoboto(color: Colors.white),
                    ),
                    onPress: () {
                      controller.addFcmTokens();
                    }),
                SizedBox(
                  height: 15.H,
                ),
                AButtonRoundedLong(
                    child: Text(
                      'Lazy load product',
                      style: txt14RegularRoboto(color: Colors.white),
                    ),
                    onPress: () {
                      Get.toNamed(AppRoutes.PRODUCT);
                    }),
                SizedBox(
                  height: 15.H,
                ),
                AButtonRoundedLong(
                    child: Text(
                      'Logout',
                      style: txt14RegularRoboto(color: Colors.white),
                    ),
                    onPress: () {
                      controller.logout();

                    }),
              ],
            ),
          );
        },
      )),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    List<DropdownMenuItem<String>> list = [];
    TranslationService.langs.forEach((key, value) {
      list.add(DropdownMenuItem<String>(
        value: key,
        child: Text(key),
      ));
    });
    return list;
  }
}
