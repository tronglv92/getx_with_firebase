import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/screens/product/product_controller.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d("RENDER ProductScreen");
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'.tr),
      ),
      body: Obx(() {
        return ListView.separated(
            controller: controller.scrollController,
            itemCount: controller.products.length +
                (controller.canLoadMore == true ? 1 : 0),
            padding: EdgeInsets.symmetric(vertical: 10.H, horizontal: 15.W),
            separatorBuilder: (BuildContext buildContext, int index) =>
                SizedBox(
                  height: 10.H,
                ),
            itemBuilder: (BuildContext buildContext, int index) {
              if (index == controller.products.length) {
                return const SizedBox(
                  height: 50,
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                );
              } else {
                ProductResponse product = controller.products[index];
                return Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.W, vertical: 50.H),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: txt18BoldRoboto(),
                        ),
                        Text(
                          product.price.toString() + " usd",
                          style: txt18RegularRoboto(),
                        ),
                      ],
                    ),
                  ),
                );
              }
            });
      }),
    );
  }
}
