import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/firebase_api/notification_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';
import 'package:flutter_getx_boilerplate/lang/translation_service.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';
import 'dart:math';


class HomeController extends GetxController {
  final FirebaseAuthController authController;
  final UserDatabase userDb;
  final NotificationDatabase notifyDb;
  HomeController({required this.authController,required this.userDb,required this.notifyDb});
  Rx<String?> selectedLang = (TranslationService.locale?.languageCode).obs;

  @override
  void onReady() {
    super.onReady();
    logger.e('HomeController currentUser = ', authController.currentUser);
    // if (authController.currentUser != null) {
    //
    //   setUpProfile(authController.currentUser);
    // }
  }

  Future<void> logout() async{
    await authController.signOut();
  }
  void onChangeLocate(String? value){
    selectedLang.value=value;
    TranslationService.changeLocale(value??'en');

  }

  Future<void> getAllUsers() async{
     List<UserResponse> users=  await userDb.getAllUsers();
     int a=0;
  }
  Future<void>addFcmTokens() async{
    notifyDb.addFcmToken(authController.currentUser.value?.uid??'', getRandomString(10));
  }
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


}
