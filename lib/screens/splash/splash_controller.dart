import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  SplashController({required this.authController});
  FirebaseAuthController authController;

  @override
  void onReady()async {
    // TODO: implement onReady
    super.onReady();

  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}