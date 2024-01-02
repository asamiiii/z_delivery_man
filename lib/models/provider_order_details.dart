import 'package:z_delivery_man/models/order_details_model.dart';

class ProviderOrderDetails {
  int? id;
  int? customerCode;
  String? type;
  String? comment;
  Pick? pick;
  Pick? deliver;
  Comments? comments;
  Requests? requests;
  String? currentStatus;
  String? coreNextStatus;
  String? nextStatus;
  int? itemCount;
  String? pickComment;
  bool? associateItems;
  bool? associateImages;
  List<Items>? items;
  List<Images>? images;
  String? pickDeliveryMan;
  String? deliverDeliveryMan;
  List<String>? imagesUrl; //! imagesUrl

  ProviderOrderDetails(
      {this.id,
      this.customerCode,
      this.type,
      this.comment,
      this.pick,
      this.comments,
      this.requests,
      this.deliver,
      this.currentStatus,
      this.coreNextStatus,
      this.nextStatus,
      this.itemCount,
      this.pickComment,
      this.associateImages,
      this.associateItems,
      this.items,
      this.deliverDeliveryMan,
      this.pickDeliveryMan,
      this.imagesUrl //! imagesUrl  we need to add to from json
      });

  ProviderOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customer_code'] ?? 0;
    type = json['type'] ?? 'لايوجد';
    comment = json['comment'] ?? 'لايوجد';
    pick = json['pick'] != null ? Pick.fromJson(json['pick']) : null;
    comments =
        json['comments'] != null ? Comments.fromJson(json['comments']) : null;

    requests =
        json['requests'] != null ? Requests.fromJson(json['requests']) : null;
    deliver = json['deliver'] != null ? Pick.fromJson(json['deliver']) : null;
    currentStatus = json['current_status'];
    coreNextStatus = json['core_nextStatus'];
    nextStatus = json['nextStatus'];
    itemCount = json['item_count'];
    pickComment = json['pick_comment'] ?? 'لايوجد';
    associateItems = json['associateItems'];
    associateImages = json['associateImages'];
    deliverDeliveryMan = json['pick_delivery_man'];
    pickDeliveryMan = json['deliver_delivery_man'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['comment'] = comment;
    if (pick != null) {
      data['pick'] = pick?.toJson();
    }
    if (deliver != null) {
      data['deliver'] = deliver?.toJson();
    }
    data['current_status'] = currentStatus;
    data['core_nextStatus'] = coreNextStatus;
    data['nextStatus'] = nextStatus;
    data['item_count'] = itemCount;
    data['pick_comment'] = pickComment;
    if (items != null) {
      data['items'] = items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? normalComments;
  String? pickComment;
  String? toCustomComment;
  Comments({
    this.normalComments,
    this.pickComment,
    this.toCustomComment,
  });
  Comments.fromJson(Map<String, dynamic> json) {
    normalComments = json['normal_comment'] ?? 'لايوجد';
    pickComment = json['pick_comment'] ?? 'لايوجد';
    toCustomComment = json['to_customer_comment'] ?? 'لايوجد';
  }
}

class Requests {
  List<dynamic>? requests;

  Requests({
    this.requests,
  });
  Requests.fromJson(List<dynamic>? json) {
    requests = json ?? ['لايوجد'];
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

class Items {
  //!
  int? id;
  String? name;
  String? category;
  String? service;
  String? preference;
  int? categoryItemServiceId;
  String? icon;
  int? quantity;
  dynamic length;
  dynamic width;
  bool? withDimension;
  List<Items>? itemDetailes;
  dynamic totalMeters;
  // List<String>? imagesUrl; //! new value in the model

  Items(
      {this.id,
      this.name,
      this.category,
      this.service,
      this.preference,
      this.quantity,
      this.length,
      this.width,
      this.itemDetailes,
      this.withDimension,
      this.totalMeters,
      // this.imagesUrl
      });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    service = json['service'];
    preference = json['preference'];
    quantity = json['quantity'] ?? 0;
    length = json ['length'];
    width = json ['width'];
    totalMeters = json['total_meters'] ;
    withDimension = json ['with_dimension'] ?? false;
    categoryItemServiceId =json['category_item_service_id'] ?? 0;
    icon=json['icon'];
    // itemDetailes = json ['item_details'] ?? [];
    if (json['item_details'] != null) {
      itemDetailes = <Items>[];
      json['item_details'].forEach((v) {
        itemDetailes?.add(Items.fromJson(v));
      });
    }else{
      itemDetailes = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['category'] = category;
    data['service'] = service;
    data['preference'] = preference;
    data['quantity'] = quantity;
    return data;
  }
}

class Images {
  int? id;
  String? imagePath;

  Images({this.id, this.imagePath});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_path'] = imagePath;
    return data;
  }
}
