import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/screens/search/search_controller.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_search.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_divider_line.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_keyboard_dismiss.dart';
import 'package:get/get.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          iconSize: 25,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Notifications",
          style: txt18BoldRoboto(color: Colors.white),
        ),
      ),
      body: WKeyboardDismiss(
        child: Column(
          children: [
            // Header search

            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.H, horizontal: 15.W),
                child: ASearch(
                  onChanged: controller.onChangedSearch,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.onClearSearch,
                    iconSize: 25.W,
                  ),
                  controller: controller.searchController,
                )),

            WDividerLine(
              height: 1.H,
            ),
            Expanded(
                child: Obx(() => ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15.H),
                      itemBuilder: (BuildContext context, int index) {
                        ProductResponse product = controller.products[index];

                        return Card(
                          elevation: 3,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.W, vertical: 15.H),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: txt18BoldRoboto(),
                                ),
                                SizedBox(
                                  height: 5.H,
                                ),
                                Text(
                                  product.price.toString(),
                                  style: txt14RegularRoboto(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: controller.products.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10.H,
                        );
                      },
                    )))
            //Result seach
          ],
        ),
      ),
    );
  }
}
