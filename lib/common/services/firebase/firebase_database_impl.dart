import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:look8me/common/services/firebase/firebase_database_service.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../model/novel_model.dart';
import '../../model/user_model.dart';

class FirebaseDatabaseImpl extends FirebaseDatabaseService {
  DatabaseReference reference;

  FirebaseDatabaseImpl(this.reference);

  @override
  Future<void> createUser(User user) async {
    try {
      await reference.child('users/${user.userId}').set(user.toJson());
    } catch (e) {
      debugPrint('User creation failed');
    }
  }

  @override
  Future<void> deleteUserDataBase(String userId) async {
    try {
      await reference.child('users/$userId').set(null);
    } catch (e) {
      debugPrint('User creation failed');
    }
  }

  @override
  Future<List<Novel>> getNovels() async {
    try {
      final snapshot = await reference.child('novels').get();
      if (snapshot.exists) {
        List<dynamic> data = jsonDecode(jsonEncode(snapshot.value));
        return data.map((e) => Novel.fromJson(e)).toList();
      } else {
        debugPrint('No data available.');
        return [];
      }
    } catch (e) {
      debugPrint('Get Data failed $e');
      return [];
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await reference.child('categories').get();
      if (snapshot.exists) {
        List<dynamic> data = jsonDecode(jsonEncode(snapshot.value));
        return data.map((e) => e as String).toList();
      } else {
        debugPrint('No data available.');
        return [];
      }
    } catch (e) {
      debugPrint('Get Data failed $e');
      return [];
    }
  }

  @override
  Future<User?> getUser(String userId) async {
    try {
      final snapshot = await reference.child('users/$userId').get();
      if (snapshot.exists) {
        dynamic data = jsonDecode(jsonEncode(snapshot.value));
        return User.fromJson(data);
      } else {
        debugPrint('No data available.');
        return null;
      }
    } catch (e) {
      debugPrint('Get Data failed $e');
      return null;
    }
  }

  @override
  DatabaseReference getNoOfLikesRef(int index) {
    return reference.child('novels/$index/no_of_likes');
  }

  @override
  Future<void> likeNovel(
      {required String userId,
      required String novelId,
      required int novelIndex}) async {
    final currentUserLikedNovelsRef =
        reference.child('users/$userId/liked_novels');
    final noOfLikesRef = reference.child('novels/$novelIndex/no_of_likes');
      await currentUserLikedNovelsRef.runTransaction((likedNovels) {
        if (likedNovels == null) {
          return Transaction.success([novelId]);
          // return Transaction.abort();
        }
        List<dynamic> updatedLikedNovels =
            List.of(likedNovels as List<dynamic>);
        updatedLikedNovels.add(novelId);
        return Transaction.success(updatedLikedNovels);
      });
    await noOfLikesRef.runTransaction((value) {
      if (value == null) {
        return Transaction.abort();
      }
      final noOfLikes = (value as int) + 1;
      return Transaction.success(noOfLikes);
    });
  }

  @override
  Future<void> unLikeNovel(
      {required String userId,
      required String novelId,
      required int novelIndex}) async {
    final currentUserLikedNovelsRef =
        reference.child('users/$userId/liked_novels');
    final noOfLikesRef = reference.child('novels/$novelIndex/no_of_likes');
    await currentUserLikedNovelsRef.runTransaction((likedNovels) {
      if (likedNovels == null) {
        return Transaction.success([""]);
        // return Transaction.abort();
      }
      List<dynamic> updatedLikedNovels = List.of(likedNovels as List<dynamic>);
      updatedLikedNovels.removeWhere((element) => element == novelId);
      return Transaction.success(updatedLikedNovels);
    });
    await noOfLikesRef.runTransaction((value) {
      if (value == null) {
        return Transaction.abort();
      }
      final noOfLikes = (value as int) - 1;
      return Transaction.success(noOfLikes);
    });
  }

  @override
  Future<void> addNovelToMyList({required String userId, required String novelId}) async {
    final currentUserMyListNovelsRef = reference.child('users/$userId/my_list_novels');
    await currentUserMyListNovelsRef.runTransaction((myListNovels) {
      if (myListNovels == null) {
        return Transaction.success([novelId]);
      }
      List<dynamic> updatedMyListNovels = List.of(myListNovels as List<dynamic>);
      updatedMyListNovels.add(novelId);
      return Transaction.success(updatedMyListNovels);
    });
  }

  @override
  Future<void> removeNovelFromMyList({required String userId, required String novelId}) async {
    final currentUserMyListNovelsRef = reference.child('users/$userId/my_list_novels');
    await currentUserMyListNovelsRef.runTransaction((myListNovels) {
      if (myListNovels == null) {
        return Transaction.success([""]);
      }
      List<dynamic> updatedMyListNovels = List.of(myListNovels as List<dynamic>);
      updatedMyListNovels.removeWhere((element) => element == novelId);
      return Transaction.success(updatedMyListNovels);
    });
  }
}
