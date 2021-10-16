import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_api_error.dart';
import 'package:flutter_getx_boilerplate/firebase_api/user_db.dart';
import 'package:flutter_getx_boilerplate/models/response/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/user_response.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';

import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_file.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_popup_picker_image.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/image_viewer/image_viewer.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ProfileController extends GetxController with FirebaseApiError {
  final FirebaseAuthController authController;
  final UserDatabase userDb;

  ProfileController({required this.authController, required this.userDb});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  Rx<String?> photoUrl = ''.obs;
  bool showLoadingPhoto = false;
  Rx<int> roleId = 0.obs;
  UserResponse? currentUser;
  late ImagePicker _picker;

  @override
  void onReady() {
    super.onReady();
    _picker = ImagePicker();
    if (authController.currentUser.value?.uid != null) {
      currentUser = authController.currentUser.value;
      setUpProfile(currentUser);
    } else {
      currentUser = null;
    }
  }

  Future<void> onPressClose() async {
    Get.offAllNamed(AppRoutes.HOME);
  }

  Future<void> onPressRole(int role) async {
    roleId.value = role;
  }

  void setUpProfile(UserResponse? user) {
    nameController.text = user?.displayName ?? '';
    phoneController.text = user?.phoneNumber ?? '';
    emailController.text = user?.email ?? '';
    roleId.value = user?.roleId ?? 0;
    photoUrl.value = user?.photoUrl ?? '';
  }

  Future<void> onPressCamera() async {
    Get.back();

    if (currentUser?.uid.isBlank == false) {
      await pickImageAndUpload(ImageSource.camera);
    }
  }

  Future<void> onPressChooseLibrary() async {
    Get.back();

    if (currentUser?.uid.isBlank == false) {
      await pickImageAndUpload(ImageSource.gallery);
    }
  }

  Future<void> pickImageAndUpload(ImageSource source) async {

    showLoading();
    try{
      final XFile? pickedFileList = await _picker.pickImage(
        source: source,
      );
      logger.d('pickImageAndUpload pickedFileList =====> ', pickedFileList?.path);
      if (pickedFileList?.path == null){
        hideLoading();
        return;
      }
      final File? image = await AppFile.cropImage(pickedFileList!.path);
      logger.d('pickImageAndUpload image =====> ', image);
      if (image == null) {
        hideLoading();
        return;
      }
      final String url =
      await AppFile.uploadFile(image: image, destination: PHOTO_PROFILE);
      logger.d('pickImageAndUpload url =====> ', url);
      await apiCallSafety<void>(
              () => userDb.updatePhoto(photo: url, uid: (currentUser?.uid ?? '')),
          onStart: () async {

          },
          onCompleted: (bool status, void res) async {
            hideLoading();
            photoUrl.value = url;
            logger.d('upload photo success = ');
          },
          skipOnError: true,
          onError: (dynamic error) async {
            logger.e('pickImageAndUpload error = ', error);
          });
    }
    catch(e)
    {
      logger.d("pickImageAndUpload error ",e);
      showError("Can't pick image, please try again!");
      hideLoading();
    }

  }

  Future<void> onPressCancelImage() async {
    Get.back();
  }

  Future<void> onPressEditPhoto(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        // isDismissible: false,
        // enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return APopupPickerImage(
              onPressTakePhoto: onPressCamera,
              onPressChooseLibrary: onPressChooseLibrary,
              onPressCancelImage: onPressCancelImage);
        });
  }

  Future<void> onCompletedProfile() async {
    if (currentUser == null && currentUser?.uid?.isBlank == true) {
      return;
    }
    final UserResponse user = UserResponse(
        uid: currentUser?.uid!,
        email: currentUser?.email ?? '',
        displayName: nameController.text,
        phoneNumber: phoneController.text,
        photoUrl: photoUrl.value,
        roleId: roleId.value);

    await apiCallSafety(() => userDb.setUser(user: user, uid: user.uid!),
        onStart: () async {
          showLoading();
        },
        onCompleted: (bool status, void res) async {
          /// Update current user

          authController.currentUser.value = user;
          hideLoading();
          Get.offAllNamed(AppRoutes.HOME);
        },
        skipOnError: true,
        onError: (dynamic error) async {
          logger.e('onCompletedProfile error = ', error);
        });
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    phoneController.dispose();
  }

  @override
  Future<int> onApiError(error) async {
    // TODO: implement onApiError
    return 1;
  }
}
