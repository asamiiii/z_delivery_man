// import 'package:conditional_builder/conditional_builder.dart';
import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:z_delivery_man/models/order_mode.dart';
import 'package:z_delivery_man/models/order_per_status_provider.dart';
import 'package:z_delivery_man/models/price_list_model.dart' as pitem;
import 'package:z_delivery_man/models/provider_order_details.dart';
import 'package:z_delivery_man/screens/provider_app/price_list/meters_view.dart';
import 'package:z_delivery_man/shared/widgets/image_as_icon.dart';

import '../../network/local/cache_helper.dart';
import '../../shared/widgets/components.dart';
import '../../styles/color.dart';
import '../home/home_screen.dart';
import '../provider_app/price_list/price_list_screen.dart';
import 'cubit.dart';
import 'order_details_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen(
      {Key? key, this.orderId, this.fromNotification, this.order})
      : super(key: key);
  final int? orderId;
  final bool? fromNotification;
  final Orders? order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isDeliveryMan = false;

  @override
  void initState() {
    var cubit = context.read<OrderDetailsCubit>();

    super.initState();
    isDeliveryMan = CacheHelper.getData(key: 'type');
        isDeliveryMan == true
        ? cubit.getOrderDetails(orderId: widget.orderId)
        : cubit.getProviderOrderDetails(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, state) {
        if (state is OrderDetailsNextStatusSuccessState) {
          showToast(
              message: 'تم تحديث حالة الاوردر', state: ToastStates.SUCCESS);
          if (isDeliveryMan) {
            BlocProvider.of<OrderDetailsCubit>(context)
                .getOrderDetails(orderId: widget.orderId);
          } else {
            navigateAndReplace(context, const HomeScreen());
          }
        } else if (state is OrderDetailsNextStatusFailedState) {
          showToast(
              message: 'فشل تحديث حالة الاوردر', state: ToastStates.ERROR);
        } else if (state is OrderDetailsCollectOrderStatusSuccessState) {
          showToast(
              message: 'collect successfully', state: ToastStates.SUCCESS);
          BlocProvider.of<OrderDetailsCubit>(context)
              .getOrderDetails(orderId: widget.orderId);
        } else if (state is OrderDetailsCollectOrderStatusFailedState) {
          showToast(message: 'collect Failed', state: ToastStates.ERROR);
        }
        if (state is AssociateItemsUpdateSuccess) {
          if (state.successModel!.status!) {
            showToast(
                message: 'تم تحديث العدد بنجاح', state: ToastStates.SUCCESS);
            BlocProvider.of<OrderDetailsCubit>(context)
                .getProviderOrderDetails(orderId: widget.orderId);
          }
        } else if (state is AssociateItemsUpdateFailed) {
          showToast(message: 'فشل تحديث العدد ', state: ToastStates.ERROR);
        }
        if (state is AssociateItemsDeleteSuccess) {
          if (state.successModel!.status!) {
            showToast(message: 'تم مسح القطعة', state: ToastStates.SUCCESS);
            BlocProvider.of<OrderDetailsCubit>(context)
                .getProviderOrderDetails(orderId: widget.orderId);
          }
        } else if (state is AssociateItemsDeleteFailed) {
          showToast(message: 'فشل الحذف ', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        final cubit = OrderDetailsCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('تفاصيل الاوردر'),
              backgroundColor: primaryColor,
              centerTitle: true,
              actions: [
                widget.fromNotification!
                    ? IconButton(
                        onPressed: () {
                          navigateAndReplace(context, const HomeScreen());
                        },
                        icon: const Icon(Icons.home))
                    : Container(),
                if (!isDeliveryMan)
                  IconButton(
                      onPressed: () {
                        navigateTo(context,
                                PriceListScreen(orderId: widget.orderId,))
                            .then((value) => cubit.getProviderOrderDetails(
                                orderId: widget.orderId));
                      },
                      icon: const Icon(Icons.list_alt)
                      // SvgPicture.asset(
                      //   'assets/images/price_list.svg',
                      //   color: Colors.white,

                      // ),
                      ),
                // if (!isDeliveryMan)
                //   IconButton(
                //       onPressed: () {
                //         navigateTo(
                //             context,
                //             ImagesScreen(
                //               orderId: widget.orderId ?? 0,
                //             ));
                //       },
                //       icon: const Icon(Icons.image_outlined))
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => isDeliveryMan
                  ? cubit.getOrderDetails(orderId: widget.orderId)
                  : cubit.getProviderOrderDetails(orderId: widget.orderId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    if (isDeliveryMan)
                      ConditionalBuilder(
                          condition: state is! OrderDetailsLoadingState,
                          fallback: (context) => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                          builder: (context) {
                            return cubit.orderDetailsModel?.newCustomer !=
                                        null &&
                                    cubit.orderDetailsModel!.newCustomer!
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Transform.rotate(
                                        angle: 170,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.red),
                                          child: const Text(
                                            'عميل جديد',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  )
                                : Container();
                          }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: '${widget.orderId}',
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: primaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'رقم الاوردر',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "#${widget.orderId}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ConditionalBuilder(
                        condition: state is! OrderDetailsLoadingState &&
                            state is! OrderProviderDetailsLoadingState,
                        fallback: (context) => SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20.h,
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
                        builder: (context) {
                          if (isDeliveryMan) {
                            return DeliverySection(
                              cubit: cubit,
                              state: state,
                              orderId: widget.orderId!,
                            );
                          } else {
                            return ProviderSection(
                              orderId: widget.orderId!,
                              cubit: cubit,
                              state: state,
                              order: widget.order,
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DeliverySection extends StatelessWidget {
  const DeliverySection({Key? key, this.cubit, this.state, this.orderId})
      : super(key: key);
  final OrderDetailsCubit? cubit;
  final OrderDetailsState? state;
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();

    var itemCountController = TextEditingController();

    var collectTypeController = TextEditingController();

    bool checkCollectByHand = false;

    bool checkCollectByMachine = false;
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cubit?.orderDetailsModel?.pick == null
                  ? Text(
                      "تاريخ الاستلام: لايوجد",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      "تاريخ الاستلام: ${cubit?.orderDetailsModel?.pick?.date}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('وقت الاستلام'),
                  Text(
                    "من: ${cubit?.orderDetailsModel?.pick?.from}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الي: ${cubit?.orderDetailsModel?.pick?.to}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Text(
                "تاريخ التسليم: ${cubit?.orderDetailsModel?.deliver?.date}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('وقت التسليم'),
                  Text(
                    "من: ${cubit?.orderDetailsModel?.deliver?.from}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الي: ${cubit?.orderDetailsModel?.deliver?.to}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "الحالة الحالية: ${cubit?.orderDetailsModel?.currentStatus}",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
              // cubit.orderDetailsModel.nextStatus != null
              //     ? Text(
              //         "الحالة التالية: ${cubit.orderDetailsModel.nextStatus} ",
              //         style: TextStyle(
              //             fontSize: 12.sp,
              //             fontWeight: FontWeight.w400),
              //       )
              //     : Text(
              //         "الحالة التالية: لايوجد ",
              //         style: TextStyle(
              //             fontSize: 12.sp,
              //             fontWeight: FontWeight.w400),
              //       )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'تفاصيل العميل',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "اسم  العميل: ${cubit?.orderDetailsModel?.customer?.name}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "كود العميل: ${cubit?.orderDetailsModel?.address?.customerId}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cubit?.orderDetailsModel?.provider != null
                      ? Text(
                          "المغسلة: ${cubit?.orderDetailsModel?.provider}",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        )
                      : Text(
                          "المغسلة: لايوجد",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                  InkWell(
                    onTap: () => launch(
                        "tel:${cubit?.orderDetailsModel?.customer?.mobile}"),
                    child: Text(
                      "رقم العميل: ${cubit?.orderDetailsModel?.customer?.mobile}",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "العنوان: ${cubit?.orderDetailsModel?.address?.title}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "الكمباوند: ${cubit?.orderDetailsModel?.address?.compound}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Text(
                    "شارع: ${cubit?.orderDetailsModel?.address?.street}",
                    style:
                        TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                  ),

                  // building
                  Text(
                    "عمارة: ${cubit?.orderDetailsModel?.address?.building}",
                    style:
                        TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الدور: ${cubit?.orderDetailsModel?.address?.floor}",
                    style:
                        TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الشقة: ${cubit?.orderDetailsModel?.address?.flat}",
                    style:
                        TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                      onTap: () async {
                        // final availableMaps =
                        //     await MapLauncher
                        //         .installedMaps;

                        // await availableMaps.first
                        //     .showMarker(
                        //   coords: Coords(37.759392,
                        //       -122.5107336),
                        //   title: "Ocean Beach",
                        // );
                        if (await MapLauncher.isMapAvailable(MapType.google) ??
                            true) {
                          await MapLauncher.showMarker(
                            mapType: MapType.google,
                            coords: Coords(
                                cubit?.orderDetailsModel?.address?.lat??0,
                                cubit?.orderDetailsModel?.address?.long??0),
                            title: "عنوان العميل",
                          );
                        }
                      },
                      child: Text(
                        'الي العنوان',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'تفاصيل الاوردر',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          elevation: 10,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              if (cubit!.orderDetailsModel!.isReturn ?? false)
                Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  child: const Text(
                    'منتج مرتجع',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "عدد القطع: ${cubit?.orderDetailsModel?.itemCount}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: cubit?.orderDetailsModel?.services?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GFAccordion(
                            title:
                                'خدمة: ${cubit?.orderDetailsModel?.services?[index].serviceName}',
                            contentChild: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cubit!.orderDetailsModel!
                                    .services![index].categories!
                                    .map((e) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${e.categoryName}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp),
                                            ),
                                            Column(
                                              children: e.items!
                                                  .map(
                                                    (e) => Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${e.quantity} x ${e.name}',
                                                          softWrap: true,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                        Text(
                                                          '${e.price} جنيه',
                                                          softWrap: true,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                            )
                                          ],
                                        ))
                                    .toList()),
                          ),
                          SizedBox(
                            height: 2.h,
                          )
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "القيمة",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المجموع الفرعي:",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${cubit?.orderDetailsModel?.cost?.subtotal}جنيه",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "خصم:",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${cubit?.orderDetailsModel?.cost?.discount}جنيه",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "توصيل:",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${cubit?.orderDetailsModel?.cost?.deliveryFees}جنيه",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المجموع:",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${cubit?.orderDetailsModel?.cost?.total}جنيه",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        ConditionalBuilder(
          condition: state is! OrderDetailsNextStatusLoadingState &&
              state is! OrderDetailsLoadingState,
          fallback: (context) => const CupertinoActivityIndicator(),
          builder: (context) => Container(
            alignment: Alignment.center,
            height: 9.h,
            child: cubit?.orderDetailsModel?.nextStatus == null
                ? cubit?.orderDetailsModel?.canCollect == true
                    ? ElevatedButton(
                        onPressed: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                    title: const Text('!تاكيد'),
                                    content: StatefulBuilder(
                                      builder: (context, setStatee) {
                                        return Card(
                                          color: Colors.transparent,
                                          elevation: 0.0,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              CheckboxListTile(
                                                  title: const Text(
                                                      'الدفع عند الاستلام'),
                                                  value: checkCollectByHand,
                                                  onChanged: (value) {
                                                    setStatee(() {
                                                      checkCollectByMachine =
                                                          false;
                                                      checkCollectByHand =
                                                          value!;
                                                    });
                                                  }),
                                              CheckboxListTile(
                                                  title: const Text(
                                                      'الدفع بالبطاقة الائتمانية'),
                                                  value: checkCollectByMachine,
                                                  onChanged: (value) {
                                                    setStatee(() {
                                                      checkCollectByHand =
                                                          false;
                                                      checkCollectByMachine =
                                                          value!;
                                                    });
                                                  }),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('نعم'),
                                        onPressed: () {
                                          if (checkCollectByHand == true ||
                                              checkCollectByMachine == true) {
                                            cubit?.collectOrder(
                                                orderId: orderId,
                                                collectMethod: checkCollectByHand
                                                    ? "collected_by_hand"
                                                    : "collected_by_machine");

                                            Navigator.of(context).pop();
                                          }
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
                        },
                        child: const Text(
                          'تحصيل',
                        ))
                    : Container()
                : ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const Text('!تاكيد'),
                                content: Card(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      if (cubit?.orderDetailsModel
                                                  ?.coreNextStatus ==
                                              'picked' ||
                                          cubit?.orderDetailsModel
                                                  ?.coreNextStatus ==
                                              'from_provider')
                                        TextField(
                                          controller: itemCountController,
                                          decoration: const InputDecoration(
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
                                      // widget.cubit.deleteCustomer(id: widget.item.id);
                                      cubit?.goToNextStatus(
                                          isDeliveryMan: true,
                                          orderId: orderId,
                                          itemCount: int.tryParse(
                                              itemCountController.text),
                                          comment: commentController.text);

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
                    },
                    child: Text(
                      '${cubit?.orderDetailsModel?.nextStatus}',
                    )),
          ),
        )
      ],
    );
  }
}

class ProviderSection extends StatefulWidget {
  const ProviderSection(
      {Key? key, this.cubit, this.orderId, this.state, this.order})
      : super(key: key);
  final OrderDetailsCubit? cubit;
  final int? orderId;
  final OrderDetailsState? state;
  final Orders? order;

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
        Card(
          elevation: 10,
          child: Column(
            children: [
              // Text(
              //   "تاريخ الاستلام: ${cubit.providerOrderDetails.pick.date}",
              //   style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('وقت الاستلام'),
                  Text(
                    "من: ${widget.cubit?.providerOrderDetails?.pick?.from}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الي: ${widget.cubit?.providerOrderDetails?.pick?.to}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Text(
                "تاريخ التسليم: ${widget.cubit?.providerOrderDetails?.deliver?.date}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
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
              Card(
                elevation: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تفاصيل الاوردر",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Text(
                      "كود العميل: ${widget.cubit?.providerOrderDetails?.customerCode}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "الخدمة: ${widget.cubit?.providerOrderDetails?.type}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "تعليق الاستلام: ${widget.cubit?.providerOrderDetails?.comments?.pickComment}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "التعليق العميل ${widget.cubit?.providerOrderDetails?.comments?.normalComments}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "to custome comment: ${widget.cubit?.providerOrderDetails?.comments?.toCustomComment}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
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
                    widget.cubit?.providerOrderDetails?.deliverDeliveryMan !=
                            null
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
                      "طلبات العميل:",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Column(
                      children: widget
                          .cubit!.providerOrderDetails!.requests!.requests!
                          .map(
                            (e) => Text(
                              "$e",
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400),
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
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
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
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cubit?.providerOrderDetails?.items !=
                                null
                            ? widget.cubit?.providerOrderDetails?.items?.length
                            : 0,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GFAccordion(
                                  title:
                                      'x${widget.cubit?.providerOrderDetails?.items?[index].quantity} ${widget.cubit?.providerOrderDetails?.items?[index].name}',
                                  contentChild: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'الصنف: ${widget.cubit?.providerOrderDetails?.items?[index].category}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Text(
                                          'خدمة: ${widget.cubit?.providerOrderDetails?.items?[index].service}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Text(
                                          'التفضيلات: ${widget.cubit?.providerOrderDetails?.items?[index].preference}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'العدد: ${widget.cubit?.providerOrderDetails?.items?[index].quantity}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const Text(
                                                        'x',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        '${itemDetails?[index3].length}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
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
                                                                    builder:
                                                                        (context) =>
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
                                                                        ?.items?[
                                                                            index]
                                                                        .itemDetailes!)!
                                                                    .isEmpty) {
                                                                  Items? item = widget
                                                                      .cubit
                                                                      ?.providerOrderDetails
                                                                      ?.items
                                                                      ?.first;
                                                                  debugPrint(
                                                                      'item icon : ${item?.icon}');
                                                                  widget.cubit
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
                                                                    lenght: item
                                                                        ?.length,
                                                                    width: item
                                                                        ?.width,
                                                                    localId: 0,
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
                                                                      i <
                                                                          (widget.cubit?.providerOrderDetails?.items?[index].itemDetailes?.length ??
                                                                              0);
                                                                      i++) {
                                                                    int localId =
                                                                        0;
                                                                    debugPrint(
                                                                        'Add');
                                                                    Random
                                                                        random =
                                                                        Random();
                                                                    localId = random
                                                                        .nextInt(
                                                                            10000000);
                                                                    // debugPrint(
                                                                    //     'item : ${widget.cubit?.providerOrderDetails?.items?[index].itemDetailes}');
                                                                    var item = widget
                                                                        .cubit
                                                                        ?.providerOrderDetails
                                                                        ?.items?[
                                                                            index]
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
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.80,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(25.0),
                                                                        topRight:
                                                                            Radius.circular(25.0),
                                                                      ),
                                                                    ),
                                                                    child: MetersView(
                                                                        orderId:
                                                                            widget
                                                                                .orderId,
                                                                        quantity: widget
                                                                            .cubit
                                                                            ?.providerOrderDetails
                                                                            ?.items?[
                                                                                index]
                                                                            .quantity,
                                                                        itemId: widget
                                                                            .cubit
                                                                            ?.providerOrderDetails
                                                                            ?.items?[
                                                                                index]
                                                                            .id,
                                                                        isUpdate:
                                                                            true),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary:
                                                                        primaryColor),
                                                            child: const Text(
                                                              'تعديل العدد',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                                child:
                                                                    const Text(
                                                                        'نعم'),
                                                                onPressed:
                                                                    () async {
                                                                  await widget
                                                                      .cubit
                                                                      ?.deleteAssociateItems(
                                                                    itemId: widget
                                                                        .cubit
                                                                        ?.providerOrderDetails
                                                                        ?.items?[
                                                                            index]
                                                                        .id,
                                                                    orderId: widget
                                                                        .orderId,
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
                                                                onPressed: () {
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
                                                          FontWeight.bold),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.red),
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
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.80,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25.0),
                                                    topRight:
                                                        Radius.circular(25.0),
                                                  ),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        'تفضيلات الأوردر',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      widget.order?.prefrences
                                                                  ?.isEmpty ??
                                                              false
                                                          ? const Center(
                                                              child: Text(
                                                              'لا يوجد تفضيلات',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 30),
                                                            ))
                                                          : SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.15,
                                                              child: ListView
                                                                  .separated(
                                                                      // shrinkWrap: true,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const SizedBox(
                                                                              width: 20,
                                                                            ),
                                                                            ImageAsIcon(
                                                                              image: widget.order?.prefrences?[index].icon,
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
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "${widget.order?.prefrences?[index].name}",
                                                                                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              '${widget.order?.prefrences?[index].preference}',
                                                                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
                                                                      separatorBuilder:
                                                                          (context, index) =>
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                      itemCount:
                                                                          widget.order?.prefrences?.length ??
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
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          // const Expanded(child: SizedBox()),
                                                          Text(
                                                            '${widget.order?.comments?.customerComment}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          const Text(
                                                            'تعليق العميل',
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                          // const Expanded(child: SizedBox()),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '${widget.order?.comments?.pickComment}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          const Text(
                                                            'تعليق الاستلام',
                                                            style: TextStyle(
                                                                fontSize: 15),
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
                                                      widget.order?.comments
                                                                  ?.requests !=
                                                              null
                                                          ? SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.10,
                                                              child: ListView
                                                                  .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (context, index) =>
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Text(
                                                                                    '${widget.order?.comments?.requests?[index].comment}',
                                                                                    style: const TextStyle(fontSize: 15),
                                                                                  ),
                                                                                  // const SizedBox(width: 20,),
                                                                                  widget.order?.comments?.requests?[index].type == 'Only'
                                                                                      ? const Text(
                                                                                          ' : الآوردر الحالي',
                                                                                          style: TextStyle(fontSize: 15),
                                                                                        )
                                                                                      : const Text(
                                                                                          ' : جميع لاوردرات',
                                                                                          style: TextStyle(fontSize: 15),
                                                                                        ),
                                                                                ],
                                                                              ),
                                                                      separatorBuilder: (context,
                                                                              index) =>
                                                                          const SizedBox(
                                                                              height:
                                                                                  10),
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
                                                        controller:
                                                            commentController,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'comment',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                widget.cubit?.goToNextStatus(
                                                                    isDeliveryMan:
                                                                        false,
                                                                    orderId: widget
                                                                        .order
                                                                        ?.id,
                                                                    itemCount: int.tryParse(
                                                                        itemCountController
                                                                            .text),
                                                                    comment:
                                                                        commentController
                                                                            .text);
                                                                debugPrint(
                                                                    'goToNextStatus');
                                                              },
                                                              child: const Text(
                                                                  'نعم')),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'لا'))
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
            )
          ],
        )
      ],
    );
  }
}
