import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserResponse extends Equatable {
  UserResponse(
      {this.uid,
      this.email,
      this.displayName,
      this.phoneNumber,
      this.photoUrl,
      this.roleId = 0,
      this.documentID});

  UserResponse.fromJson(Map<String, dynamic> data, this.documentID)
      : uid = data['uid'] as String,
        displayName =
            data['displayName'] != null ? data['displayName'] as String : '',
        email = data['email'] as String,
        phoneNumber =
            data['phoneNumber'] != null ? data['phoneNumber'] as String : '',
        photoUrl = data['photoUrl'] != null ? data['photoUrl'] as String : '',
        roleId = data['roleId'] as int;

  UserResponse.fromUserFirebase(User user)
      : uid = user.uid,
        displayName = user.displayName,
        email = user.email,
        phoneNumber = user.phoneNumber,
        photoUrl = user.photoURL,
        roleId = 0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'roleId': roleId,
    };
  }

  final String? uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final int? roleId;
  String? documentID;

  @override
  String toString() {
    return '$UserResponse('
        'uid: $uid, '
        'displayName: $displayName, '
        'email: $email, '
        'phoneNumber: $phoneNumber, '
        'photoURL: $photoUrl, '
        'roleId: $roleId, '
        ')';
  }

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      uid ?? '',
      displayName ?? '',
      email ?? '',
      phoneNumber ?? '',
      photoUrl ?? '',
      roleId ?? ''
    ];
  }
}
