import 'dart:io';




import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'app_log.dart';

class AppFile{

  static Future<List<String>> uploadFiles({required List<File> images,required String destination}) async {
    final List<String> imageUrls = await Future.wait(images.map((_image) => uploadFile(image: _image,destination: destination)));
    logger.d(imageUrls);
    return imageUrls;
  }

  static Future<String> uploadFile({required File image,required String destination}) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(destination);
    final UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete((){});

    return await storageReference.getDownloadURL();
  }
  static Future<File?> cropImage(String path) async {
    final File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        maxHeight: 500,
        maxWidth: 500,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    return croppedFile;
  }
}
