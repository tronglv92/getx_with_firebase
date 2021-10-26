import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_getx_boilerplate/shared/env/.env.example.dart';

class PaymentServices {
  final int amount;
  final String url;

  PaymentServices({this.amount = 10, this.url = ''});

  static init() async {
    Stripe.publishableKey = stripePublishableKey;

  }

  Future<PaymentMethod?> createPaymentMethod() async {
    print('The transaction amount to be charged is: $amount');
    final billingDetails = const BillingDetails(
      email: 'email@stripe.com',
      phone: '+48888000888',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    ); // mocked data for tests

    PaymentMethod paymentMethod =
        await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
      billingDetails: billingDetails,
    ));
    return paymentMethod;
  }

  Future<void> processPayment(PaymentMethod paymentMethod) async {}
}
