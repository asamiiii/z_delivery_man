import 'dart:convert';

PreferenceModel preferenceModelFromJson(String str) =>
    PreferenceModel.fromJson(json.decode(str));

String preferenceModelToJson(PreferenceModel data) =>
    json.encode(data.toJson());

class PreferenceModel {
  PreferenceModel({
    required this.id,
    required this.name,
    required this.items,
  });

  int id;
  String name;
  List<Item> items;

  factory PreferenceModel.fromJson(Map<String, dynamic> json) =>
      PreferenceModel(
        id: json["id"],
        name: json["name"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item(
      {required this.id,
      required this.name,
      required this.category,
      required this.categoryItemServiceId,
      required this.icon,
      required this.catIcon
      // this.icon,
      });

  int? id;
  String? name;
  String? icon;
  int? categoryItemServiceId;
  String? category;
  String catIcon;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["item_id"],
      name: json["name"],
      category: json["category"],
      catIcon: json["category_icon"],
      categoryItemServiceId: json["category_service_item_id"],
      icon: json["icon"] ?? ''
      // icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "icon": icon,
      };
}
