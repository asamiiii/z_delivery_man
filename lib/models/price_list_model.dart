import 'package:flutter/cupertino.dart';

List<PriceList> priceListFromJson(jsonData) {
  return List<PriceList>.from(jsonData.map((x) => PriceList.fromJson(x)));
}

class PriceList {
  int? id;
  String? name;
  String? icon;
  int? eTA;
  List<Categories>? categories;

  PriceList({this.id, this.name, this.icon, this.eTA, this.categories});

  PriceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    eTA = json['ETA'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['ETA'] = eTA;
    if (categories != null) {
      data['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? icon;
  List<Items?>? items;

  Categories({this.id, this.name, this.icon, this.items});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    if (items != null) {
      data['items'] = items?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? price;
  String? icon;
  int? categoryItemServiceId;
  int? selectedQuantity = 0;
  int? selectedQuantityFromOrder;
  bool? withDimension ;
  dynamic lenght;
  dynamic width;
  int? localId;
  TextEditingController? txtController = TextEditingController();

  Items(
      {this.id,
      this.name,
      this.price,
      this.icon,
      this.categoryItemServiceId,
      this.txtController,
      this.selectedQuantity,
      this.selectedQuantityFromOrder,
      this.withDimension,
      this.localId,
      this.lenght,
      this.width
      });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    price = json['price'] ?? '';
    icon = json['icon'] ;
    categoryItemServiceId = json['category_item_service_id'];
    withDimension = json['with_dimension'] ?? false;
    localId = 0;
    width = '0';
    lenght = '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['icon'] = icon;
    data['category_item_service_id'] = categoryItemServiceId;
    return data;
  }
}
