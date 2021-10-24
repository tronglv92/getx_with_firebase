import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_api_error.dart';
import 'package:flutter_getx_boilerplate/firebase_api/product_db.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'package:get/get.dart';

class SearchController extends GetxController with FirebaseApiError {
  final ProductDatabase productDb;
  RxList<ProductResponse> products = <ProductResponse>[].obs;
  Timer? _timer;

  SearchController({required this.productDb});

  TextEditingController searchController = TextEditingController();

  onChangedSearch(String search) async {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 400), () async {
      if (search.isEmpty == false) {
      await searchProduct(search);
      } else {
        products.value = [];
      }
    });
  }

  searchProduct(String search) async {
    await apiCallSafety<List<ProductResponse>>(
        () => productDb.searchProducts(search: search),
        onStart: () async {},
        onCompleted: (bool status, List<ProductResponse>? res) async {
          /// Update current user
          if (res != null) {
            products.value = res;
          }
        },
        skipOnError: true,
        onError: (dynamic error) async {
          logger.e('searchProduct error = ', error);
           ErrorResponse errorResponse= parseApiErrorType(error);
           showError(errorResponse.message);
        });
  }

  onClearSearch() {
    searchController.text = '';
    products.value = [];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    _timer?.cancel();
  }

  @override
  Future<int> onApiError(error) async {
    // TODO: implement onApiError
    return 1;
  }
}
