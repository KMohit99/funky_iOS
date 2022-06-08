class parentsOtpModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  parentsOtpModel({this.user, this.error, this.statusCode, this.message});

  parentsOtpModel.fromJson(Map<String, dynamic> json) {
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
  String? from;
  String? to;
  String? body;
  int? id;

  User({this.from, this.to, this.body, this.id});

  User.fromJson(Map<String, dynamic> json) {
    from = json['From'];
    to = json['To'];
    body = json['Body'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['From'] = this.from;
    data['To'] = this.to;
    data['Body'] = this.body;
    data['id'] = this.id;
    return data;
  }
}