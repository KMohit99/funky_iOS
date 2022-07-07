class postImageCommentPostModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  postImageCommentPostModel(
      {this.user, this.error, this.statusCode, this.message});

  postImageCommentPostModel.fromJson(Map<String, dynamic> json) {
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
  String? iD;
  String? commentCount;

  User({this.iD, this.commentCount});

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['commentCount'] = this.commentCount;
    return data;
  }
}