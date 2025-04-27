import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/models/order_per_status_provider.dart';
import 'package:z_delivery_man/models/provider_order_details.dart';
import 'package:z_delivery_man/screens/order_details/cubit.dart';
import 'package:z_delivery_man/screens/order_details/order_details_state.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/order_item_images_view.dart';
import 'package:z_delivery_man/screens/provider_app/price_list/meters_view.dart';
import 'package:z_delivery_man/screens/provider_app/price_list/widget.dart';
import 'package:z_delivery_man/shared/widgets/image_as_icon.dart';
import 'package:z_delivery_man/styles/color.dart';
import 'package:z_delivery_man/models/price_list_model.dart' as pitem;

class ProviderSection extends StatefulWidget {
  const ProviderSection(
      {Key? key,
      this.cubit,
      this.orderId,
      this.state,
      this.order,
      this.statusName})
      : super(key: key);
  final OrderDetailsCubit? cubit;
  final int? orderId;
  final OrderDetailsState? state;
  final Orders? order;
  final String? statusName;

  @override
  State<ProviderSection> createState() => _ProviderSectionState();
}

class _ProviderSectionState extends State<ProviderSection> {
  @override
  Widget build(BuildContext context) {
    var itemCountController = TextEditingController();
    var commentController = TextEditingController();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              border: Border.all(color: primaryColor, width: 3),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('وقت الاستلام'),
                  // SmallText("من: ${widget.cubit?.providerOrderDetails?.pick?.from}"),
                  
                  Text(
                    "الي: ${widget.cubit?.providerOrderDetails?.pick?.to}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Text(
                "تاريخ التسليم: ${widget.cubit?.providerOrderDetails?.deliver?.date}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('وقت التسليم'),
                  Text(
                    "من: ${widget.cubit?.providerOrderDetails?.deliver?.from}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الي: ${widget.cubit?.providerOrderDetails?.deliver?.to}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تفاصيل الاوردر",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "كود العميل : ${widget.cubit?.providerOrderDetails?.customerCode}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "الخدمة: ${widget.cubit?.providerOrderDetails?.type}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "تعليق الاستلام: ${widget.cubit?.providerOrderDetails?.comments?.pickComment}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "التعليق العميل ${widget.cubit?.providerOrderDetails?.comments?.normalComments}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "to custome comment: ${widget.cubit?.providerOrderDetails?.comments?.toCustomComment}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  widget.cubit?.providerOrderDetails?.pickDeliveryMan != null
                      ? Row(
                          children: [
                            Text('مندوب الاستلام : ',
                                style: TextStyle(fontSize: 14.sp)),
                            Text(
                                '${widget.cubit?.providerOrderDetails?.pickDeliveryMan}',
                                style: TextStyle(fontSize: 14.sp)),
                          ],
                        )
                      : const SizedBox(),
                  widget.cubit?.providerOrderDetails?.deliverDeliveryMan != null
                      ? Row(
                          children: [
                            Text(
                              'مندوب التوصيل : ',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            Text(
                                '${widget.cubit?.providerOrderDetails?.deliverDeliveryMan}',
                                style: TextStyle(fontSize: 14.sp)),
                          ],
                        )
                      : const SizedBox(),
                  Text(
                    "تفضيلات العميل:",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        widget.cubit!.providerOrderDetails!.requests!.requests!
                            .map(
                              (e) => Text(
                                "- $e",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                            .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "عدد القطع المستلمة: ${widget.cubit?.providerOrderDetails?.itemCount}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "عدد القطع التي تم فحصها: ${widget.cubit?.checkedNumberSum}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        TextEditingController costController =
                            TextEditingController();
                        List<String> dropDownList = ['A', 'B', 'C', 'D'];
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          // enableDrag: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              height: MediaQuery.of(context).size.height * 0.30,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text('اضافة تكلفه اضافيه',
                                      style: TextStyle(fontSize: 15.sp)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      DropdownButton<String>(
                                        items: dropDownList.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (_) {},
                                        hint: Text(dropDownList.first),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('نوع الخدمه',
                                          style: TextStyle(fontSize: 15.sp))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          // height: ,
                                          child: CustomTextField(
                                            onTap: () {},
                                            isMetersHW: true,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true, signed: true),
                                            onChange: (value) {},
                                            controller: costController,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text('     التكلفه',
                                          style: TextStyle(fontSize: 15.sp)),
                                    ],
                                  ),
                                  Expanded(
                                      child: const SizedBox(
                                    height: 50,
                                  )),
                                  CustomButton(
                                      onPrss: () {}, buttonTitle: 'حفظ'),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              )),
                        );
                      },
                      child: Text(
                        'اضافة تكلفه اضافيه +',
                        style: TextStyle(fontSize: 20.sp),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.cubit?.providerOrderDetails?.items !=
                              null
                          ? widget.cubit?.providerOrderDetails?.items?.length
                          : 0,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.blue[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GFAccordion(
                                contentBackgroundColor: Colors.blue[200],
                                title:
                                    'x${widget.cubit?.providerOrderDetails?.items?[index].serviceId == 200 ? '' : widget.cubit?.providerOrderDetails?.items?[index].quantity} ${widget.cubit?.providerOrderDetails?.items?[index].name}',
                                contentChild: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'الصنف: ${widget.cubit?.providerOrderDetails?.items?[index].category}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          TextButton(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.camera_alt_outlined),
                                                SizedBox(
                                                  width: 1.w,
                                                ),
                                                const Text('صور العنصر')
                                              ],
                                            ),
                                            onPressed: () {
                                              // widget.cubit?.remoteList.
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderItemImagesScreen(
                                                      serviceId: widget
                                                          .cubit
                                                          ?.providerOrderDetails
                                                          ?.items?[index]
                                                          .serviceId,
                                                      itemName: widget
                                                          .cubit
                                                          ?.providerOrderDetails
                                                          ?.items?[index]
                                                          .name,
                                                      statusName:
                                                          widget.statusName,
                                                      itemId: widget
                                                          .cubit
                                                          ?.providerOrderDetails
                                                          ?.items?[index]
                                                          .id,
                                                      orderId: widget.orderId,
                                                      images: widget
                                                          .cubit
                                                          ?.providerOrderDetails
                                                          ?.items?[index]
                                                          .imagesUrl,
                                                    ),
                                                  )).then((value) async {
                                                // widget
                                                //             .cubit
                                                //             ?.providerOrderDetails
                                                //             ?.items?[index].imagesUrl?.clear();
                                                await widget.cubit
                                                    ?.getProviderOrderDetails(
                                                        orderId:
                                                            widget.orderId);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'خدمة: ${widget.cubit?.providerOrderDetails?.items?[index].service}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp),
                                      ),
                                      widget.cubit?.providerOrderDetails
                                                  ?.items?[index].serviceId ==
                                              200
                                          ? const SizedBox()
                                          : Text(
                                              'التفضيلات: ${widget.cubit?.providerOrderDetails?.items?[index].preference}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp),
                                            ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          widget
                                                      .cubit
                                                      ?.providerOrderDetails
                                                      ?.items?[index]
                                                      .serviceId ==
                                                  200
                                              ? const SizedBox()
                                              : Text(
                                                  'العدد: ${widget.cubit?.providerOrderDetails?.items?[index].quantity}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp),
                                                ),
                                          // widget
                                          //             .cubit
                                          //             ?.providerOrderDetails
                                          //             ?.items?[index]
                                          //             .withDimension ==
                                          //         false
                                          //     ? Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment
                                          //                 .center,
                                          //         children: [
                                          //           InkWell(
                                          //             child: Padding(
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                       .all(8.0),
                                          //               child: FaIcon(
                                          //                 FontAwesomeIcons
                                          //                     .minus,
                                          //                 color: primaryColor,
                                          //                 size: 20,
                                          //               ),
                                          //             ),
                                          //             onTap: () {
                                          //               // setStatee(() {
                                          //               // addOrdersFromOrderDetailesToCart(context,widget
                                          //               //   .cubit
                                          //               //   ?.providerOrderDetails
                                          //               //   ?.items?[index].id ?? 0);
                                          //               widget
                                          //                   .cubit
                                          //                   ?.providerOrderDetails
                                          //                   ?.items?[index]
                                          //                   .quantity = (widget
                                          //                       .cubit
                                          //                       ?.providerOrderDetails
                                          //                       ?.items?[
                                          //                           index]
                                          //                       .quantity)! -
                                          //                   1;
                                          //               // });
                                          //               setState(() {});
                                          //             },
                                          //           ),
                                          //           SizedBox(
                                          //             width: 8.w,
                                          //           ),
                                          //           Text(
                                          //               '${widget.cubit?.providerOrderDetails?.items?[index].quantity}'),
                                          //           SizedBox(
                                          //             width: 8.w,
                                          //           ),
                                          //           InkWell(
                                          //             child: Padding(
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                       .all(8.0),
                                          //               child: FaIcon(
                                          //                 FontAwesomeIcons
                                          //                     .plus,
                                          //                 color: primaryColor,
                                          //                 size: 20,
                                          //               ),
                                          //             ),
                                          //             onTap: () {
                                          //               // setStatee(() {
                                          //               widget
                                          //                   .cubit
                                          //                   ?.providerOrderDetails
                                          //                   ?.items?[index]
                                          //                   .quantity = (widget
                                          //                       .cubit
                                          //                       ?.providerOrderDetails
                                          //                       ?.items?[
                                          //                           index]
                                          //                       .quantity)! +
                                          //                   1;
                                          //               // });
                                          //               setState(() {});
                                          //             },
                                          //           ),
                                          //         ],
                                          //       )
                                          //     : const SizedBox(),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      widget
                                                      .cubit
                                                      ?.providerOrderDetails
                                                      ?.items?[index]
                                                      .totalMeters !=
                                                  null &&
                                              widget
                                                      .cubit
                                                      ?.providerOrderDetails
                                                      ?.items?[index]
                                                      .withDimension ==
                                                  true
                                          ? Row(
                                              children: [
                                                const Text(
                                                  "اجمالي الامتار :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  " ${widget.cubit?.providerOrderDetails?.items?[index].totalMeters} ",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                const Text(
                                                  "متر مربع",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      if (widget
                                                  .cubit
                                                  ?.providerOrderDetails
                                                  ?.items?[index]
                                                  .itemDetailes !=
                                              [] &&
                                          widget
                                                  .cubit
                                                  ?.providerOrderDetails
                                                  ?.items?[index]
                                                  .withDimension ==
                                              true)
                                        ListView.builder(
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index3) {
                                            List<Items>? itemDetails = widget
                                                .cubit
                                                ?.providerOrderDetails
                                                ?.items?[index]
                                                .itemDetailes;
                                            return Row(
                                              children: [
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  '${itemDetails?[index3].quantity} x ${itemDetails?[index3].name}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${itemDetails?[index3].width}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                    const Text(
                                                      'x',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      '${itemDetails?[index3].length}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                          itemCount: widget
                                              .cubit
                                              ?.providerOrderDetails
                                              ?.items?[index]
                                              .itemDetailes
                                              ?.length,
                                        ),
                                      widget.statusName == 'check_up_all' ||
                                              widget.statusName == 'check_up' ||
                                              widget.statusName ==
                                                  'finished_all' ||
                                              widget.statusName == 'finished' ||
                                              widget.statusName ==
                                                  'from_provider_all' ||
                                              widget.statusName ==
                                                  'from_provider' ||
                                              widget.statusName ==
                                                  'opened_all' ||
                                              widget.statusName == 'opened' ||
                                              widget
                                                      .cubit
                                                      ?.providerOrderDetails
                                                      ?.items?[index]
                                                      .serviceId ==
                                                  200
                                          ? const SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // isDeliveryMan == true ||
                                                Builder(builder: (context) {
                                                  return ConditionalBuilder(
                                                      condition: widget.state
                                                          is! AssociateItemsUpdateLoading,
                                                      fallback: (context) =>
                                                          const Center(
                                                            child:
                                                                CupertinoActivityIndicator(),
                                                          ),
                                                      builder:
                                                          (context) =>
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  //  widget.cubit?.updateAssociateItems(itemId: widget.cubit?.providerOrderDetails?.items?[index].id, orderId: widget.orderId, quantity: widget.cubit?.providerOrderDetails?.items?[index].quantity);

                                                                  if (widget
                                                                          .cubit
                                                                          ?.providerOrderDetails
                                                                          ?.items?[
                                                                              index]
                                                                          .withDimension ==
                                                                      false) {
                                                                    showCupertinoDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            CupertinoAlertDialog(
                                                                              title: const Text('تعديل عدد القطعة'),
                                                                              content: StatefulBuilder(
                                                                                builder: (context, setStatee) {
                                                                                  return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
                                                                                      listener: (context, state) {},
                                                                                      builder: (contextt, state) {
                                                                                        final cubitt = OrderDetailsCubit.get(contextt);
                                                                                        debugPrint('quantity : ${cubitt.providerOrderDetails?.items?[index].quantity}');
                                                                                        return Card(
                                                                                          color: Colors.transparent,
                                                                                          elevation: 0.0,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              InkWell(
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: FaIcon(
                                                                                                    FontAwesomeIcons.minus,
                                                                                                    color: primaryColor,
                                                                                                    size: 20,
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  setStatee(() {
                                                                                                    cubitt.providerOrderDetails?.items?[index].quantity = (widget.cubit?.providerOrderDetails?.items?[index].quantity)! - 1;
                                                                                                  });
                                                                                                  setState(() {});
                                                                                                },
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 8.w,
                                                                                              ),
                                                                                              Text('${cubitt.providerOrderDetails?.items?[index].quantity}'),
                                                                                              SizedBox(
                                                                                                width: 8.w,
                                                                                              ),
                                                                                              InkWell(
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: FaIcon(
                                                                                                    FontAwesomeIcons.plus,
                                                                                                    color: primaryColor,
                                                                                                    size: 20,
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  setStatee(() {
                                                                                                    cubitt.providerOrderDetails?.items?[index].quantity = (widget.cubit?.providerOrderDetails?.items?[index].quantity)! + 1;
                                                                                                  });
                                                                                                  // setState(() {});
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      });
                                                                                },
                                                                              ),
                                                                              actions: [
                                                                                CupertinoDialogAction(
                                                                                  child: const Text('نعم'),
                                                                                  onPressed: () {
                                                                                    widget.cubit?.updateAssociateItems(itemId: widget.cubit?.providerOrderDetails?.items?[index].id, orderId: widget.orderId, quantity: widget.cubit?.providerOrderDetails?.items?[index].quantity);
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                                CupertinoDialogAction(
                                                                                  child: const Text('لا'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                )
                                                                              ],
                                                                            ));
                                                                  } else {
                                                                    // try {
                                                                    debugPrint(
                                                                        'if');
                                                                    widget.cubit
                                                                        ?.selectedItems
                                                                        .clear();
                                                                    if ((widget
                                                                            .cubit
                                                                            ?.providerOrderDetails
                                                                            ?.items?[index]
                                                                            .itemDetailes!)!
                                                                        .isEmpty) {
                                                                      Items? item = widget
                                                                          .cubit
                                                                          ?.providerOrderDetails
                                                                          ?.items
                                                                          ?.first;
                                                                      debugPrint(
                                                                          'item icon : ${item?.icon}');
                                                                      widget
                                                                          .cubit
                                                                          ?.selectedItems
                                                                          .add(pitem
                                                                              .Items(
                                                                        icon: item
                                                                            ?.icon,
                                                                        //! Required from api
                                                                        categoryItemServiceId:
                                                                            item?.categoryItemServiceId, //! Required
                                                                        id: item
                                                                            ?.id,
                                                                        lenght:
                                                                            item?.length,
                                                                        width: item
                                                                            ?.width,
                                                                        localId:
                                                                            0,
                                                                        name: item
                                                                            ?.name,
                                                                        // price: ,
                                                                        selectedQuantity:
                                                                            item?.quantity,
                                                                        withDimension:
                                                                            item?.withDimension,
                                                                        // categoryItemServiceId: item?.ca,
                                                                      ));
                                                                    } else {
                                                                      debugPrint(
                                                                          'else');
                                                                      for (int i =
                                                                              0;
                                                                          i < (widget.cubit?.providerOrderDetails?.items?[index].itemDetailes?.length ?? 0);
                                                                          i++) {
                                                                        int localId =
                                                                            0;
                                                                        debugPrint(
                                                                            'Add');
                                                                        Random
                                                                            random =
                                                                            Random();
                                                                        localId =
                                                                            random.nextInt(10000000);
                                                                        // debugPrint(
                                                                        //     'item : ${widget.cubit?.providerOrderDetails?.items?[index].itemDetailes}');
                                                                        var item = widget
                                                                            .cubit
                                                                            ?.providerOrderDetails
                                                                            ?.items?[index]
                                                                            .itemDetailes?[i];
                                                                        debugPrint(
                                                                            'item icon : ${item?.icon}');
                                                                        widget.cubit?.selectedItems.add(pitem.Items(
                                                                            icon: item?.icon, //! required from api
                                                                            categoryItemServiceId: item?.categoryItemServiceId, //! required
                                                                            id: item?.id,
                                                                            lenght: item?.length,
                                                                            width: item?.width,
                                                                            localId: i == 0 ? 0 : localId,
                                                                            name: item?.name,
                                                                            // price: ,
                                                                            selectedQuantity: item?.quantity,
                                                                            withDimension: item?.withDimension
                                                                            // categoryItemServiceId: item?.ca,
                                                                            ));
                                                                        debugPrint(
                                                                            'item : ${widget.cubit?.selectedItems}');
                                                                      }
                                                                    }

                                                                    // widget.cubit?.selectedItems.addAll(iterable)
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      builder:
                                                                          (context) =>
                                                                              Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.80,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(25.0),
                                                                            topRight:
                                                                                Radius.circular(25.0),
                                                                          ),
                                                                        ),
                                                                        child: MetersView(
                                                                            orderId:
                                                                                widget.orderId,
                                                                            quantity: widget.cubit?.providerOrderDetails?.items?[index].quantity,
                                                                            itemId: widget.cubit?.providerOrderDetails?.items?[index].id,
                                                                            isUpdate: true),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            primaryColor),
                                                                child:
                                                                    const Text(
                                                                  'تعديل العدد',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ));
                                                }),
                                                ConditionalBuilder(
                                                  condition: widget.state
                                                      is! AssociateItemsDeleteLoading,
                                                  fallback: (context) =>
                                                      const Center(
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  ),
                                                  builder: (context) =>
                                                      ElevatedButton(
                                                    onPressed: () {
                                                      showCupertinoDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              CupertinoAlertDialog(
                                                                title: const Text(
                                                                    'حذف هذه القطعة'),
                                                                actions: [
                                                                  CupertinoDialogAction(
                                                                    child: const Text(
                                                                        'نعم'),
                                                                    onPressed:
                                                                        () async {
                                                                      await widget
                                                                          .cubit
                                                                          ?.deleteAssociateItems(
                                                                        itemId: widget
                                                                            .cubit
                                                                            ?.providerOrderDetails
                                                                            ?.items?[index]
                                                                            .id,
                                                                        orderId:
                                                                            widget.orderId,
                                                                      );

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  CupertinoDialogAction(
                                                                    child:
                                                                        const Text(
                                                                            'لا'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  )
                                                                ],
                                                              ));
                                                    },
                                                    child: const Text(
                                                      'حذف',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                  ),
                                                ),
                                              ],
                                            )
                                    ]),
                              ),
                              SizedBox(
                                height: 2.h,
                              )
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // SizedBox(width: 20,),
            ConditionalBuilder(
              condition: widget.state is! OrderDetailsNextStatusLoadingState,
              fallback: (context) => const CupertinoActivityIndicator(),
              builder: (context) => Container(
                alignment: Alignment.bottomRight,
                child: widget.cubit?.providerOrderDetails?.nextStatus == null
                    ? Container()
                    : ElevatedButton(
                        onPressed: () {
                          debugPrint(
                              'status : ${widget.cubit?.providerOrderDetails?.coreNextStatus}');
                          if (widget.cubit?.providerOrderDetails
                                  ?.coreNextStatus ==
                              'finished') {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              // enableDrag: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                  padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 10,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height:
                                      MediaQuery.of(context).size.height * 0.80,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const Text(
                                          'تفضيلات الأوردر',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        widget.order?.prefrences?.isEmpty ??
                                                false
                                            ? const Center(
                                                child: Text(
                                                'لا يوجد تفضيلات',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30),
                                              ))
                                            : SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                child: ListView.separated(
                                                    // shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          ImageAsIcon(
                                                            image: widget
                                                                .order
                                                                ?.prefrences?[
                                                                    index]
                                                                .icon,
                                                            height: 29.4,
                                                            width: 32.4,
                                                            fromNetwork: true,
                                                            orignalColor: true,
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${widget.order?.prefrences?[index].name}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            '${widget.order?.prefrences?[index].preference}',
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                    itemCount: widget
                                                            .order
                                                            ?.prefrences
                                                            ?.length ??
                                                        0),
                                              ),
                                        const Divider(
                                          height: 1,
                                          color: Colors.amber,
                                          indent: 20,
                                          endIndent: 20,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'تعليقات الأوردر',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // const Expanded(child: SizedBox()),
                                            Text(
                                              '${widget.order?.comments?.customerComment}',
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text(
                                              'تعليق العميل',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            // const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${widget.order?.comments?.pickComment}',
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text(
                                              'تعليق الاستلام',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'الطلبات',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                          // textAlign: TextAlign.end,
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: Colors.amber,
                                          indent: 120,
                                          endIndent: 120,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        widget.order?.comments?.requests != null
                                            ? SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.10,
                                                child: ListView.separated(
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) => Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  '${widget.order?.comments?.requests?[index].comment}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                // const SizedBox(width: 20,),
                                                                widget
                                                                            .order
                                                                            ?.comments
                                                                            ?.requests?[index]
                                                                            .type ==
                                                                        'Only'
                                                                    ? const Text(
                                                                        ' : الآوردر الحالي',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      )
                                                                    : const Text(
                                                                        ' : جميع لاوردرات',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                              ],
                                                            ),
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                                height: 10),
                                                    itemCount: widget
                                                            .order
                                                            ?.comments
                                                            ?.requests
                                                            ?.length ??
                                                        0),
                                              )
                                            : const Text(
                                                'لا يوجد بيانات متوفره حاليا !'),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: Colors.amber,
                                          indent: 50,
                                          endIndent: 50,
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextField(
                                          controller: commentController,
                                          decoration: const InputDecoration(
                                            hintText: 'comment',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  widget.cubit?.goToNextStatus(
                                                      isDeliveryMan: false,
                                                      orderId: widget.order?.id,
                                                      itemCount: int.tryParse(
                                                          itemCountController
                                                              .text),
                                                      comment: commentController
                                                          .text);
                                                  debugPrint('goToNextStatus');
                                                },
                                                child: const Text('نعم')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('لا'))
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          } else {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      title: const Text('!تاكيد'),
                                      content: Card(
                                        color: Colors.transparent,
                                        elevation: 0.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            if (widget
                                                    .cubit
                                                    ?.providerOrderDetails
                                                    ?.coreNextStatus ==
                                                'provider_received')
                                              TextField(
                                                controller: itemCountController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'item count',
                                                ),
                                              ),
                                            TextField(
                                              controller: commentController,
                                              decoration: const InputDecoration(
                                                hintText: 'comment',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text('نعم'),
                                          onPressed: () {
                                            debugPrint(
                                                'hero ${widget.cubit!.providerOrderDetails!.coreNextStatus}');
                                            // widget.cubit.deleteCustomer(id: widget.item.id);
                                            if (widget
                                                    .cubit
                                                    ?.providerOrderDetails
                                                    ?.coreNextStatus ==
                                                'provider_received') {
                                              if (int.tryParse(
                                                      itemCountController
                                                          .text)! >=
                                                  widget
                                                      .cubit!
                                                      .providerOrderDetails!
                                                      .itemCount!) {
                                                widget.cubit?.goToNextStatus(
                                                    isDeliveryMan: false,
                                                    orderId: widget.orderId,
                                                    itemCount: int.tryParse(
                                                        itemCountController
                                                            .text),
                                                    comment:
                                                        commentController.text);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'خطا في عدد الاصناف'),
                                                  backgroundColor: Colors.red,
                                                ));
                                              }
                                            }
                                            if (widget
                                                    .cubit!
                                                    .providerOrderDetails!
                                                    .coreNextStatus ==
                                                'check_up') {
                                              if (widget
                                                      .cubit!.checkedNumberSum <
                                                  widget
                                                      .cubit!
                                                      .providerOrderDetails!
                                                      .itemCount!) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('عدم تطابق القطع'),
                                                  backgroundColor: Colors.red,
                                                ));
                                              } else if (widget
                                                      .cubit!.checkedNumberSum >
                                                  widget
                                                      .cubit!
                                                      .providerOrderDetails!
                                                      .itemCount!) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'برجاء العودة الي ادارة التشغيل'),
                                                  backgroundColor: Colors.red,
                                                ));
                                              } else {
                                                widget.cubit?.goToNextStatus(
                                                    isDeliveryMan: false,
                                                    orderId: widget.orderId,
                                                    itemCount: int.tryParse(
                                                        itemCountController
                                                            .text),
                                                    comment:
                                                        commentController.text);
                                              }
                                            } else {
                                              widget.cubit?.goToNextStatus(
                                                  isDeliveryMan: false,
                                                  orderId: widget.orderId,
                                                  itemCount: int.tryParse(
                                                      itemCountController.text),
                                                  comment:
                                                      commentController.text);
                                            }

                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('لا'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                          }
                        },
                        child: Text(
                            // widget.order.nextStatus,
                            '${widget.cubit?.providerOrderDetails?.nextStatus}')),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
