import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/screens/home/all.dart';
import 'package:z_delivery_man/screens/home/today.dart';

import '../../models/index_model.dart';
import '../../models/time_slots_model.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/widgets/components.dart';
import '../../shared/widgets/constants.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/with_safe_area.dart';
import '../../styles/color.dart';
import '../drawer/drawer.dart';
import '../pickup_details/pickup_details_screen.dart';
import '../provider_app/orders_list/orders_list_screen.dart';
import 'cubit.dart';
import 'home_sates.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDeliveryMan = false;
  String name = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDeliveryMan = CacheHelper.getData(key: 'type');
    name = CacheHelper.getData(key: 'name');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: isDeliveryMan
          ? (context) => HomeCubit()..getTimeSlots()
          : (context) => HomeCubit()..getStatusWithCount(),
      child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final homeCubit = HomeCubit.get(context);
            // final loginCubit = LoginCubit.get(context);
            return WithSafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: PageContainer(
                  child: Scaffold(
                    drawer: isDeliveryMan ? const BuildDrawer() : null,
                    appBar: AppBar(
                        title: Text(name), centerTitle: true, actions: []),
                    body: RefreshIndicator(
                      onRefresh: () => isDeliveryMan
                          ? homeCubit.getTimeSlots()
                          : homeCubit.getStatusWithCount(),
                      child: ConditionalBuilder(
                        condition: state is! HomeLoadingState &&
                            state is! HomeLoadingStatus,
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        builder: (context) => isDeliveryMan
                            ? ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 2.h,
                                    ),
                                itemCount: homeCubit.timeSlots?.length ?? 0,
                                itemBuilder: (context, index) {
                                  // if (isDeliveryMan) {
                                  return BuildCard(
                                      item: homeCubit.timeSlots?[index]);
                                  // } else {
                                  // return BuildProviderCard(
                                  //   item: homeCubit
                                  //       .indexModel?.statusModel?[index]!,
                                  //   cubit: homeCubit,
                                  // );

                                  //   return TableAll(model: homeCubit.indexModel,);
                                  // }
                                })
                            : Center(
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      TableToday(model: homeCubit.indexModel),
                                      const SizedBox(height: 20),
                                      TableAll(model: homeCubit.indexModel),
                                      const SizedBox(height: 20),
                                      InkWell(
                                        onTap: () => BlocProvider.of<HomeCubit>(
                                                context)
                                            .logout()
                                            .then((value) => signOut(context)),
                                        child: Container(
                                          width: 170,
                                          color: Colors.red,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(width: 20),
                                              Text(AppStrings.logOut),
                                              SizedBox(width: 10),
                                              Icon(Icons.exit_to_app),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class BuildCard extends StatelessWidget {
  const BuildCard({Key? key, this.item}) : super(key: key);
  final TimeSlotsModel? item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            PickUpDetails(
              timeSlotId: item?.id,
              fromPickup: item?.type == 1 ? true : false,
            ));
      },
      child: Container(
        height: 20.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 2.h),
        child: Card(
          elevation: 10,
          color: item?.type == 1
              ? Colors.deepOrange.shade50
              : Colors.blue.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item?.type == 1
                  ? Text(
                      AppStrings.receive,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      AppStrings.deliver,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${AppStrings.from} ${item?.from}",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${AppStrings.to} ${item?.to}",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '${AppStrings.ordersTotal} ${item?.count}',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class BuildProviderCard extends StatelessWidget {
//   const BuildProviderCard({Key? key, this.item, this.cubit}) : super(key: key);
//   final StatusModel? item;
//   final HomeCubit? cubit;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         navigateTo(
//             context,
//             OrdersListScreen(
//               statusName: item?.statusName,
//             ));
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
//         shape: const RoundedRectangleBorder(),
//         color: Colors.grey.shade200,
//         child: SizedBox(
//           height: 13.h,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 '${cubit?.handleStatusName(item?.statusName)}',
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 1.h,
//               ),
//               Text(
//                 '${AppStrings.ordersTotal} ${item?.count}',
//                 style: TextStyle(
//                     color: primaryColor,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
