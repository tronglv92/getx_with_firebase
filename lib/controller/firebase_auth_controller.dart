import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_api_error.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_auth_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/notification_db.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';
import 'package:flutter_getx_boilerplate/models/response/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_dialog_alert.dart';
import 'package:get/get.dart';

class FirebaseAuthController extends GetxController with FirebaseApiError {
  FirebaseAuthController(
      {required this.authDb,
      required this.userDb,
      required this.notificationDatabase});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Rx<User?> firebaseUser;
  final Rx<UserResponse?> currentUser = UserResponse().obs;

  final FirebaseAuthDatabase authDb;
  final UserDatabase userDb;
  final NotificationDatabase notificationDatabase;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, setInitialScreen);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Save newToken
      if (currentUser.value?.uid != null) {
        updateFcmToken(currentUser.value?.uid, newToken);
      }
    });
  }

  setInitialScreen(User? user) async {
    logger.d("Auth change user ");

    await _initializeUserResponse(user);
    // Get.toNamed(AppRoutes.HOME);
    if (user == null) {
      if (Get.currentRoute != AppRoutes.LOGIN) {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } else {
      if (Get.currentRoute != AppRoutes.HOME) {
        Get.offAllNamed(AppRoutes.HOME);
      }
    }
  }

  Future<void> _initializeUserResponse(User? firebaseUser) async {
    if (firebaseUser != null) {
      UserResponse? userResponse =
          await userDb.userStream(firebaseUser.uid).first;

      // add new profile if new user
      if (userResponse == null) {
        logger.d('user is null');
        userResponse = UserResponse.fromUserFirebase(
          firebaseUser,
        );

        try {
          await _addUserToFirestore(firebaseUser.uid, userResponse);
        } catch (e) {
          logger.d('error ', e);
        }
      }
      logger.d('init UserResponse ', userResponse);
      updateCurrentUser(userResponse);
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      updateFcmToken(userResponse.uid, fcmToken);
    } else {
      clearCurrentUser();
    }
    return;
  }

  Future<void> updateFcmToken(String? uid, String? fcmToken) async {
    // Update fcm token
    if (fcmToken != null && uid != null) {
      logger.d('update fcmtoken ');
      await notificationDatabase.updateFcmToken(uid, fcmToken);
    }
  }

  void clearCurrentUser() {
    currentUser.value = UserResponse();
  }

  Future<void> updateCurrentUser(UserResponse userResponse) async {
    currentUser.value = userResponse;
  }

  Future<void> _addUserToFirestore(String userId, UserResponse user) async {
    await userDb.setUser(user: user, uid: userId);

    return;
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
      if (currentUser.value?.uid != null) {
        await notificationDatabase.removeFcmToken(currentUser.value?.uid ?? '');
        clearCurrentUser();
      }

      hideLoading();
      if (status == true) {}
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
