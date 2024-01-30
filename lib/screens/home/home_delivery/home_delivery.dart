import 'package:flutter/material.dart';
import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/home/home_delivery/all_delivery.dart';
import 'package:z_delivery_man/screens/home/home_delivery/today_delivery.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
            length: 2,
            child: WithSafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: PageContainer(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    // drawer: const BuildDrawer(),
                    appBar: deliveryHomeAppBar(deliveryManName:name ?? ''),
                    body: TabBarView(
                      children: [
                        DeliveryAll(),
                        DeliveryToday()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
  }








