import 'package:flutter_getx_boilerplate/screens/product/product_controller.dart';
import 'package:get/get.dart';



class ProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
            () => ProductController(authController: Get.find(),productDb: Get.find()));
  }
}
