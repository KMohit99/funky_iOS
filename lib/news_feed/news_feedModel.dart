class NewsFeedModel {
  List<Data>? data;
  bool? error;
  String? statusCode;
  String? message;

  NewsFeedModel({this.data, this.error, this.statusCode, this.message});

  NewsFeedModel.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? tagLine;
  String? description;
  String? address;
  String? postImage;
  String? isVideo;
  String? likes;
  String? commentCount;
  String? createdDate;
  User? user;

  Data(
      {this.id,
        this.fullName,
        this.userName,
        this.image,
        this.tagLine,
        this.description,
        this.address,
        this.postImage,
        this.isVideo,
        this.likes,
        this.commentCount,
        this.createdDate,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    image = json['image'];
    tagLine = json['tagLine'];
    description = json['description'];
    address = json['address'];
    postImage = json['postImage'];
    isVideo = json['isVideo'];
    likes = json['likes'];
    commentCount = json['commentCount'];
    createdDate = json['createdDate'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['image'] = this.image;
    data['tagLine'] = this.tagLine;
    data['description'] = this.description;
    data['address'] = this.address;
    data['postImage'] = this.postImage;
    data['isVideo'] = this.isVideo;
    data['likes'] = this.likes;
    data['commentCount'] = this.commentCount;
    data['createdDate'] = this.createdDate;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? fullName;
  String? userName;
  String? email;
  String? parentEmail;
  String? gender;
  String? location;
  String? referralCode;
  String? image;
  String? about;
  String? userFollowUnfollow;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
  String? socialType;
  String? createdDate;

  User(
      {this.fullName,
        this.userName,
        this.email,
        this.parentEmail,
        this.gender,
        this.location,
        this.referralCode,
        this.image,
        this.about,
        this.userFollowUnfollow,
        this.userBlockUnblock,
        this.followerNumber,
        this.followingNumber,
        this.socialType,
        this.createdDate});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    userName = json['userName'];
    email = json['email'];
    parentEmail = json['parent_email'];
    gender = json['gender'];
    location = json['location'];
    referralCode = json['referral_code'];
    image = json['image'];
    about = json['about'];
    userFollowUnfollow = json['user_followUnfollow'];
    userBlockUnblock = json['user_blockUnblock'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    socialType = json['social_type'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['parent_email'] = this.parentEmail;
    data['gender'] = this.gender;
    data['location'] = this.location;
    data['referral_code'] = this.referralCode;
    data['image'] = this.image;
    data['about'] = this.about;
    data['user_followUnfollow'] = this.userFollowUnfollow;
    data['user_blockUnblock'] = this.userBlockUnblock;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['social_type'] = this.socialType;
    data['createdDate'] = this.createdDate;
    return data;
  }
}