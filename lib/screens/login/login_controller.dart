import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/controller/firebase_auth_controller.dart';
import 'package:flutter_getx_boilerplate/firebase_api/fb_api_error.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_dialog_alert.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController  {
  final FirebaseAuthController authController;

  LoginController(this.authController);

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final emailFocus = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final passwordFocus = FocusNode();

  @override
  void onReady() {
    super.onReady();
  }

  Future<UserCredential?> registerWithEmailAndPassword(
      BuildContext context) async {
    AppFocus.unfocus(context);
    if (loginFormKey.currentState!.validate()) {
      authController.registerWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
    }
  }



  //Method to handle user sign in using email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      BuildContext context) async {
    AppFocus.unfocus(context);
    if (loginFormKey.currentState!.validate()) {
      authController.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
         );
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    // await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    AppFocus.unfocus(context);
    authController.signInWithGoogle(
        );
  }

  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    AppFocus.unfocus(context);
    authController.signInWithFacebook(
        );
  }

  Future<UserCredential?> signInWithApple(BuildContext context) async {
    AppFocus.unfocus(context);
    authController.signInWithApple(
       );
  }

  @override
  void onClose() {

    super.onClose();
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}
