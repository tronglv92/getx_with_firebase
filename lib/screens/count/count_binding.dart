import 'package:flutter_getx_boilerplate/screens/count/count_controller.dart';
import 'package:get/get.dart';

class CountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountController>(
            () => CountController());
  }
}