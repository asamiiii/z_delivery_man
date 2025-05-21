import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorage {
  static Future<String> uploadImageOnFirebaseStorage(
      File imageFile, String path) async {
    String? url;
// Create a storage reference from our app
    // final storageRef = FirebaseStorage.instance.ref();
// Create a reference to "mountains.jpg"
    // final mountainsRef = storageRef.child(p.basename(path));

    try {
      // await mountainsRef.putFile(imageFile);
      // url = await mountainsRef.getDownloadURL();
    } catch (e) {
      //
    }
    debugPrint('--> url : $url');
    return url ?? '';
  }
}
