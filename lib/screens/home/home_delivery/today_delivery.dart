import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/cubit.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_sates.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_screen.dart';
import 'package:z_delivery_man/screens/home/shared/shared_home_widgets.dart';

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
      builder: (context, state) => RefreshIndicator(
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
    );
  }
}