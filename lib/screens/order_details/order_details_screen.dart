// import 'package:conditional_builder/conditional_builder.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/local/cache_helper.dart';
import '../../shared/widgets/components.dart';
import '../../styles/color.dart';
import '../home/home_screen.dart';
import '../provider_app/images/images_screen.dart';
import '../provider_app/price_list/price_list_screen.dart';
import 'cubit.dart';
import 'order_details_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key, this.orderId, this.fromNotification})
      : super(key: key);
  final int? orderId;
  final bool? fromNotification;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isDeliveryMan = false;

  @override
  void initState() {
    super.initState();
    isDeliveryMan = CacheHelper.getData(key: 'type');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: isDeliveryMan
          ? (context) =>
              OrderDetailsCubit()..getOrderDetails(orderId: widget.orderId)
          : (context) => OrderDetailsCubit()
            ..getProviderOrderDetails(orderId: widget.orderId),
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
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
                                PriceListScreen(orderId: widget.orderId))
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
                                              style: TextStyle(
                                                  color: Colors.white),
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
      ),
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
                                cubit?.orderDetailsModel?.address?.lat,
                                cubit?.orderDetailsModel?.address?.long),
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
              if (cubit!.orderDetailsModel!.isReturn!)
                Container(
                  child: const Text(
                    'منتج مرتجع',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: const BoxDecoration(color: Colors.red),
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

class ProviderSection extends StatelessWidget {
  const ProviderSection({Key? key, this.cubit, this.orderId, this.state})
      : super(key: key);
  final OrderDetailsCubit? cubit;
  final int? orderId;
  final OrderDetailsState? state;

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
                    "من: ${cubit?.providerOrderDetails?.pick?.from}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الي: ${cubit?.providerOrderDetails?.pick?.to}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Text(
                "تاريخ التسليم: ${cubit?.providerOrderDetails?.deliver?.date}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('وقت التسليم'),
                  Text(
                    "من: ${cubit?.providerOrderDetails?.deliver?.from}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "الي: ${cubit?.providerOrderDetails?.deliver?.to}",
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
                      "كود العميل: ${cubit?.providerOrderDetails?.customerCode}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "الخدمة: ${cubit?.providerOrderDetails?.type}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "تعليق الاستلام: ${cubit?.providerOrderDetails?.comments?.pickComment}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "التعليق: ${cubit?.providerOrderDetails?.comments?.normalComments}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "to custome comment: ${cubit?.providerOrderDetails?.comments?.toCustomComment}",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "طلبات العميل:",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                    Column(
                      children: cubit!.providerOrderDetails!.requests!.requests!
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
                          "عدد القطع المستلمة: ${cubit?.providerOrderDetails?.itemCount}",
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
                          "عدد القطع التي تم فحصها: ${cubit?.checkedNumberSum}",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit?.providerOrderDetails?.items != null
                            ? cubit?.providerOrderDetails?.items?.length
                            : 0,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GFAccordion(
                                  title:
                                      'x${cubit?.providerOrderDetails?.items?[index].quantity} ${cubit?.providerOrderDetails?.items?[index].name}',
                                  contentChild: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'الصنف: ${cubit?.providerOrderDetails?.items?[index].category}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Text(
                                          'خدمة: ${cubit?.providerOrderDetails?.items?[index].service}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Text(
                                          'التفضيلات: ${cubit?.providerOrderDetails?.items?[index].preference}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Text(
                                          'العدد: ${cubit?.providerOrderDetails?.items?[index].quantity}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Builder(builder: (context) {
                                              return ConditionalBuilder(
                                                  condition: state
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
                                                              showCupertinoDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          CupertinoAlertDialog(
                                                                            title:
                                                                                const Text('تعديل عدد القطعة'),
                                                                            content:
                                                                                StatefulBuilder(
                                                                              builder: (context, setStatee) {
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
                                                                                            cubit?.providerOrderDetails?.items![index].quantity = cubit?.providerOrderDetails?.items![index].quantity ?? 0 - 1;
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 8.w,
                                                                                      ),
                                                                                      Text('${cubit?.providerOrderDetails?.items?[index].quantity}'),
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
                                                                                            cubit?.providerOrderDetails?.items?[index].quantity = cubit?.providerOrderDetails?.items?[index].quantity ?? 0 + 1;
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                            actions: [
                                                                              CupertinoDialogAction(
                                                                                child: const Text('نعم'),
                                                                                onPressed: () {
                                                                                  cubit?.updateAssociateItems(itemId: cubit?.providerOrderDetails?.items?[index].id, orderId: orderId, quantity: cubit?.providerOrderDetails?.items?[index].quantity);
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
                                              condition: state
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
                                                                  await cubit
                                                                      ?.deleteAssociateItems(
                                                                    itemId: cubit
                                                                        ?.providerOrderDetails
                                                                        ?.items?[
                                                                            index]
                                                                        .id,
                                                                    orderId:
                                                                        orderId,
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
              condition: state is! OrderDetailsNextStatusLoadingState,
              fallback: (context) => const CupertinoActivityIndicator(),
              builder: (context) => Container(
                alignment: Alignment.bottomRight,
                child: cubit?.providerOrderDetails?.nextStatus == null
                    ? Container()
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          if (cubit?.providerOrderDetails
                                                  ?.coreNextStatus ==
                                              'provider_received')
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
                                          debugPrint('hero ${cubit!
                                                  .providerOrderDetails!
                                                  .coreNextStatus}');
                                          // widget.cubit.deleteCustomer(id: widget.item.id);
                                          if (cubit?.providerOrderDetails
                                                  ?.coreNextStatus ==
                                              'provider_received') {
                                            if (int.tryParse(itemCountController
                                                    .text)! >=
                                                cubit!.providerOrderDetails!
                                                    .itemCount!) {
                                              cubit?.goToNextStatus(
                                                  isDeliveryMan: false,
                                                  orderId: orderId,
                                                  itemCount: int.tryParse(
                                                      itemCountController.text),
                                                  comment:
                                                      commentController.text);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text('خطا في عدد الاصناف'),
                                                backgroundColor: Colors.red,
                                              ));
                                            }
                                          } 
                                           if (cubit!
                                                  .providerOrderDetails!
                                                  .coreNextStatus ==
                                              'check_up') {
                                            if (cubit!.checkedNumberSum <
                                                cubit!.providerOrderDetails!
                                                    .itemCount!) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text('عدم تطابق القطع'),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else if (cubit!.checkedNumberSum >
                                                cubit!.providerOrderDetails!
                                                    .itemCount!) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'برجاء العودة الي ادارة التشغيل'),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else {
                                              cubit?.goToNextStatus(
                                                  isDeliveryMan: false,
                                                  orderId: orderId,
                                                  itemCount: int.tryParse(
                                                      itemCountController.text),
                                                  comment:
                                                      commentController.text);
                                            }
                                          }else{
                                            cubit?.goToNextStatus(
                                                  isDeliveryMan: false,
                                                  orderId: orderId,
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
                        },
                        child: Text(
                            // widget.order.nextStatus,
                            '${cubit?.providerOrderDetails?.nextStatus}')),
              ),
            )
          ],
        )
      ],
    );
  }
}
