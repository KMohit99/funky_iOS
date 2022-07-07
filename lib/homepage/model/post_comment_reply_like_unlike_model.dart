class PostCommentReplyLikeModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  PostCommentReplyLikeModel(
      {this.user, this.error, this.statusCode, this.message});

  PostCommentReplyLikeModel.fromJson(Map<String, dynamic> json) {
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
  String? replyID;
  String? likecount;
  String? likeStatus;

  User({this.replyID, this.likecount, this.likeStatus});

  User.fromJson(Map<String, dynamic> json) {
    replyID = json['replyID'];
    likecount = json['likecount'];
    likeStatus = json['likeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['replyID'] = this.replyID;
    data['likecount'] = this.likecount;
    data['likeStatus'] = this.likeStatus;
    return data;
  }
}