
import 'package:flutter_getx_boilerplate/screens/payment_stripe/payment_services.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class PaymentStripeController extends GetxController {
  PaymentStripeController();
  PaymentMethod? paymentMethod;


  @override
  void onReady() {
    super.onReady();

  }
  onPressAddPayment() async
  {
    paymentMethod= await PaymentServices().createPaymentMethod();
    logger.d("onPressAddPayment id ",paymentMethod!.id);
  }


  @override
  void onClose() {
    super.onClose();

  }
}
