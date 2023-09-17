class SuccessModel {
  bool? status;
  List<Errors>? errors;

  SuccessModel({required this.status, required this.errors});

  SuccessModel.fromJson(dynamic json) {
    if (json['status'] != null) {
      status = json['status'];
    }
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}

class Errors {
  List<String>? itemCount;

  Errors({this.itemCount});

  Errors.fromJson(Map<String, dynamic> json) {
    itemCount = json['item_count'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_count'] = itemCount;
    return data;
  }
}
