import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/models/provider_order_details.dart';
import 'package:z_delivery_man/screens/order_details/cubit.dart';
//! End  Here 
List<Items> addOrdersFromOrderDetailesToCart(BuildContext context, int itemId) {
  debugPrint('itemId: $itemId');
  List<Items> listOfItems = [];
  var cubit = context.read<OrderDetailsCubit>();
  if (cubit.providerOrderDetails?.items != null) {
    for (int i = 0; i < cubit.providerOrderDetails!.items!.length; i++) {
      if (cubit.providerOrderDetails?.items![i].id == itemId) {
        listOfItems
            .addAll(cubit.providerOrderDetails?.items![i].itemDetailes ?? []);
      }
    }
  }
  debugPrint('List: $listOfItems');
  return listOfItems;
}
