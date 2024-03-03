class User {
  String? userId;
  String? userName;
  String? userDob;
  String? userEmail;
  List<String>? categoriesSelected;
  List<String>? likedNovels = [];
  List<String>? myListNovels = [];
  List<ContinueReadingNovel>? continueReadingNovels = [];

  User(
      {this.userId,
        this.userName,
        this.userDob,
        this.userEmail,
        this.categoriesSelected,
        this.likedNovels,
        this.myListNovels,
        this.continueReadingNovels});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userDob = json['user_dob'];
    userEmail = json['user_email'];
    categoriesSelected = json['categories_selected']?.cast<String>() ?? [];
    likedNovels = json['liked_novels']?.cast<String>() ?? [];
    myListNovels = json['my_list_novels']?.cast<String>() ?? [];
    if (json['continue_reading_novels'] != null) {
      continueReadingNovels = <ContinueReadingNovel>[];
      json['continue_reading_novels'].forEach((v) {
        continueReadingNovels!.add(ContinueReadingNovel.fromJson(v));
      });
    }
    else {
      continueReadingNovels = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_dob'] = userDob;
    data['user_email'] = userEmail;
    data['categories_selected'] = categoriesSelected;
    data['liked_novels'] = likedNovels;
    data['my_list_novels'] = myListNovels;
    if (continueReadingNovels != null) {
      data['continue_reading_novels'] =
          continueReadingNovels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContinueReadingNovel {
  String? novelId;
  double? readProgress;

  ContinueReadingNovel({this.novelId, this.readProgress});

  ContinueReadingNovel.fromJson(Map<String, dynamic> json) {
    novelId = json['novel_id'];
    readProgress = json['readProgress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['novel_id'] = novelId;
    data['readProgress'] = readProgress;
    return data;
  }
}