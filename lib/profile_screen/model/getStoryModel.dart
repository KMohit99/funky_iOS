// class GetStoryModel {
//   List<Data_story>? data;
//   String? statusCode;
//   bool? error;
//   String? message;
//
//   GetStoryModel({this.data, this.statusCode, this.error, this.message});
//
//   GetStoryModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data_story>[];
//       json['data'].forEach((v) {
//         data!.add(new Data_story.fromJson(v));
//       });
//     }
//     statusCode = json['status_code'];
//     error = json['error'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['status_code'] = this.statusCode;
//     data['error'] = this.error;
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class Data_story {
//   String? stID;
//   String? fullName;
//   String? userName;
//   String? image;
//   String? title;
//   String? storyPhoto;
//   String? uploadVideo;
//   String? isVideo;
//   String? viewCount;
//   String? dateTime;
//   User? user;
//   List<Storys>? storys;
//
//   Data_story(
//       {this.stID,
//         this.fullName,
//         this.userName,
//         this.image,
//         this.title,
//         this.storyPhoto,
//         this.uploadVideo,
//         this.isVideo,
//         this.viewCount,
//         this.dateTime,
//         this.user,
//         this.storys});
//
//   Data_story.fromJson(Map<String, dynamic> json) {
//     stID = json['stID'];
//     fullName = json['fullName'];
//     userName = json['userName'];
//     image = json['image'];
//     title = json['title'];
//     storyPhoto = json['story_photo'];
//     uploadVideo = json['uploadVideo'];
//     isVideo = json['isVideo'];
//     viewCount = json['viewCount'];
//     dateTime = json['dateTime'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     if (json['storys'] != null) {
//       storys = <Storys>[];
//       json['storys'].forEach((v) {
//         storys!.add(new Storys.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['stID'] = this.stID;
//     data['fullName'] = this.fullName;
//     data['userName'] = this.userName;
//     data['image'] = this.image;
//     data['title'] = this.title;
//     data['story_photo'] = this.storyPhoto;
//     data['uploadVideo'] = this.uploadVideo;
//     data['isVideo'] = this.isVideo;
//     data['viewCount'] = this.viewCount;
//     data['dateTime'] = this.dateTime;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     if (this.storys != null) {
//       data['storys'] = this.storys!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class User {
//   String? id;
//   String? fullName;
//   String? userName;
//   String? email;
//   String? phone;
//   String? parentEmail;
//   String? gender;
//   String? location;
//   String? referralCode;
//   String? image;
//   String? about;
//   String? type;
//   String? profileUrl;
//   String? socialId;
//   String? socialType;
//   String? userFollowUnfollow;
//   String? userBlockUnblock;
//   String? followerNumber;
//   String? followingNumber;
//   String? createdDate;
//
//   User(
//       {this.id,
//         this.fullName,
//         this.userName,
//         this.email,
//         this.phone,
//         this.parentEmail,
//         this.gender,
//         this.location,
//         this.referralCode,
//         this.image,
//         this.about,
//         this.type,
//         this.profileUrl,
//         this.socialId,
//         this.socialType,
//         this.userFollowUnfollow,
//         this.userBlockUnblock,
//         this.followerNumber,
//         this.followingNumber,
//         this.createdDate});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     fullName = json['fullName'];
//     userName = json['userName'];
//     email = json['email'];
//     phone = json['phone'];
//     parentEmail = json['parent_email'];
//     gender = json['gender'];
//     location = json['location'];
//     referralCode = json['referral_code'];
//     image = json['image'];
//     about = json['about'];
//     type = json['type'];
//     profileUrl = json['profileUrl'];
//     socialId = json['socialId'];
//     socialType = json['social_type'];
//     userFollowUnfollow = json['user_followUnfollow'];
//     userBlockUnblock = json['user_blockUnblock'];
//     followerNumber = json['follower_number'];
//     followingNumber = json['following_number'];
//     createdDate = json['createdDate'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['fullName'] = this.fullName;
//     data['userName'] = this.userName;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['parent_email'] = this.parentEmail;
//     data['gender'] = this.gender;
//     data['location'] = this.location;
//     data['referral_code'] = this.referralCode;
//     data['image'] = this.image;
//     data['about'] = this.about;
//     data['type'] = this.type;
//     data['profileUrl'] = this.profileUrl;
//     data['socialId'] = this.socialId;
//     data['social_type'] = this.socialType;
//     data['user_followUnfollow'] = this.userFollowUnfollow;
//     data['user_blockUnblock'] = this.userBlockUnblock;
//     data['follower_number'] = this.followerNumber;
//     data['following_number'] = this.followingNumber;
//     data['createdDate'] = this.createdDate;
//     return data;
//   }
// }
//
// class Storys {
//   String? id;
//   String? userId;
//   String? storyPhoto;
//   String? uploadVideo;
//   String? isVideo;
//   String? type;
//
//   Storys(
//       {this.id,
//         this.userId,
//         this.storyPhoto,
//         this.uploadVideo,
//         this.isVideo,
//         this.type});
//
//   Storys.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['userId'];
//     storyPhoto = json['story_photo'];
//     uploadVideo = json['uploadVideo'];
//     isVideo = json['isVideo'];
//     type = json['type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['userId'] = this.userId;
//     data['story_photo'] = this.storyPhoto;
//     data['uploadVideo'] = this.uploadVideo;
//     data['isVideo'] = this.isVideo;
//     data['type'] = this.type;
//     return data;
//   }
// }
class GetStoryModel {
  List<Data_story>? data;
  bool? error;
  String? statusCode;
  String? message;

  GetStoryModel({this.data, this.error, this.statusCode, this.message});

  GetStoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_story>[];
      json['data'].forEach((v) {
        data!.add(new Data_story.fromJson(v));
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

class Data_story {
  String? stID;
  String? fullName;
  String? userName;
  String? image;
  String? title;
  String? isVideo;
  String? dateTime;
  User? user;
  List<Storys>? storys;

  Data_story(
      {this.stID,
        this.fullName,
        this.userName,
        this.image,
        this.title,
        this.isVideo,
        this.dateTime,
        this.user,
        this.storys});

  Data_story.fromJson(Map<String, dynamic> json) {
    stID = json['stID'];
    fullName = json['fullName'];
    userName = json['userName'];
    image = json['image'];
    title = json['title'];
    isVideo = json['isVideo'];
    dateTime = json['dateTime'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['storys'] != null) {
      storys = <Storys>[];
      json['storys'].forEach((v) {
        storys!.add(new Storys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stID'] = this.stID;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['image'] = this.image;
    data['title'] = this.title;
    data['isVideo'] = this.isVideo;
    data['dateTime'] = this.dateTime;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.storys != null) {
      data['storys'] = this.storys!.map((v) => v.toJson()).toList();
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

class Storys {
  String? stID;
  String? userId;
  String? stoID;
  String? storyPhoto;
  String? uploadVideo;
  String? isVideo;
  String? viewCount;
  String? dateTime;
  String? type;

  Storys(
      {this.stID,
        this.userId,
        this.stoID,
        this.storyPhoto,
        this.uploadVideo,
        this.isVideo,
        this.viewCount,
        this.dateTime,
        this.type});

  Storys.fromJson(Map<String, dynamic> json) {
    stID = json['stID'];
    userId = json['userId'];
    stoID = json['stoID'];
    storyPhoto = json['story_photo'];
    uploadVideo = json['uploadVideo'];
    isVideo = json['isVideo'];
    viewCount = json['viewCount'];
    dateTime = json['dateTime'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stID'] = this.stID;
    data['userId'] = this.userId;
    data['stoID'] = this.stoID;
    data['story_photo'] = this.storyPhoto;
    data['uploadVideo'] = this.uploadVideo;
    data['isVideo'] = this.isVideo;
    data['viewCount'] = this.viewCount;
    data['dateTime'] = this.dateTime;
    data['type'] = this.type;
    return data;
  }
}