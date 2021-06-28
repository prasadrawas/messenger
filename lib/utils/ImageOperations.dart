import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:messenger/utils/Authentication.dart';
import 'package:messenger/utils/reusable_widgets.dart';

class ImageOperations {
  Future<File> cropImage(File img) async {
    img = await ImageCropper.cropImage(
      sourcePath: img.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          activeControlsWidgetColor: Color(0xFF27ae60),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    return img;
  }

  Future<String> uploadImage(File img, email) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('$email');
      TaskSnapshot storageTaskSnapshot = await reference.putFile(img);
      var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
      await updateFirestoreEntry(dowUrl, email);
      await Authentication().storeMyData(email);
      return dowUrl;
    } catch (e) {
      return '0';
    }
  }

  Future updateFirestoreEntry(imgUrl, email) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs[0].reference.update({'image': imgUrl});
      });
    } catch (e) {
      snackBar('Failed to create Firestore entry', e.toString());
    }
  }
}
