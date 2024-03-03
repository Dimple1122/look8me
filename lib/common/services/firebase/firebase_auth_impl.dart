import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:look8me/common/services/firebase/firebase_auth_service.dart';

import '../../model/response_model.dart';

class FirebaseAuthServiceImpl extends FirebaseAuthService {
  FirebaseAuth firebaseAuthInstance;

  FirebaseAuthServiceImpl(this.firebaseAuthInstance);

  @override
  Future<Response?> registration(
      {required String email, required String password}) async {
    try {
      final credential =
          await firebaseAuthInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response(type: ResponseType.success, data: credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return Response(type: ResponseType.failure, data: e.code);
    } catch (e) {
      return Response(type: ResponseType.failure, data: e.toString());
    }
  }

  @override
  Future<Response?> login(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response(type: ResponseType.success, data: credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      return Response(type: ResponseType.failure, data: e.code);
    } catch (e) {
      return Response(type: ResponseType.failure, data: e.toString());
    }
  }

  @override
  String? getEmail() {
    User? user = firebaseAuthInstance.currentUser;
    return user?.email;
  }

  @override
  String? getUserId() {
    User? user = firebaseAuthInstance.currentUser;
    return user?.uid;
  }

  @override
  Future<void> deleteUser() async {
    try {
      if (isUserLoggedIn()) {
        await firebaseAuthInstance.currentUser?.delete();
      }
    } catch (e) {
      debugPrint("Delete user error ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuthInstance.signOut();
    } catch (e) {
      debugPrint('Sign out error ${e.toString()}');
    }
  }

  @override
  bool isUserLoggedIn() {
    return firebaseAuthInstance.currentUser != null;
  }
}
