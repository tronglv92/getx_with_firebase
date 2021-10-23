
import 'package:flutter_getx_boilerplate/screens/scheno/schedule_controller.dart';
import 'package:get/get.dart';

class ScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(()=>ScheduleController(authController: Get.find(),notifyDb: Get.find()));
  }
}
