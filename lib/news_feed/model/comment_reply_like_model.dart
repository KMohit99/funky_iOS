class CommentReplyLikeUnlikeModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  CommentReplyLikeUnlikeModel(
      {this.user, this.error, this.statusCode, this.message});

  CommentReplyLikeUnlikeModel.fromJson(Map<String, dynamic> json) {
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
  String? nfID;
  String? likeCount;
  String? likeStatus;

  User({this.nfID, this.likeCount, this.likeStatus});

  User.fromJson(Map<String, dynamic> json) {
    nfID = json['nfID'];
    likeCount = json['likeCount'];
    likeStatus = json['likeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nfID'] = this.nfID;
    data['likeCount'] = this.likeCount;
    data['likeStatus'] = this.likeStatus;
    return data;
  }
}