import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';
import 'package:z_delivery_man/screens/order_details/cubit.dart';
import 'package:z_delivery_man/styles/color.dart';

class CustomerDetailsWidget extends StatelessWidget {
  const CustomerDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<OrderDetailsCubit>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SmallText('تفاصيل العميل',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.blue[200],
              border: Border.all(),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 90.w,
                    child: SmallText(
                      "اسم العميل: ${cubit.orderDetailsModel?.customer?.name}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SmallText(
                      "كود العميل: ${cubit.orderDetailsModel?.customer?.customerId}"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cubit.orderDetailsModel?.provider != null
                      ? SmallText(
                          "المغسلة: ${cubit.orderDetailsModel?.provider}")
                      : const SmallText("المغسلة: لايوجد"),
                  SmallText(
                      "نوع الخدمه : ${cubit.orderDetailsModel?.service}"),
                  InkWell(
                    onTap: () => launch(
                        "tel:${cubit.orderDetailsModel?.customer?.mobile}"),
                    child: SmallText(
                      "رقم العميل: ${cubit.orderDetailsModel?.customer?.mobile}",
                      color: primaryColor,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SmallText(
                          "العنوان: ${cubit.orderDetailsModel?.address?.title}"),
                      SmallText(
                          "الكمباوند: ${cubit.orderDetailsModel?.address?.compound}"),
                    ],
                  ),
                  SmallText(
                      "شارع: ${cubit.orderDetailsModel?.address?.street}"),
                  SmallText(
                      "عمارة: ${cubit.orderDetailsModel?.address?.building}"),
                  SmallText(
                      "الدور: ${cubit.orderDetailsModel?.address?.floor}"),
                  SmallText(
                      "الشقة: ${cubit.orderDetailsModel?.address?.flat}"),
                  InkWell(
                      onTap: () async {
                        if (await MapLauncher.isMapAvailable(MapType.google) ??
                            true) {
                          await MapLauncher.showMarker(
                            mapType: MapType.google,
                            coords: Coords(
                                cubit.orderDetailsModel?.address?.lat ?? 0,
                                cubit.orderDetailsModel?.address?.long ?? 0),
                            title: "عنوان العميل",
                          );
                        }
                      },
                      child: SmallText(
                        'الي العنوان',
                        color: primaryColor,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 16),
                  if (cubit.orderDetailsModel?.newCustomerWithBag == true)
                    const SmallText(
                      'يجب تسليم شنطه للعميل',
                      style:  TextStyle(backgroundColor: Colors.green),
                      color: Colors.white,
                    )
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ],
    );
  }
}
