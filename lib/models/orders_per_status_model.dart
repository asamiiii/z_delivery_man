class OrdersPerStatusModel {
  int? lastPage;
  List<Orders>? orders;

  OrdersPerStatusModel({this.lastPage, this.orders});

  OrdersPerStatusModel.fromJson(Map<String, dynamic> json) {
    lastPage = json['last_page'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders?.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last_page'] = lastPage;
    if (orders != null) {
      data['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? total;
  String? zone;
  String? currentStatus;
  String? coreNextStatus;
  String? nextStatus;
  bool? canCollect;
  String? provider;
  Customer? customer;
  Address? address;

  Orders(
      {this.id,
      this.total,
      this.zone,
      this.currentStatus,
      this.coreNextStatus,
      this.nextStatus,
      this.canCollect,
      this.provider,
      this.customer,
      this.address});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    zone = json['zone'];
    currentStatus = json['currentStatus'];
    coreNextStatus = json['core_nextStatus'];
    nextStatus = json['nextStatus'];
    canCollect = json['can_collect'];
    provider = json['provider'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total'] = total;
    data['zone'] = zone;
    data['currentStatus'] = currentStatus;
    data['core_nextStatus'] = coreNextStatus;
    data['nextStatus'] = nextStatus;
    data['can_collect'] = canCollect;
    data['provider'] = provider;
    if (customer != null) {
      data['customer'] = customer?.toJson();
    }
    if (address != null) {
      data['address'] = address?.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? mobile;

  Customer({this.id, this.name, this.mobile});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    return data;
  }
}

class Address {
  int? id;
  String? compound;
  double? long;
  double? lat;

  Address({this.id, this.compound, this.long, this.lat});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    compound = json['compound'] ?? "";
    long = json['long'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['compound'] = compound;
    data['long'] = long;
    data['lat'] = lat;
    return data;
  }
}
