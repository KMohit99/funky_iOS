class CommentPostModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  CommentPostModel({this.user, this.error, this.statusCode, this.message});

  CommentPostModel.fromJson(Map<String, dynamic> json) {
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
  String? feedCount;

  User({this.newsID, this.feedCount});

  User.fromJson(Map<String, dynamic> json) {
    newsID = json['newsID'];
    feedCount = json['feedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsID'] = this.newsID;
    data['feedCount'] = this.feedCount;
    return data;
  }
}