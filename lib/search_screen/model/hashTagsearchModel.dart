class HashTagSearchModel {
  List<Data>? data;
  bool? error;
  String? statusCode;
  String? message;

  HashTagSearchModel({this.data, this.error, this.statusCode, this.message});

  HashTagSearchModel.fromJson(Map<String, dynamic> json) {
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
  String? tagName;

  Data({this.id, this.tagName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tagName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tagName'] = this.tagName;
    return data;
  }
}