List<OrdersPerTimeSlotModel> orederPerTimeSlotsFromJson(jsonData) {
  return List<OrdersPerTimeSlotModel>.from(
      jsonData.map((x) => OrdersPerTimeSlotModel.fromJson(x)));
}

class OrdersPerTimeSlotModel {
  int? id;
  String? total;
  String? zone;
  String? currentStatus;
  String? nextStatus;
  bool? canCollect;
  String? coreNextStatus;
  String? provider;
  Customer? customer;
  Address? address;

  OrdersPerTimeSlotModel(
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

  OrdersPerTimeSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    zone = json['zone'];
    currentStatus = json['currentStatus'];
    nextStatus = json['nextStatus'];
    canCollect = json['can_collect'];
    coreNextStatus = json['core_nextStatus'];

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
  double? long;
  double? lat;
  String? compound;

  Address({this.id, this.long, this.lat});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    long = json['long'];
    lat = json['lat'];
    compound = json['compound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['long'] = long;
    data['lat'] = lat;
    return data;
  }
}
