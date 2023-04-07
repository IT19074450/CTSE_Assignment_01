import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  FirebaseStorage storage = FirebaseStorage.instance;

  static UploadTask? uploadFile(String destination, File file, String user) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(
          file, SettableMetadata(customMetadata: {'uploaded_by': user}));
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
