class ViewStoryModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  ViewStoryModel({this.user, this.error, this.statusCode, this.message});

  ViewStoryModel.fromJson(Map<String, dynamic> json) {
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
  String? stID;
  String? viewCount;

  User({this.stID, this.viewCount});

  User.fromJson(Map<String, dynamic> json) {
    stID = json['stID'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stID'] = this.stID;
    data['viewCount'] = this.viewCount;
    return data;
  }
}