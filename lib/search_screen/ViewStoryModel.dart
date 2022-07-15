class ViewStoryModel {
  List<User_view>? user;
  bool? error;
  String? statusCode;
  String? message;

  ViewStoryModel({this.user, this.error, this.statusCode, this.message});

  ViewStoryModel.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <User_view>[];
      json['user'].forEach((v) {
        user!.add(new User_view.fromJson(v));
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

class User_view {
  String? stID;
  String? viewCount;

  User_view({this.stID, this.viewCount});

  User_view.fromJson(Map<String, dynamic> json) {
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