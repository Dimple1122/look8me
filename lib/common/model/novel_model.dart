class Novel {
  String? novelId;
  String? novelName;
  String? novelImage;
  String? novelCategory;
  String? novelContent;
  String? novelSummary;
  int? noOfLikes;

  Novel(
      {this.novelId,
        this.novelName,
        this.novelImage,
        this.novelCategory,
        this.novelContent,
        this.novelSummary, this.noOfLikes});

  Novel.fromJson(Map<String, dynamic> json) {
    novelId = json['novel_id'];
    novelName = json['novel_name'];
    novelImage = json['novel_image'];
    novelCategory = json['novel_category'];
    novelContent = json['novel_content'];
    novelSummary = json['novel_summary'];
    noOfLikes = json['no_of_likes'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['novel_id'] = novelId;
    data['novel_name'] = novelName;
    data['novel_image'] = novelImage;
    data['novel_category'] = novelCategory;
    data['novel_content'] = novelContent;
    data['novel_summary'] = novelSummary;
    data['no_of_likes'] = noOfLikes;
    return data;
  }
}

class NovelByCategory {
  String category;
  List<Novel> novels;
  NovelByCategory({required this.category, required this.novels});
}