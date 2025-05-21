import 'item_count.dart';
import 'order_count.dart';

class ProviderModel {
  String? providerName;
  int? providerId;
  OrderCount? orderCount;
  ItemCount? itemCount;

  ProviderModel({
    this.providerName,
    this.providerId,
    this.orderCount,
    this.itemCount,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        providerName: json['provider_name'] as String?,
        providerId: json['provider_id'] as int?,
        orderCount: json['order_count'] == null
            ? null
            : OrderCount.fromJson(json['order_count'] as Map<String, dynamic>),
        itemCount: json['item_count'] == null
            ? null
            : ItemCount.fromJson(json['item_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'provider_name': providerName,
        'provider_id': providerId,
        'order_count': orderCount?.toJson(),
        'item_count': itemCount?.toJson(),
      };
}
