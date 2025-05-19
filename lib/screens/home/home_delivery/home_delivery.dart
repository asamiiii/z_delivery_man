import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/core/global_cubit/global_cubit.dart';
import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/home/home_delivery/all_delivery.dart';
import 'package:z_delivery_man/screens/home/home_delivery/instruction_delivery.dart';
import 'package:z_delivery_man/screens/home/home_delivery/today_delivery.dart';
import 'package:z_delivery_man/screens/home/home_delivery/today_delivery_with_time_slots.dart';
import 'package:z_delivery_man/screens/home/home_delivery/widgets.dart';
import 'package:z_delivery_man/shared/widgets/page_container.dart';
import 'package:z_delivery_man/shared/widgets/with_safe_area.dart';

class HomeDelivery extends StatefulWidget {
  const HomeDelivery({Key? key}) : super(key: key);

  @override
  State<HomeDelivery> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeDelivery> {
  bool isDeliveryMan = false;
  String? name = '';
  bool isToday = true;
  bool isTodayDelivery = true;
  @override
  void initState() {
    super.initState();
    isDeliveryMan = CacheHelper.getData(key: 'type');
    name = CacheHelper.getData(key: 'name');
    context.read<GlobalCubit>().startUpdateLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: WithSafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PageContainer(
            child: Scaffold(
              backgroundColor: Colors.white,
              // drawer: const BuildDrawer(),
              appBar:
                  deliveryHomeAppBar(deliveryManName: name ?? '', ctx: context),
              body: TabBarView(
                children: [
                  DeliveryAll(),
                  DeliveryToday(),
                  DeliveryTodayWithTimeSlots(), //! الفترات
                  InstructionsDelivery()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
