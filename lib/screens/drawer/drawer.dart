// import 'package:conditional_builder/conditional_builder.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../shared/widgets/components.dart';
import '../../shared/widgets/constants.dart';
import '../../styles/color.dart';
import '../status_orders/status_orders_screen.dart';
import 'cubit.dart';
import 'drawer_states.dart';

class BuildDrawer extends StatefulWidget {
  const BuildDrawer({Key? key}) : super(key: key);

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  @override
  void initState() {
    final drawerCubit = DrawerCubit.get(context);
    drawerCubit.getStatusOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawerCubit, DrawerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final drawerCubit = DrawerCubit.get(context);
        return Container(
            color: HexColor('#F9F9F9'),
            child: Drawer(
              elevation: 10,
              child: SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'حالات الاوردر',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'اليوم',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            ConditionalBuilder(
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
                              builder: (context) => ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: drawerCubit
                                    .statusOrderModel!.statuses!.today!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: HexColor('#ECEEF8')),
                                    child: ListTile(
                                      title: Text(
                                        '${drawerCubit.statusOrderModel?.statuses?.today?[index].translate}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: CircleAvatar(
                                        child: Text(
                                            '${drawerCubit.statusOrderModel?.statuses?.today?[index].count}'),
                                      ),
                                      onTap: () {
                                        navigateAndReplace(
                                            context,
                                            OrderPerStatusScreen(
                                              status: drawerCubit
                                                  .statusOrderModel
                                                  ?.statuses
                                                  ?.today![index]
                                                  .status,
                                              isAll: 0,
                                            ));
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 2.h,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'الكل ',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            ConditionalBuilder(
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
                              builder: (context) => ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: drawerCubit
                                    .statusOrderModel!.statuses!.all!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: HexColor('#ECEEF8')),
                                    child: ListTile(
                                      title: Text(
                                        drawerCubit.statusOrderModel!.statuses!
                                                .all?[index].translate ??
                                            '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: CircleAvatar(
                                        child: Text(
                                            '${drawerCubit.statusOrderModel?.statuses?.all?[index].count}'),
                                      ),
                                      onTap: () {
                                        navigateAndReplace(
                                            context,
                                            OrderPerStatusScreen(
                                              status: drawerCubit
                                                  .statusOrderModel
                                                  ?.statuses
                                                  ?.all?[index]
                                                  .status,
                                              isAll: 1,
                                            ));
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 20,
                                  );
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () => signOut(context),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'تسجيل الخروج',
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
