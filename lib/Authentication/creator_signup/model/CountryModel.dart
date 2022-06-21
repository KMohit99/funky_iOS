class CountryModel {
  List<CountryList>? countryList;

  CountryModel({this.countryList});

  CountryModel.fromJson(Map<String, dynamic> json) {
    if (json['countryList'] != null) {
      countryList = <CountryList>[];
      json['countryList'].forEach((v) {
        countryList!.add(new CountryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countryList != null) {
      data['countryList'] = this.countryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryList {
  String? name;
  String? dialCode;
  String? code;

  CountryList({this.name, this.dialCode, this.code});

  CountryList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    return data;
  }
}