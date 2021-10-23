import 'package:flutter/material.dart';

import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Container(
     color: Colors.white,
     child:const Center(
       child: Text("Splash "),
     ),
   );
  }

}