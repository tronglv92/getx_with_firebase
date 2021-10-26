import 'package:get/get.dart';

import 'payment_stripe_controller.dart';


class PaymentStripeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentStripeController>(
            () => PaymentStripeController());
  }
}
