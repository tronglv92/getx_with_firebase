import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/screens/login/login_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/constants/common.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/utils/regex.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_button_rounded_long.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_input_form.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/a_text_field.dart';

import 'package:flutter_getx_boilerplate/shared/widgets/p_appbar_transparency.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_keyboard_dismiss.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return PAppBarTransparency(
      child: WKeyboardDismiss(
        child: SafeArea(
          child: Form(
            key: controller.loginFormKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.W),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.W),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50.H),
                          Container(
                            height: 80.H,
                            width: 80.W,
                            color: Colors.red,
                          ),
                          SizedBox(height: 30.H),
                          Text(
                            'welcome'.tr,
                            style: txt32BoldRoboto(),
                          ),
                          SizedBox(height: 10.H),
                          Text(
                            'label_welcome'.tr,
                            style: txt18RegularRoboto(
                                color: ColorConstants.colorGrayOfText),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.H),

                    SizedBox(height: 10.H),
                    AInputForm.email(
                      focusNode: controller.emailFocus,
                      controller: controller.emailController,
                      validator: (value) {
                        if (!Regex.isEmail(value!)) {
                          return 'Email format error.';
                        }

                        if (value.isEmpty) {
                          return 'Email is required.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.H),
                    AInputForm.password(
                      focusNode: controller.passwordFocus,
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required.';
                        }

                        if (value.length < 6 || value.length > 15) {
                          return 'Password should be 6~15 characters';
                        }

                        return null;
                      },
                    ),

                    SizedBox(
                      height: 40.H,
                    ),
                    AButtonRoundedLong(
                      onPress: () {
                        controller.signInWithEmailAndPassword(context);
                      },
                      child: Center(
                        child: Text(
                          'login'.tr,
                          style: txt18RegularRoboto(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.H,
                    ),
                    AButtonRoundedLong(
                      onPress: () {
                        controller.registerWithEmailAndPassword(context);
                      },
                      child: Center(
                        child: Text(
                          'register'.tr,
                          style: txt18RegularRoboto(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.H,
                    ),
                    AButtonRoundedLong(
                      onPress: (){
                        controller.signInWithFacebook(context);
                      },
                      child: Center(
                        child: Text(
                          'Facebook',
                          style: txt18RegularRoboto(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.H,
                    ),
                    AButtonRoundedLong(
                      onPress: () {
                        controller.signInWithGoogle(context);
                      },
                      child: Center(
                        child: Text(
                          'Google',
                          style: txt18RegularRoboto(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.H,
                    ),
                    AButtonRoundedLong(
                      onPress: (){
                        controller.signInWithApple(context);
                      },
                      child: Center(
                        child: Text(
                          'Apple',
                          style: txt18RegularRoboto(color: Colors.white),
                        ),
                      ),
                    ),

                    // SizedBox(height: 30.H,)
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
