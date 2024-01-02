import 'package:z_delivery_man/models/provider_order_details.dart';

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
  int? customerCode;
  int? itemsCount;
  String? serviceType;
  Pick? pick;
  Pick? deliver;
  String? currentStatus;
  String? coreNextStatus;
  String? nextStatus;
  String? pickDeliveryMan;
  String? deliverDeliveryMan;
  List<Items>? prefrences;
  Comments? comments;
  

  Orders(
      {this.id,
      this.customerCode,
      this.itemsCount,
      this.serviceType,
      this.pick,
      this.deliver,
      this.currentStatus,
      this.coreNextStatus,
      this.nextStatus,
      this.deliverDeliveryMan,
      this.pickDeliveryMan,
      this.prefrences,
      this.comments
      });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customer_code'];
    itemsCount = json['item_count'];
    serviceType = json['service'];
    pick = json['pick'] != null ? Pick.fromJson(json['pick']) : null;
    deliver = json['deliver'] != null ? Pick.fromJson(json['deliver']) : null;
    currentStatus = json['currentStatus'];
    coreNextStatus = json['core_nextStatus'];
    nextStatus = json['nextStatus'];
    deliverDeliveryMan = json['pick_delivery_man'];
    pickDeliveryMan = json['deliver_delivery_man'];
   
    if (json['items'] != null) {
      prefrences = <Items>[];
      json['items'].forEach((v) {
        prefrences?.add(Items.fromJson(v));
      });
    }else{
      prefrences = [];
    }
     comments =json['comments'] != null ? Comments.fromJson(json['comments']) : null;
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

class Comments {
  String? customerComment;
  String? pickComment;
  List<Requests>? requests;

  Comments({this.customerComment, this.pickComment, this.requests});

  Comments.fromJson(Map<String, dynamic> json) {
    customerComment = json['customer_comment']??'لا يوجد تعليق متاح';
    pickComment = json['pick_comment']??'لا يوجد تعليق متاح';
    if (json['requests'] != null) {
      requests = <Requests>[];
      json['requests'].forEach((v) {
        requests!.add(Requests.fromJson(v));
      });
    }
  }
}

class Requests {
  String? type;
  String? comment;

  Requests({this.type, this.comment});

  Requests.fromJson(Map<String, dynamic> json) {
    type = json['type']??'لا يوجد بيانات متوفره حاليا';
    comment = json['comment']??'لا يوجد بيانات متوفره حاليا';
  }
}
