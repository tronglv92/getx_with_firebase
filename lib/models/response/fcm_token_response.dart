import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FcmTokenResponse extends Equatable {
  const FcmTokenResponse({
    required this.fcmToken,
  });

  FcmTokenResponse.fromJson(Map<String, dynamic> data)
      : fcmToken = data['fcmToken'] as String;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fcmToken': fcmToken,
    };
  }

  final String fcmToken;

  @override
  String toString() {
    return '$FcmTokenResponse('
        'fcmToken: $fcmToken '
        ')';
  }

  @override
  // TODO: implement props
  List<Object> get props {
    return [fcmToken];
  }
}
