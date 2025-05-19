import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/models/time_slots_model.dart';
import 'package:z_delivery_man/screens/pickup_details/pickup_details_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';

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
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            item?.type == 1
                ? SmallText(
                    AppStrings.receive,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  )
                : SmallText(
                    AppStrings.deliver,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${AppStrings.from} ${item?.from}",
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Text(
                  "${AppStrings.to} ${item?.to}",
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
            Text(
              '${AppStrings.ordersTotal} ${item?.count}',
              style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3.h,
            ),
          ],
        ),
      ),
    );
  }
}