import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'firestore_path.dart';
import 'firestore_service.dart';

class ProductDatabase {
  ProductDatabase();

  final FireStoreService _fireStoreService = FireStoreService.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> addAllProducts() async {
    for (int i = 0; i < 50; i++) {
      ProductResponse productResponse =
          ProductResponse(name: 'product ' + i.toString(), price: i);
      try {
        await _firebaseFirestore
            .collection(FireStorePath.products())
            .add(productResponse.toJson());
      } catch (error) {
        logger.d("Failed to add user: $error");
      }
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getAllProducts(
      {required int limit, DocumentSnapshot? documentSnapshot}) async {
    List<QueryDocumentSnapshot<Object?>> docs =
        await _fireStoreService.collectionDocument(
      path: FireStorePath.products(),
      queryBuilder: (Query query) {
        if (documentSnapshot != null) {
          return query
              .orderBy('price')
              .startAfterDocument(documentSnapshot)
              .limit(limit);
        } else {
          return query.orderBy('price').limit(limit);
        }
      },
    );
    return docs;
  }

  Future<List<ProductResponse>> searchProducts({required String search}) async {
    List<ProductResponse> products = [];
    try {
      HttpsCallable callable = _functions.httpsCallable('searchProduct',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 60)));
      final results = await callable(<String, dynamic>{"search": search});

      if (results.data is List) {
        for (int i = 0; i < results.data.length; i++) {
          var item = results.data[i];
          ProductResponse product =ProductResponse.fromJson(Map<String, dynamic>.from(item));
          products.add(product);
        }
      }
    } on FirebaseFunctionsException catch (e) {

      throw ErrorResponse(message: e.message,code: e.code);
    } catch (e) {
      logger.d("searchProducts e ", e);
      throw ErrorResponse(message: e.toString());
    }
    logger.d("searchProducts products ", products);
    return products;
  }
}
