import 'dart:typed_data';

abstract class FirebaseStorageService {
  Future<Uint8List?> getData(String child);
}