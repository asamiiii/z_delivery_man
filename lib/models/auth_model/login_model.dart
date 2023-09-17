class LoginModel {
  String? name;
  String? email;
  String? token;
  String? type;

  LoginModel({this.name, this.email, this.token, this.type});

  LoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['token'] = token;
    return data;
  }
}
