import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';

import 'count_controller.dart';
class Count extends StatelessWidget {
   Count({Key? key}) : super(key: key);
  final CountController c = Get.find();

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.


    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
        appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

        // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
        body: Center(child: ElevatedButton(
            child: const Text("Go to Other"), onPressed: () => Get.to(Other()))),
        floatingActionButton:
        FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {

  // You can ask Get to find a Controller that is being used by another page and redirect you to it.

   Other({Key? key}) : super(key: key);

  @override
  Widget build(context){
    logger.d("Render Other");
    // Access the updated count variable
    return Scaffold(
        appBar: AppBar(title:  Text("text")),
        body: Center(child: Container(),));
  }
}