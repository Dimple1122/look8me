import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:look8me/common/services/firebase/firebase_storage_service.dart';

class FirebaseStorageImpl extends FirebaseStorageService {
  Reference firebaseStorageReference;
  FirebaseStorageImpl(this.firebaseStorageReference);

  @override
  Future<Uint8List?> getData(String child) async {
    final storageRef = firebaseStorageReference.child(child);
    return storageRef.getData();
  }
}