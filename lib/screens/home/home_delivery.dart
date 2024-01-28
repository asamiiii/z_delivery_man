import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/drawer/cubit.dart';
import 'package:z_delivery_man/screens/drawer/drawer.dart';
import 'package:z_delivery_man/screens/drawer/drawer_states.dart';
import 'package:z_delivery_man/screens/home/cubit.dart';
import 'package:z_delivery_man/screens/home/home_sates.dart';
import 'package:z_delivery_man/screens/home/home_screen.dart';
import 'package:z_delivery_man/screens/home/today.dart';
import 'package:z_delivery_man/screens/status_orders/status_orders_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';
import 'package:z_delivery_man/shared/widgets/page_container.dart';
import 'package:z_delivery_man/shared/widgets/with_safe_area.dart';

class HomeDelivery extends StatefulWidget {
  const HomeDelivery({Key? key}) : super(key: key);

  @override
  State<HomeDelivery> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeDelivery> {
  bool isDeliveryMan = false;
  String name = '';
  bool isToday = true;
  bool isTodayDelivery = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDeliveryMan = CacheHelper.getData(key: 'type');
    name = CacheHelper.getData(key: 'name');
    // var drawerCubit = HomeCubit.get(context);
    final drawerCubit = DrawerCubit.get(context);
    drawerCubit.getStatusOrder();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawerCubit, DrawerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final drawerCubit = DrawerCubit.get(context);
          return DefaultTabController(
            length: 2,
            child: WithSafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: PageContainer(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    // drawer: const BuildDrawer(),
                    appBar: AppBar(
                      bottom: const TabBar(
                        labelColor: Colors.white,
                        // labelStyle: ,
                        unselectedLabelColor: Colors.white60,

                        tabs: [
                          Tab(
                            icon: Icon(Icons.delivery_dining),
                            text: 'الكل',
                          ),
                          Tab(
                            icon: Icon(Icons.directions_transit),
                            text: 'اليوم',
                          ),
                        ],
                      ),
                      title: Text(
                        name,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    body: TabBarView(
                      children: [
                        WillPopScope(
                          onWillPop: () async {
                            return false;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              final drawerCubit = DrawerCubit.get(context);
                              drawerCubit.getStatusOrder();
                            },
                            child: ConditionalBuilder(
                              condition:
                                  state is! DrawerGetStatusOrdersLoadingState,
                              fallback: (context) => ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 20,
                                ),
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (context, index) => SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white70,
                                    highlightColor: Colors.grey[200]!,
                                    direction: ShimmerDirection.ltr,
                                    child: const Card(
                                      color: Colors.grey,
                                      shape: RoundedRectangleBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(10),
                                child: GridView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 10,
                                  ),
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: drawerCubit
                                      .statusOrderModel!.statuses!.all!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            OrderPerStatusScreen(
                                              status: drawerCubit
                                                  .statusOrderModel
                                                  ?.statuses
                                                  ?.all![index]
                                                  .status,
                                              isAll: 1,
                                            ));
                                      },
                                      child: Item(
                                          isdelivery: true,
                                          chocoItem: ItemModel(
                                              label: drawerCubit
                                                  .statusOrderModel
                                                  ?.statuses
                                                  ?.all?[index]
                                                  .translate,
                                              itemCount: '',
                                              orderCount:
                                                  '${drawerCubit.statusOrderModel?.statuses?.all?[index].count}',
                                              image: assetsImage(
                                                  status: drawerCubit
                                                      .statusOrderModel
                                                      ?.statuses
                                                      ?.all![index]
                                                      .status))),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        DeliveryToday()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

//? Assign Status Image depends On Status Name
String assetsImage({required String? status}) {
  String imagePath = '';
  switch (status) {
    case 'delivery_man_assigned':
      imagePath = 'assets/images/new_order.png';
      break;
    default:
      imagePath = 'assets/images/R.png';
  }
  return imagePath;
}

class DeliveryToday extends StatefulWidget {
  DeliveryToday({Key? key}) : super(key: key);

  @override
  _DeliveryTodayState createState() => _DeliveryTodayState();
}

class _DeliveryTodayState extends State<DeliveryToday> {
  @override
  void initState() {
    var homeCubit = HomeCubit.get(context);
    homeCubit.getTimeSlots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeCubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => homeCubit.getTimeSlots(),
          child: Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 5),
            child: ConditionalBuilder(
                condition:
                    state is! HomeLoadingState && state is! HomeLoadingStatus,
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
                builder: (context) => ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(
                          height: 2.h,
                        ),
                    itemCount: homeCubit.timeSlots?.length ?? 0,
                    itemBuilder: (context, index) {
                      return BuildCard(item: homeCubit.timeSlots?[index]);
                    })),
          ),
        ),
      ),
    );
  }
}
