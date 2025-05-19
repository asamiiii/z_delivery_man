import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_cubit.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<DMOrderDetailsCubit>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SmallText(
            'تفاصيل الاوردر',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.blue[200],
              border: Border.all(),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              const SizedBox(height: 5),
              if (cubit.orderDetailsModel!.isReturn ?? false)
                Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  child: const SmallText(
                    'منتج مرتجع',
                    color: Colors.white,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText("عدد القطع: ${cubit.orderDetailsModel?.itemCount}"),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: cubit.orderDetailsModel?.services?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GFAccordion(
                            title:
                                'خدمة: ${cubit.orderDetailsModel?.services?[index].serviceName}',
                            contentChild: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cubit.orderDetailsModel!
                                    .services![index].categories!
                                    .map((e) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SmallText(
                                              '${e.categoryName}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Column(
                                              children: e.items!
                                                  .map(
                                                    (e) => Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SmallText(
                                                            '${e.quantity} x ${e.name}'),
                                                        SmallText(
                                                            '${e.price} جنيه'),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                            )
                                          ],
                                        ))
                                    .toList()),
                          ),
                          SizedBox(height: 2.h)
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 1.h),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText("القيمة"),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText("المجموع الفرعي:"),
                        SmallText(
                            "${cubit.orderDetailsModel?.cost?.subtotal}جنيه"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText("خصم:"),
                        SmallText(
                            "${cubit.orderDetailsModel?.cost?.discount}جنيه"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText("توصيل:"),
                        SmallText(
                            "${cubit.orderDetailsModel?.cost?.deliveryFees}جنيه"),
                      ],
                    ),
                    if (cubit.orderDetailsModel?.paymentMethod != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallText("طريقة الدفع:"),
                          SmallText(
                              "${cubit.orderDetailsModel?.paymentMethod}"),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText("المجموع:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SmallText(
                          "${cubit.orderDetailsModel?.cost?.total}جنيه",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (cubit.orderDetailsModel?.cost?.oldOrders != null)
                          const SmallText(
                            "طلبات سابقة لم يتم دفعها",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    if (cubit.orderDetailsModel?.cost?.oldOrders != null)
                      ...cubit.orderDetailsModel!.cost!.oldOrders!.map(
                        (e) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallText(
                                "ID : ${e.id}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SmallText(
                                "Total : ${e.total}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
