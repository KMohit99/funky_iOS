class FeedLikeUnlikeModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  FeedLikeUnlikeModel({this.user, this.error, this.statusCode, this.message});

  FeedLikeUnlikeModel.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class User {
  String? newsID;
  String? feedLikeCount;
  String? feedlikeStatus;

  User({this.newsID, this.feedLikeCount, this.feedlikeStatus});

  User.fromJson(Map<String, dynamic> json) {
    newsID = json['newsID'];
    feedLikeCount = json['feedLike_count'];
    feedlikeStatus = json['feedlikeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsID'] = this.newsID;
    data['feedLike_count'] = this.feedLikeCount;
    data['feedlikeStatus'] = this.feedlikeStatus;
    return data;
  }
}