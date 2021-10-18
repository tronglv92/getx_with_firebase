import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_boilerplate/models/response/product_response.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';

import 'firestore_path.dart';
import 'firestore_service.dart';

class ProductDatabase {
  ProductDatabase();
  final FireStoreService _fireStoreService = FireStoreService.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addAllProducts() async {
    for (int i = 0; i < 50; i++) {
      ProductResponse productResponse =
      ProductResponse(name: 'product ' + i.toString(), price: i.toDouble());
      try {
        await _firebaseFirestore
            .collection(FireStorePath.products())
            .add(productResponse.toJson());
      } catch (error) {
        print("Failed to add user: $error");
      }
    }
  }
  
  Future<List<QueryDocumentSnapshot<Object?>>> getAllProducts({required int limit, DocumentSnapshot? documentSnapshot}) async{
    List<QueryDocumentSnapshot<Object?>> docs=await _fireStoreService.collectionDocument(
      path: FireStorePath.products(),
      queryBuilder: (Query query) {
        if(documentSnapshot!=null)
          {
            return query.orderBy('price').startAfterDocument(documentSnapshot).limit(limit);
          }
        else
          {
            return query.orderBy('price').limit(limit);
          }

      },
    );
    return docs;

  }
  
  

}