import 'package:firebase_database/firebase_database.dart';

import '../../model/novel_model.dart';
import '../../model/user_model.dart';

abstract class FirebaseDatabaseService {
  Future<void> createUser (User user);
  Future<void> deleteUserDataBase (String userId);
  Future<List<Novel>> getNovels();
  Future<List<String>> getCategories();
  Future<User?> getUser(String userId);
  DatabaseReference getNoOfLikesRef(int index);
  Future<void> likeNovel({required String userId, required String novelId, required int novelIndex});
  Future<void> unLikeNovel({required String userId, required String novelId, required int novelIndex});
  Future<void> addNovelToMyList({required String userId, required String novelId});
  Future<void> removeNovelFromMyList({required String userId, required String novelId});
  Future<void> updateContinueNovelList({required String userId, required String novelId, required double readProgress});
  Future<void> removeNovelFromContinueList({required String userId, required String novelId});
}