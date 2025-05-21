import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_cubit.dart';

class PickDeliverTimeWidget extends StatelessWidget {
  const PickDeliverTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<DMOrderDetailsCubit>();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.blue[200],
          border: Border.all(),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cubit.orderDetailsModel?.pick == null
              ? const Text("تاريخ الاستلام: لايوجد")
              : SmallText(
                  "تاريخ الاستلام: ${cubit.orderDetailsModel?.pick?.date}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('وقت الاستلام'),
              SmallText("من: ${cubit.orderDetailsModel?.pick?.from}"),
              SmallText("الي: ${cubit.orderDetailsModel?.pick?.to}")
            ],
          ),
          SmallText("تاريخ التسليم: ${cubit.orderDetailsModel?.deliver?.date}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('وقت التسليم'),
              SmallText("من: ${cubit.orderDetailsModel?.deliver?.from}"),
              SmallText("الي: ${cubit.orderDetailsModel?.deliver?.to}"),
            ],
          ),
          SizedBox(height: 1.h),
          SmallText(
              "الحالة الحالية: ${cubit.orderDetailsModel?.currentStatus}"),
        ],
      ),
    );
  }
}
