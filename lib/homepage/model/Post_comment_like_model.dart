class PostCommentLikeModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  PostCommentLikeModel({this.user, this.error, this.statusCode, this.message});

  PostCommentLikeModel.fromJson(Map<String, dynamic> json) {
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
  String? cmID;
  String? likeCount;
  String? likeStatus;

  User({this.cmID, this.likeCount, this.likeStatus});

  User.fromJson(Map<String, dynamic> json) {
    cmID = json['cmID'];
    likeCount = json['likeCount'];
    likeStatus = json['likeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cmID'] = this.cmID;
    data['likeCount'] = this.likeCount;
    data['likeStatus'] = this.likeStatus;
    return data;
  }
}