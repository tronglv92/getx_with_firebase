import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_auth_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/product_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';

import 'package:get/get.dart';

import 'controller/firebase_auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {

    Get.put(FirebaseAuthDatabase(),permanent: true);
    Get.put(UserDatabase(),permanent: true);
    Get.put(ProductDatabase(),permanent: true);
    Get.put(FirebaseAuthController(authDb: Get.find(),userDb: Get.find()),permanent: true);
  }
}
