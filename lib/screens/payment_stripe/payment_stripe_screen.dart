import 'package:flutter_getx_boilerplate/screens/payment_stripe/response_card.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'loading_button.dart';
import 'payment_stripe_controller.dart';

class PaymentStripeScreen extends StatefulWidget {
  const PaymentStripeScreen({Key? key}) : super(key: key);

  @override
  _PaymentStripeScreenState createState() => _PaymentStripeScreenState();
}

class _PaymentStripeScreenState extends State<PaymentStripeScreen> {
  final controller = CardEditController();

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
    initCard();
  }
  initCard()async{

  }
  void update() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stripe Simple Tutorial'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardField(
              controller: controller,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 1,color: Colors.grey)
                ),

              ),
              cursorColor: Colors.red,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            LoadingButton(
              text: 'Pay',
              onPressed: controller.complete ? _handlePayPress : null,
            ),
            SizedBox(height: 20),
            Divider(),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => controller.focus(),
                    child: Text('Focus'),
                  ),
                  SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => controller.blur(),
                    child: Text('Blur'),
                  ),
                  SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => controller.clear(),
                    child: Text('Clear'),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 20),
            ResponseCard(
              response: controller.details.toJson().toString(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayPress() async {
    if (!controller.complete) {
      return;
    }

    try {
      // 1. Gather customer billing information (ex. email)
      final billingDetails = BillingDetails(
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

      // 2. Create payment method
      final paymentMethod =
          await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
        billingDetails: billingDetails,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }
}
