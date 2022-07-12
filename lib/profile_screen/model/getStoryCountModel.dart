class StoryCountModel {
  List<Data>? data;
  String? statusCode;
  bool? error;
  String? message;

  StoryCountModel({this.data, this.statusCode, this.error, this.message});

  StoryCountModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    statusCode = json['status_code'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status_code'] = this.statusCode;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? id;
  String? fullName;
  String? userName;
  User_story_c? user;

  Data({this.id, this.fullName, this.userName, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    user = json['user'] != null ? new User_story_c.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User_story_c {
  String? id;
  String? fullName;
  String? userName;
  String? email;
  String? phone;
  String? parentEmail;
  String? gender;
  String? location;
  String? referralCode;
  String? image;
  String? about;
  String? type;
  String? profileUrl;
  String? socialId;
  String? socialType;
  String? userFollowUnfollow;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
  String? createdDate;

  User_story_c(
      {this.id,
        this.fullName,
        this.userName,
        this.email,
        this.phone,
        this.parentEmail,
        this.gender,
        this.location,
        this.referralCode,
        this.image,
        this.about,
        this.type,
        this.profileUrl,
        this.socialId,
        this.socialType,
        this.userFollowUnfollow,
        this.userBlockUnblock,
        this.followerNumber,
        this.followingNumber,
        this.createdDate});

  User_story_c.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    email = json['email'];
    phone = json['phone'];
    parentEmail = json['parent_email'];
    gender = json['gender'];
    location = json['location'];
    referralCode = json['referral_code'];
    image = json['image'];
    about = json['about'];
    type = json['type'];
    profileUrl = json['profileUrl'];
    socialId = json['socialId'];
    socialType = json['social_type'];
    userFollowUnfollow = json['user_followUnfollow'];
    userBlockUnblock = json['user_blockUnblock'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['parent_email'] = this.parentEmail;
    data['gender'] = this.gender;
    data['location'] = this.location;
    data['referral_code'] = this.referralCode;
    data['image'] = this.image;
    data['about'] = this.about;
    data['type'] = this.type;
    data['profileUrl'] = this.profileUrl;
    data['socialId'] = this.socialId;
    data['social_type'] = this.socialType;
    data['user_followUnfollow'] = this.userFollowUnfollow;
    data['user_blockUnblock'] = this.userBlockUnblock;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['createdDate'] = this.createdDate;
    return data;
  }
}