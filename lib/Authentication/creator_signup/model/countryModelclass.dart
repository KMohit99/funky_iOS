class countryModel {
  List<Data_country>? data;
  bool? error;
  String? statusCode;
  String? message;

  countryModel({this.data, this.error, this.statusCode, this.message});

  countryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_country>[];
      json['data'].forEach((v) {
        data!.add(new Data_country.fromJson(v));
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

class Data_country {
  String? id;
  String? location;

  Data_country({this.id, this.location});

  Data_country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    return data;
  }
}