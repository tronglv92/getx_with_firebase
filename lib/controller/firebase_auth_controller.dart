import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_api_error.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_auth_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';
import 'package:flutter_getx_boilerplate/models/response/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_dialog_alert.dart';
import 'package:get/get.dart';

class FirebaseAuthController extends GetxController with FirebaseApiError {
  FirebaseAuthController({required this.authDb, required this.userDb});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Rx<User?> firebaseUser;
  final Rx<UserResponse?> currentUser = UserResponse().obs;


  final FirebaseAuthDatabase authDb;
  final UserDatabase userDb;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async{
    logger.d("Auth change user ",user);
    await _initializeUserResponse(user);

    if (user == null) {

      if (Get.currentRoute != AppRoutes.LOGIN) {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } else {

      Get.offAllNamed(AppRoutes.PROFILE);
    }
  }

  _initializeUserResponse(User? firebaseUser) async {

    if (firebaseUser != null) {
      UserResponse? userResponse =
          await userDb.userStream(firebaseUser.uid).first;

      // add new profile if new user
      if (userResponse == null) {
        logger.d('init UserResponse find null');
        userResponse = UserResponse.fromUserFirebase(firebaseUser);

        await _addUserToFirestore(firebaseUser.uid, userResponse);
      }
      logger.d('init UserResponse ',userResponse);
      currentUser.value = userResponse;
    } else {
      clearCurrentUser();
    }
  }

  void clearCurrentUser() {
    currentUser.value = UserResponse();
  }

  _addUserToFirestore(String userId, UserResponse user) async {
    await userDb.setUser(user: user, uid: userId);
  }

  void showDialogError(dynamic error) {
    ErrorResponse errorResponse = parseApiErrorType(error);
   showError(errorResponse.message);
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await apiCallSafety<UserCredential?>(
        () => authDb.registerWithEmailAndPassword(email, password),
        onStart: () async {
      showLoading();
    }, onCompleted: (bool status, UserCredential? res) async {
      hideLoading();
      if (status == true && res != null) {
        // _initializeUserResponse(res.user);
      }
    }, onError: (dynamic error) async {});
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await apiCallSafety<UserCredential?>(
        () => authDb.signInWithEmailAndPassword(email, password),
        onStart: () async {
      showLoading();
    }, onCompleted: (bool status, UserCredential? res) async {
      hideLoading();
      if (status == true && res != null) {
        // _initializeUserResponse(res.user);
      }
    }, onError: (dynamic error) async {});
  }

  Future<UserCredential?> signInWithGoogle() async {
    await apiCallSafety<UserCredential?>(() => authDb.signInWithGoogle(),
        onStart: () async {
      showLoading();
    }, onCompleted: (bool status, UserCredential? res) async {
      hideLoading();
      if (status == true && res != null) {
        // _initializeUserResponse(res.user);
      }
    }, onError: (dynamic error) async {});
  }

  Future<UserCredential?> signInWithFacebook() async {
    await apiCallSafety<UserCredential?>(() => authDb.signInWithFacebook(),
        onStart: () async {
      showLoading();
    }, onCompleted: (bool status, UserCredential? res) async {
      hideLoading();
      if (status == true && res != null) {
        // _initializeUserResponse(res.user);
      }
    }, onError: (dynamic error) async {});
  }

  Future<UserCredential?> signInWithApple() async {
    await apiCallSafety<UserCredential?>(() => authDb.signInWithApple(),
        onStart: () async {
      showLoading();
    }, onCompleted: (bool status, UserCredential? res) async {
      hideLoading();
      if (status == true && res != null) {
        // _initializeUserResponse(res.user);
      }
    }, onError: (dynamic error) async {});
  }

  Future<void> signOut() async {
    await apiCallSafety<void>(() => authDb.signOut(), onStart: () async {
      showLoading();
    }, onCompleted: (bool status, void res) async {
      hideLoading();
      if (status == true) {

      }
    }, onError: (dynamic error) async {});
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    firebaseUser.close();
    currentUser.close();
  }

  @override
  Future<int> onApiError(error) async {
    // TODO: implement onApiError
    showDialogError(error);
    return 1;
  }
}
