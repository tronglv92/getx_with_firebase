import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationResponse extends Equatable{
  NotificationResponse({
    required this.uid,
    required this.title,
    required this.message,
    required this.whenToNotify,
  });

  String message;
  String title;
  String uid;
  Timestamp whenToNotify;



  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        uid: json["uid"],
        title: json["title"],
        message: json["message"],
        whenToNotify: json["whenToNotify"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "title": title,
        "message": message,
        "whenToNotify": whenToNotify,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [uid,title,message,whenToNotify];
  @override
  String toString() {
    return '$NotificationResponse('
        'uid: $uid, '
        'title: $title, '
        'message: $message, '
        'whenToNotify: $whenToNotify, '
        ')';
  }
}
