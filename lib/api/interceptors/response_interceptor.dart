import 'dart:async';


import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

FutureOr<dynamic> responseInterceptor(
    Request request, Response response) async {
  EasyLoading.dismiss();
  String s = "${request.method} ${request.url} -->";
  s += "\nheader: ${request.headers}";
  logger.d('request ====>: ${s}');

  logger.d('Response body ===>:${response.statusCode} : ${response.body}');
  if (response.statusCode == 401) {
    handleErrorStatus(response);
    return;
  }

  return response;
}

void handleErrorStatus(Response response) {
  switch (response.statusCode) {
    case 401:
      final message = ErrorResponse.fromJson(response.body);
      CommonWidget.toast(message.message??'Error handleErrorStatus');
      break;
    default:
  }

  return;
}
