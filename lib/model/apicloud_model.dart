class ApiCloudModel {
  String? status;
  Data? data;

  ApiCloudModel({this.status, this.data});

  ApiCloudModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? translatedText;

  Data({this.translatedText});

  Data.fromJson(Map<String, dynamic> json) {
    translatedText = json['translatedText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['translatedText'] = this.translatedText;
    return data;
  }
}
