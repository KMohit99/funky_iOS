class PostCommnetModel {
  List<Data>? data;
  bool? error;
  String? statusCode;
  String? message;

  PostCommnetModel({this.data, this.error, this.statusCode, this.message});

  PostCommnetModel.fromJson(Map<String, dynamic> json) {
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
  String? cmID;
  String? fullName;
  String? userName;
  String? image;
  String? message;
  String? likeCount;
  String? likeStatus;
  User? user;
  List<Replies>? replies;

  Data(
      {this.cmID,
        this.fullName,
        this.userName,
        this.image,
        this.message,
        this.likeCount,
        this.likeStatus,
        this.user,
        this.replies});

  Data.fromJson(Map<String, dynamic> json) {
    cmID = json['cmID'];
    fullName = json['fullName'];
    userName = json['userName'];
    image = json['image'];
    message = json['message'];
    likeCount = json['likeCount'];
    likeStatus = json['likeStatus'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cmID'] = this.cmID;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['image'] = this.image;
    data['message'] = this.message;
    data['likeCount'] = this.likeCount;
    data['likeStatus'] = this.likeStatus;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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

class Replies {
  String? replyID;
  String? userId;
  String? comId;
  String? comment;
  String? likecount;
  String? likeStatus;
  User? user;

  Replies(
      {this.replyID,
        this.userId,
        this.comId,
        this.comment,
        this.likecount,
        this.likeStatus,
        this.user});

  Replies.fromJson(Map<String, dynamic> json) {
    replyID = json['replyID'];
    userId = json['userId'];
    comId = json['comId'];
    comment = json['comment'];
    likecount = json['likecount'];
    likeStatus = json['likeStatus'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['replyID'] = this.replyID;
    data['userId'] = this.userId;
    data['comId'] = this.comId;
    data['comment'] = this.comment;
    data['likecount'] = this.likecount;
    data['likeStatus'] = this.likeStatus;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}