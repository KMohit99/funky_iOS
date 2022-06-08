class UserInfoModel {
  List<Data>? data;
  bool? error;
  String? statusCode;
  String? message;

  UserInfoModel({this.data, this.error, this.statusCode, this.message});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
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
  String? userFollowUnfollow;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
  String? socialType;
  String? createdDate;

  Data(
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
        this.userFollowUnfollow,
        this.userBlockUnblock,
        this.followerNumber,
        this.followingNumber,
        this.socialType,
        this.createdDate});

  Data.fromJson(Map<String, dynamic> json) {
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
    userFollowUnfollow = json['user_followUnfollow'];
    userBlockUnblock = json['user_blockUnblock'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    socialType = json['social_type'];
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
    data['user_followUnfollow'] = this.userFollowUnfollow;
    data['user_blockUnblock'] = this.userBlockUnblock;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['social_type'] = this.socialType;
    data['createdDate'] = this.createdDate;
    return data;
  }
}