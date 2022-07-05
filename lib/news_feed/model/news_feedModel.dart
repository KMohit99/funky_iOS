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
  String? newsID;
  String? logo;
  String? userName;
  String? fullName;
  String? title;
  String? image;
  String? tagLine;
  String? address;
  String? postImage;
  String? uploadVideo;
  String? isVideo;
  String? feedlikeStatus;
  String? feedLikeCount;
  String? feedCount;
  String? description;
  String? createdDate;

  Data(
      {this.newsID,
        this.logo,
        this.userName,
        this.fullName,
        this.title,
        this.image,
        this.tagLine,
        this.address,
        this.postImage,
        this.uploadVideo,
        this.isVideo,
        this.feedlikeStatus,
        this.feedLikeCount,
        this.feedCount,
        this.description,
        this.createdDate});

  Data.fromJson(Map<String, dynamic> json) {
    newsID = json['newsID'];
    logo = json['logo'];
    userName = json['userName'];
    fullName = json['fullName'];
    title = json['title'];
    image = json['image'];
    tagLine = json['tagLine'];
    address = json['address'];
    postImage = json['postImage'];
    uploadVideo = json['uploadVideo'];
    isVideo = json['isVideo'];
    feedlikeStatus = json['feedlikeStatus'];
    feedLikeCount = json['feedLike_count'];
    feedCount = json['feedCount'];
    description = json['description'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsID'] = this.newsID;
    data['logo'] = this.logo;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['title'] = this.title;
    data['image'] = this.image;
    data['tagLine'] = this.tagLine;
    data['address'] = this.address;
    data['postImage'] = this.postImage;
    data['uploadVideo'] = this.uploadVideo;
    data['isVideo'] = this.isVideo;
    data['feedlikeStatus'] = this.feedlikeStatus;
    data['feedLike_count'] = this.feedLikeCount;
    data['feedCount'] = this.feedCount;
    data['description'] = this.description;
    data['createdDate'] = this.createdDate;
    return data;
  }
}