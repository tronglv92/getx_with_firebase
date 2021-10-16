import 'package:flutter_getx_boilerplate/api/base_provider.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:get/get.dart';

class ApiProvider extends BaseProvider {
  Future<Response> login(String path, LoginRequest data) async{
    Response response= await post(path, data.toJson());
    return response;
  }

  Future<Response> register(String path, RegisterRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getUsers(String path) {
    return get(path);
  }
}
