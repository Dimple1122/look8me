import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:look8me/common/services/firebase/firebase_auth_impl.dart';
import 'package:look8me/common/services/firebase/firebase_auth_service.dart';
import 'package:look8me/common/services/firebase/firebase_database_impl.dart';
import 'package:look8me/common/services/firebase/firebase_database_service.dart';
import 'package:look8me/common/services/firebase/firebase_storage_impl.dart';
import 'package:look8me/common/services/firebase/firebase_storage_service.dart';
import 'package:look8me/common/services/navigation_service.dart';

final GetIt locator = GetIt.instance;

setUpLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<FirebaseStorageService>(() => FirebaseStorageImpl(FirebaseStorage.instance.ref()));
  locator.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthServiceImpl(FirebaseAuth.instance));
  locator.registerLazySingleton<FirebaseDatabaseService>(() => FirebaseDatabaseImpl(FirebaseDatabase.instance.ref()));
}