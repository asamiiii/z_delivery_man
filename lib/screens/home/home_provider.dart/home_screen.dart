import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/all.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/today.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/widgets.dart';
import 'package:z_delivery_man/screens/home/shared/shared_home_widgets.dart';
import 'package:z_delivery_man/shared/widgets/page_container.dart';
import 'package:z_delivery_man/shared/widgets/with_safe_area.dart';
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
                    // drawer: isDeliveryMan ? const BuildDrawer() : null,
                    appBar: providerAppBar(providerName: name, ctx: context,cubit: homeCubit),
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
                                    return  BuildCard(
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
                                  child: homeCubit.isToday == true
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

