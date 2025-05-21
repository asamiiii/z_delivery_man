class HomeProviderModel {
  List<Today>? today;
  List<All>? all;

  HomeProviderModel({this.today, this.all});

  HomeProviderModel.fromJson(Map<String, dynamic> json) {
    today = json["Today"] == null
        ? null
        : (json["Today"] as List).map((e) => Today.fromJson(e)).toList();
    all = json["All"] == null
        ? null
        : (json["All"] as List).map((e) => All.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (today != null) {
      _data["Today"] = today?.map((e) => e.toJson()).toList();
    }
    if (all != null) {
      _data["All"] = all?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class All {
  String? status;
  String? statusName;
  int? orderCount;
  int? itemCount;
  String? filter;

  All({this.status, this.statusName, this.orderCount, this.itemCount});

  All.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusName = json["status_name"];
    orderCount = (json["order_count"] as num).toInt();
    itemCount = (json["item_count"] as num).toInt();
    filter = json["filter"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["status_name"] = statusName;
    _data["order_count"] = orderCount;
    _data["item_count"] = itemCount;
    _data["filter"] = filter;
    return _data;
  }
}

class Today {
  String? status;
  String? statusName;
  int? orderCount;
  int? itemCount;
  String? filter;

  Today({this.status, this.statusName, this.orderCount, this.itemCount});

  Today.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusName = json["status_name"];
    orderCount = (json["order_count"] as num).toInt();
    itemCount = (json["item_count"] as num).toInt();
    filter = json["filter"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["status_name"] = statusName;
    _data["order_count"] = orderCount;
    _data["item_count"] = itemCount;
    _data["filter"] = filter;
    return _data;
  }
}
