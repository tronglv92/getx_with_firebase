import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/lang/translation_service.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  final FirebaseAuthController authController;


  HomeController({required this.authController});
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




}
