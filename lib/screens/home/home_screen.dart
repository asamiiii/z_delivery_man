import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/screens/home/all.dart';
import 'package:z_delivery_man/screens/home/today.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';
import '../../models/time_slots_model.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/widgets/components.dart';
import '../../shared/widgets/page_container.dart';
import '../../shared/widgets/with_safe_area.dart';
import '../../styles/color.dart';
import '../drawer/drawer.dart';
import '../pickup_details/pickup_details_screen.dart';
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
  bool isToday = true;
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
                    backgroundColor: Colors.white,
                    drawer: isDeliveryMan ? const BuildDrawer() : null,
                    appBar: AppBar(
                        title: Text(
                          name,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                          ),
                        ),
                        centerTitle: true,
                        actions: [
                          const SizedBox(
                            width: 15,
                          ),
                          isDeliveryMan == false
                              ? DropdownButton<String>(
                                  iconDisabledColor: Colors.white,
                                  iconEnabledColor: Colors.white,
                                  autofocus: true,
                                  hint: Text(isToday == true ? 'اليوم' : 'الكل',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                      )),
                                  items: <String>['اليوم', 'الكل', 'الخروج']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      // enabled: false,
                                      value: value,
                                      child: Text(
                                        value,
                                        style: GoogleFonts.cairo(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value == 'اليوم') {
                                      isToday = true;
                                    } else if (value == 'الكل') {
                                      isToday = false;
                                    } else {
                                      showAreYouSureDialoge(
                                          context: context,
                                          yesFun: () {
                                            signOut(context);
                                          },
                                          noFun: () {
                                            Navigator.of(context).pop();
                                          });
                                    }
                                    setState(() {});
                                  },
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 15,
                          ),
                        ]),
                    body: WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: RefreshIndicator(
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
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
                              : AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 1000),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: isToday == true
                                      ? TableToday(model: homeCubit.indexModel)
                                      : TableAll(model: homeCubit.indexModel),
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
