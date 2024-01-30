import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/screens/drawer/cubit.dart';
import 'package:z_delivery_man/screens/drawer/drawer_states.dart';
import 'package:z_delivery_man/screens/home/home_delivery/helpers.dart';
import 'package:z_delivery_man/screens/home/home_delivery/widgets.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/today.dart';
import 'package:z_delivery_man/screens/status_orders/status_orders_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
// opened --> total order or Itemcount
// providerAssigned --> لم يتم استلامه
// provider_received --> تم استلامه
// check_up --> تم الفحص
// finished -- > تم الانتهاء
// from_provider --> تم التسليم للمندوب
// remaining --> المتبقي today only

// ignore: must_be_immutable
class DeliveryAll extends StatefulWidget {
  // IndexModel? model;
  DeliveryAll({
    Key? key,
  }) : super(key: key);

  @override
  State<DeliveryAll> createState() => _DeliveryAllState();
}

class _DeliveryAllState extends State<DeliveryAll> {
  DrawerCubit? drawerCubit;
  @override
  void initState() {
    drawerCubit = DrawerCubit.get(context);
    drawerCubit?.getStatusOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final drawerCubit = DrawerCubit.get(context);
    return RefreshIndicator(
      onRefresh: () async {
        drawerCubit?.getStatusOrder();
      },
      child: BlocConsumer<DrawerCubit, DrawerStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
          condition: state is! DrawerGetStatusOrdersLoadingState,
          fallback: (context) => const DeliveryHomeShimmer(),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
              ),
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: drawerCubit?.statusOrderModel!.statuses!.all!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    navigateTo(
                        context,
                        OrderPerStatusScreen(
                          ststusString: drawerCubit!.statusOrderModel?.statuses
                              ?.all![index].translate,
                          status: drawerCubit!
                              .statusOrderModel?.statuses?.all![index].status,
                          isAll: 1,
                        ));
                  },
                  child: Item(
                      isdelivery: true,
                      chocoItem: ItemModel(
                          label: drawerCubit!.statusOrderModel?.statuses
                              ?.all?[index].translate,
                          itemCount: '',
                          orderCount:
                              '${drawerCubit!.statusOrderModel?.statuses?.all?[index].count}',
                          image: HomeDeliveryHelpers.assetsImage(
                              status: drawerCubit!.statusOrderModel?.statuses
                                  ?.all![index].status))),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
