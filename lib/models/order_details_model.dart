
class OrderDetailsModel {
  List<Service>? services;
  dynamic itemCount;
  dynamic id;
  Address? address;
  Pick? pick;
  Pick? deliver;
  String? paymentMethod;
  String? provider;
  Cost? cost;
  String? currentStatus;
  String? nextStatus;
  bool? canCollect;
  String? coreNextStatus;
  Customer? customer;
  bool? newCustomer;
  bool? isReturn;

  OrderDetailsModel(
      {this.services,
      this.itemCount,
      this.id,
      this.address,
      this.pick,
      this.deliver,
      this.newCustomer,
      this.paymentMethod,
      this.provider,
      this.cost,
      this.canCollect,
      this.coreNextStatus,
      this.currentStatus,
      this.nextStatus});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> servicesMap = json['services'];
    services = [];
    if (servicesMap != null) {
      for (var element in servicesMap.entries) {
        services?.add(Service.fromJson(element));
      }
    }
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    currentStatus = json['currentStatus'];
    coreNextStatus = json['core_nextStatus'];
    nextStatus = json['nextStatus'];
    canCollect = json['can_collect'];
    if (json['new_customer'] != null) {
      newCustomer = json['new_customer'];
    } else {
      newCustomer = false;
    }
    if (json['is_return'] != null) {
      isReturn = json['is_return'];
    } else {
      isReturn = false;
    }

    // if (json['can_collect'] != null) {
    // } else {
    //   canCollect = false;
    // }

    itemCount = json['item_count'];
    id = json['id'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    pick = json['pick'] != null ? Pick.fromJson(json['pick']) : null;
    deliver = json['deliver'] != null ? Pick.fromJson(json['deliver']) : null;
    paymentMethod = json['payment_method'];
    provider = json['provider'];
    cost = json['cost'] != null ? Cost.fromJson(json['cost']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   // if (services != null) {
  //   //   data['services'] = services.toJson();
  //   // }
  //   data['item_count'] = itemCount;
  //   data['id'] = id;
  //   if (address != null) {
  //     data['address'] = address.toJson();
  //   }
  //   if (pick != null) {
  //     data['pick'] = pick.toJson();
  //   }
  //   if (deliver != null) {
  //     data['deliver'] = deliver.toJson();
  //   }
  //   data['payment_method'] = paymentMethod;
  //   data['provider'] = provider;
  //   if (cost != null) {
  //     data['cost'] = cost.toJson();
  //   }
  //   return data;
  // }
}

class Service {
  String? serviceName;
  List<Category>? categories;

  Service({this.serviceName, this.categories});

  Service.fromJson(MapEntry<String, dynamic> json) {
    serviceName = json.key;
    categories = [];
    Map<String, dynamic> categoriesJson = json.value;
    if (categoriesJson != null) {
      for (var element in categoriesJson.entries) {
        categories?.add(Category.fromJson(element));
      }
    }

    // for (var cat in categoriesJson) {
    //   categories.add(Category.fromJson(cat));
    // }
  }
}

class Customer {
  dynamic id;
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

class Category {
  String? categoryName;
  List<Itemss>? items;

  List<Men>? men;
  List<Kids>? kids;
  List<Women>? women;
  List<Home>? home;

  Category({this.men, this.kids, this.home, this.women});

  Category.fromJson(MapEntry<String, dynamic> json) {
    categoryName = json.key;
    items = [];
    List<dynamic> jsonItems = json.value;
    for (var item in jsonItems) {
      items?.add(Itemss.fromJson(item));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (men != null) {
      data['Men'] = men?.map((v) => v.toJson()).toList();
    }
    if (kids != null) {
      data['Kids'] = kids?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Itemss {
  String? name;
  dynamic quantity;
  dynamic price;

  Itemss({this.name, this.quantity, this.price});

  Itemss.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   if (men != null) {
  //     data['Men'] = men.map((v) => v.toJson()).toList();
  //   }
  //   if (kids != null) {
  //     data['Kids'] = kids.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Textiles {
  List<Home>? home;

  Textiles({this.home});

  Textiles.fromJson(Map<String, dynamic> json) {
    if (json['Home'] != null) {
      home = <Home>[];
      json['Home'].forEach((v) {
        home?.add(Home.fromJson(v));
      });
    }
  }
}

class Men {
  String? name;
  dynamic quantity;
  dynamic price;

  Men({this.name, this.quantity, this.price});

  Men.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class Women {
  String? name;
  dynamic quantity;
  dynamic price;

  Women({this.name, this.quantity, this.price});

  Women.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class Home {
  String? name;
  dynamic quantity;
  dynamic price;

  Home({this.name, this.quantity, this.price});

  Home.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class Kids {
  String? name;
  dynamic quantity;
  dynamic price;

  Kids({this.name, this.quantity, this.price});

  Kids.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class Address {
  dynamic id;
  dynamic customerId;
  String? title;
  String? street;
  String? flat;
  String? floor;
  double? long;
  double? lat;
  String? compound;
  String? building;

  Address(
      {this.id,
      this.customerId,
      this.title,
      this.street,
      this.flat,
      this.floor,
      this.long,
      this.building,
      this.lat});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    title = json['title'] ?? "";
    street = json['street'] ?? "";
    flat = json['flat'] ?? "";
    floor = json['floor'] ?? "";
    long = json['long'];
    lat = json['lat'];
    compound = json['compound'] ?? "";
    building = json['building'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['title'] = title;
    data['street'] = street;
    data['flat'] = flat;
    data['floor'] = floor;
    data['long'] = long;
    data['lat'] = lat;
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

class Cost {
  String? deliveryFees;
  dynamic discount;
  dynamic subtotal;
  String? total;

  Cost({this.deliveryFees, this.discount, this.subtotal, this.total});

  Cost.fromJson(Map<String, dynamic> json) {
    deliveryFees = json['delivery_fees'];
    discount = json['discount'];
    subtotal = json['subtotal'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivery_fees'] = deliveryFees;
    data['discount'] = discount;
    data['subtotal'] = subtotal;
    data['total'] = total;
    return data;
  }
}
