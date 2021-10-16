import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_getx_boilerplate/models/response/error_response.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_dialog_alert.dart';
import 'package:get/get.dart';

showLoading(){
  EasyLoading.show(status: 'loading...');
}

hideLoading(){
  EasyLoading.dismiss();
}

void showError(String? message,{String? title}) {

  Get.dialog(WDialogAlert(
    title: title??'Error ',
    content: message??'',
    onCancelPressed: () {
      Get.back();
    },
    onConfirmPressed: () {
      Get.back();
    },
  ));
}