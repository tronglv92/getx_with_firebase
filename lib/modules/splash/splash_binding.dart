import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashOldBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashOldController>(SplashOldController());
  }
}
