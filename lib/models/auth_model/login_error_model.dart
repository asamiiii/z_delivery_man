// ignore_for_file: deprecated_member_use

class LoginErrorModel {
  List<Errors>? errors;

  LoginErrorModel({this.errors});

  LoginErrorModel.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errors != null) {
      data['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  List<String>? email;
  List<String>? password;
  List<String>? deviceName;
  List<String>? fcmToken;

  Errors({this.email, this.password, this.deviceName, this.fcmToken});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
    password = json['password'].cast<String>();
    deviceName = json['device_name'].cast<String>();
    fcmToken = json['fcm_token'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['device_name'] = deviceName;
    data['fcm_token'] = fcmToken;
    return data;
  }
}
