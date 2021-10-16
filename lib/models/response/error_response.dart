import 'dart:convert';

class ErrorResponse {
  ErrorResponse({ this.message, this.code});

  String? message="Unknown";
  String? code="Unknown";

  factory ErrorResponse.fromRawJson(String str) =>
      ErrorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      ErrorResponse(message: json["message"], code: json["code"]);

  Map<String, dynamic> toJson() => {"message": message, "code": code};
}
