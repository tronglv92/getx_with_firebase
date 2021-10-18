import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/firebase_api/product_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';

import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductController({required this.authController, required this.productDb});

  final FirebaseAuthController authController;
  final ProductDatabase productDb;
  RxList<ProductResponse> products = <ProductResponse>[].obs;
  int limit = 10;
  DocumentSnapshot? lastDocument;

  final ScrollController scrollController = ScrollController();
  bool canLoadMore = false;
  bool isLoading=false;

  @override
  void onReady() {
    super.onReady();

    loadProducts();

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 100;
      if (maxScroll - currentScroll <= delta && canLoadMore == true) {
        canLoadMore = false;
        logger.d("load more product =======>", products.length);
        loadMoreProducts();
      }
    });
  }

  Future<void> loadProducts() async {
    isLoading=true;

    List<DocumentSnapshot> docs = await productDb.getAllProducts(limit: limit);


    products.value = docs
        .map((snapshot) =>
            ProductResponse.fromJson(snapshot.data() as Map<String, dynamic>))
        .toList();
    canLoadMore=docs.length >= limit;


    lastDocument = docs.isNotEmpty ? docs[docs.length - 1] : lastDocument;
    isLoading=false;
  }

  Future<void> loadMoreProducts() async {
    isLoading=true;
    await Future.delayed( Duration(seconds: 5));
    List<DocumentSnapshot> docs = await productDb.getAllProducts(
        limit: limit, documentSnapshot: lastDocument);


    List<ProductResponse> data = docs
        .map((snapshot) =>
            ProductResponse.fromJson(snapshot.data() as Map<String, dynamic>))
        .toList();

    products.addAll(data);
    canLoadMore=docs.length >= limit;

    lastDocument = docs.isNotEmpty ? docs[docs.length - 1] : lastDocument;
    isLoading=false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
  }
}
