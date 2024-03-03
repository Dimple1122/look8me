import 'package:look8me/common/services/firebase/firebase_database_service.dart';
import 'package:look8me/common/services/locator.dart';

import '../model/novel_model.dart';
import '../model/user_model.dart';

class GlobalDatabaseHelper {
  static List<Novel> allNovels = [];
  static User? currentUser;
  static List<String> allCategories = [];

  static void init(User user, List<Novel> novels, List<String> categories) {
    currentUser = user;
    allNovels = novels;
    allCategories = categories;
  }

  static List<Novel> getAllContinueReadingNovels() => allNovels
      .where((novel) => currentUser!.continueReadingNovels!.any(
          (continueReadingNovel) =>
              continueReadingNovel.novelId == novel.novelId))
      .toList();

  static bool isNovelInContinueReading(String novelId) =>
      currentUser!.continueReadingNovels!
          .any((element) => element.novelId == novelId);

  static double getNovelReadProgress(String novelId) {
    if(isNovelInContinueReading(novelId)) {
      final index = currentUser!.continueReadingNovels!.indexWhere((element) => element.novelId == novelId);
      return currentUser!.continueReadingNovels!.elementAt(index).readProgress!;
    }
    else {
      return 0.0;
    }
  }

  static List<Novel> getMyListNovels() => allNovels
      .where((novel) =>
          currentUser!.myListNovels!.any((novelId) => novelId == novel.novelId))
      .toList();

  static bool isNovelInMyList(String novelId)  => currentUser!.myListNovels!.contains(novelId);

  static bool isNovelLiked(String novelId) => currentUser!.likedNovels!.contains(novelId);

  static void likeNovel(String novelId, int novelIndex) async {
    currentUser!.likedNovels!.add(novelId);
    locator.get<FirebaseDatabaseService>().likeNovel(userId: currentUser!.userId!, novelId: novelId, novelIndex: novelIndex);
  }

  static void unLikeNovel(String novelId, int novelIndex) async {
    currentUser!.likedNovels!.removeWhere((element) => element == novelId);
    locator.get<FirebaseDatabaseService>().unLikeNovel(userId: currentUser!.userId!, novelId: novelId, novelIndex: novelIndex);
  }

  static void addNovelToMyList(String novelId) async {
    currentUser!.myListNovels!.add(novelId);
    locator.get<FirebaseDatabaseService>().addNovelToMyList(userId: currentUser!.userId!, novelId: novelId);
  }

  static void removeNovelFromMyList(String novelId) async {
    currentUser!.myListNovels!.removeWhere((element) => element == novelId);
    locator.get<FirebaseDatabaseService>().removeNovelFromMyList(userId: currentUser!.userId!, novelId: novelId);
  }

}
