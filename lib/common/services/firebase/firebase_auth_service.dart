import 'package:look8me/common/model/response_model.dart';

abstract class FirebaseAuthService {
  Future<Response?> registration({required String email, required String password});
  Future<Response?> login({required String email, required String password});
  Future<void> signOut();
  String? getEmail();
  String? getUserId();
  bool isUserLoggedIn();
  Future<void> deleteUser();
}