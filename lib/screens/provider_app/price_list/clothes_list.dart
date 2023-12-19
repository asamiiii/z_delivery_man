import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/models/price_list_model.dart';

import '../../../shared/widgets/price_list_system_order.dart';
import '../../order_details/cubit.dart';
import '../../order_details/order_details_state.dart';

class ClothesListWithPrice extends StatefulWidget {
  final int? index;
  final bool? isSearch;
  final List<Items>? itemsInOrder;
   ClothesListWithPrice({Key? key, this.index, this.isSearch,this.itemsInOrder})
      : super(key: key);

  @override
  _ClothesListWithPriceState createState() => _ClothesListWithPriceState();
}

class _ClothesListWithPriceState extends State<ClothesListWithPrice> {
  @override
  Widget build(BuildContext context) {
    int indexList = 0;
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = OrderDetailsCubit.get(context);

        return Expanded(
            child: ListView.separated(
                itemBuilder: (_, index) {
                  return PriceListSystemOrder(
                    index: index,
                    item: cubit.searchPriceList!.isEmpty
                        ? cubit.itemList![index]
                        : cubit.searchPriceList![index],
                    indexList: indexList,
                    // showPrice: widget.showPrice,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: cubit.searchPriceList!.isEmpty
                    ? cubit.itemList!.length
                    : cubit.searchPriceList!.length));
      },
    );
  }
}
