class OrderPerStatusProvider {
  int? lastPage;
  List<Orders>? orders;

  OrderPerStatusProvider({this.lastPage, this.orders});

  OrderPerStatusProvider.fromJson(Map<String, dynamic> json) {
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
  Pick? pick;
  Pick? deliver;
  String? currentStatus;
  String? coreNextStatus;
  String? nextStatus;
  String? pickDeliveryMan;
  String? deliverDeliveryMan;

  Orders(
      {this.id,
      this.pick,
      this.deliver,
      this.currentStatus,
      this.coreNextStatus,
      this.nextStatus,
      this.deliverDeliveryMan,
      this.pickDeliveryMan
      });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pick = json['pick'] != null ? Pick.fromJson(json['pick']) : null;
    deliver = json['deliver'] != null ? Pick.fromJson(json['deliver']) : null;
    currentStatus = json['currentStatus'];
    coreNextStatus = json['core_nextStatus'];
    nextStatus = json['nextStatus'];
    deliverDeliveryMan = json['pick_delivery_man'];
    pickDeliveryMan = json['deliver_delivery_man'];
  }

  get customer => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (pick != null) {
      data['pick'] = pick?.toJson();
    }
    if (deliver != null) {
      data['deliver'] = deliver?.toJson();
    }
    data['currentStatus'] = currentStatus;
    data['core_nextStatus'] = coreNextStatus;
    data['nextStatus'] = nextStatus;
    return data;
  }
}

class Pick {
  String? date;
  String? from;
  String? to;

  Pick({this.date, this.from, this.to});

  Pick.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
