import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_delivery_man/core/main_helpers.dart/navigation_helper.dart';
import 'package:z_delivery_man/screens/home/home_delivery/home_delivery.dart';
import 'package:z_delivery_man/shared/widgets/custom_dropdown_menu.dart';
import 'package:z_delivery_man/shared/widgets/image_as_icon.dart';
import '/../models/orders_per_status_model.dart';
import '/../screens/drawer/drawer.dart';
import '../order_details/presentation/view/order_details_screen.dart';
import '/../screens/status_orders/cubit.dart';
import '/../screens/status_orders/status_orders_states.dart';
import '/../shared/widgets/components.dart';
import '/../styles/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPerStatusScreen extends StatefulWidget {
  const OrderPerStatusScreen(
      {Key? key, this.status, this.isAll, this.ststusString})
      : super(key: key);
  final String? status;
  final String? ststusString;
  final int? isAll;

  @override
  State<OrderPerStatusScreen> createState() => _OrderPerStatusScreenState();
}

class _OrderPerStatusScreenState extends State<OrderPerStatusScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(setupScrollController);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderPerStatusCubit>(context, listen: false)
        .setCurrentPage(isInit: true);
    _scrollController = ScrollController()..addListener(setupScrollController);
    BlocProvider.of<OrderPerStatusCubit>(context, listen: false)
        .getOrderPerStatus(isAll: widget.isAll, status: widget.status, page: 1);
  }

  void setupScrollController() {
    int? currentPage =
        BlocProvider.of<OrderPerStatusCubit>(context, listen: false)
            .currentPage;
    int? lastPage =
        BlocProvider.of<OrderPerStatusCubit>(context, listen: false).lastPage;
    print('Current : $currentPage , last: $lastPage');

    if (_scrollController.position.pixels ==
            (_scrollController.position.maxScrollExtent) &&
        currentPage! < lastPage!) {
      BlocProvider.of<OrderPerStatusCubit>(context, listen: false)
          .getOrderPerStatus(
              isAll: widget.isAll,
              status: widget.status,
              page: currentPage + 1);
      BlocProvider.of<OrderPerStatusCubit>(context, listen: false)
          .setCurrentPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderPerStatusCubit, OrderPerStatusStates>(
      listener: (context, state) {
        if (state is OrderPerStatusNextStatusSuccessState) {
          showToast(
              message: 'تم تحديث حالة الاوردر', state: ToastStates.SUCCESS);
          BlocProvider.of<OrderPerStatusCubit>(context).getOrderPerStatus(
              status: widget.status, isAll: widget.isAll, page: 1);
        } else if (state is OrderPerStatusNextStatusFailedState) {
          showToast(
              message: 'فشل تحديث حالة الاوردر', state: ToastStates.ERROR);
        } else if (state is OrderPerStatusCollectOrderStatusSuccessState) {
          showToast(
              message: 'collect successfully', state: ToastStates.SUCCESS);
          BlocProvider.of<OrderPerStatusCubit>(context)
              .getOrderPerStatus(status: widget.status, isAll: widget.isAll);
        } else if (state is OrderPerStatusCollectOrderStatusFailedState) {
          showToast(message: 'collect Failed', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        final cubit = OrderPerStatusCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // drawer: const BuildDrawer(),
            appBar: AppBar(
              // backgroundColor: primaryColor,
              title: Text(
                widget.ststusString ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      navigateAndReplace(context, const HomeDelivery());
                    },
                    icon: const Icon(Icons.home))
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! OrderPerStatusLoadingState,
              fallback: (context) => ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
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
              builder: (context) => cubit.allOrders.isNotEmpty
                  ? ListView.separated(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                      shrinkWrap: true,
                      itemCount: cubit.allOrders.length,
                      itemBuilder: (context, index) {
                        return OrdersSection(
                            order: cubit.allOrders.elementAt(index),
                            state: state,
                            cubit: cubit);
                      },
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_late_rounded,
                          size: 30.sp,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text('هذه الحاله فارغه !!')),
                      ],
                    )),
            ),
          ),
        );
      },
    );
  }

  // Widget _ordersList(OrderPerStatusStates state, OrderPerStatusCubit cubit) {
  //   if (state is OrderPerStatusLoadingState && state.isFirstFetch) {
  //     return const Padding(
  //       padding: EdgeInsets.all(10),
  //       child: Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //   }
  //   List<Orders> orders = [];
  //   if (state is OrderPerStatusLoadingState) {
  //     orders = state.oldOrders;
  //   } else if (state is OrderPerStatusLoadedState) {
  //     orders = state.orders;
  //   }
  //   return ListView.separated(
  //     controller: _scrollController,
  //     physics: const BouncingScrollPhysics(),
  //     separatorBuilder: (context, index) => SizedBox(
  //       height: 2.h,
  //     ),
  //     shrinkWrap: true,
  //     itemCount: orders.length,
  //     itemBuilder: (context, index) {
  //       return OrdersSection(order: orders[index], state: state, cubit: cubit);
  //     },
  //   );
  // }
}

class OrdersSection extends StatefulWidget {
  const OrdersSection({Key? key, this.order, this.state, this.cubit})
      : super(key: key);

  final Orders? order;
  final OrderPerStatusStates? state;
  final OrderPerStatusCubit? cubit;

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class CardType {
  final String? name;
  final String? key;
  CardType({required this.name, required this.key});
}

List<CardType> byMachinList = [
  CardType(name: ' انستا باي', key: 'InstaPay'),
  CardType(name: 'ماكينة', key: 'POS')
];

class _OrdersSectionState extends State<OrdersSection> {
  CardType? selectedMachinType;
  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var itemCountController = TextEditingController();
    var collectTypeController = TextEditingController();
    bool checkCollectByHand = false;
    bool checkCollectByMachine = false;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (_, __, ___) => OrderDetailsScreen(
            orderId: widget.order?.id,
            fromNotification: false,
          ),
        ));
      },
      child: Stack(
        children: [
          Container(
            width: 100.w,
            padding:
                EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
            margin: EdgeInsets.only(
              left: 0.5.h,
              right: 0.5.h,
              top: 0.5.h,
            ),
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.person_2_rounded),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'اسم العميل: ${widget.order?.customer?.name}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // const Spacer(),

                    // const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () => launch("tel:${widget.order?.customer?.mobile}"),
                  child: Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 65.w,
                        child: Text(
                          'رقم العميل: ${widget.order?.customer?.mobile}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          // softWrap: true,
                          style: TextStyle(fontSize: 15, color: primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.maps_home_work_sharp),
                    const SizedBox(width: 10),
                    Text(
                      'الكومباوند : ${widget.order?.address?.compound}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 20),
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
                          if (await MapLauncher.isMapAvailable(
                                  MapType.google) ??
                              true) {
                            await MapLauncher.showMarker(
                              mapType: MapType.google,
                              coords: Coords(widget.order?.address?.lat ?? 0,
                                  widget.order?.address?.long ?? 0),
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

                const SizedBox(
                  height: 5,
                ),
                // Row(
                //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     const Icon(Icons.maps_home_work_sharp),
                //     const SizedBox(width: 10),
                //     Text(
                //       'رقم العماره :  ${widget.order?.address.}',
                //       overflow: TextOverflow.ellipsis,
                //       maxLines: 2,
                //       softWrap: true,
                //       style: const TextStyle(fontSize: 12),
                //     ),

                //   ],
                // ),

                const SizedBox(
                  height: 5,
                ),
                // Row(
                //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Icon(Icons.home_filled),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Text(
                //       'الكمباوند: ${widget.order?.address?.compound}',
                //       overflow: TextOverflow.ellipsis,
                //       maxLines: 2,
                //       softWrap: true,
                //       style: const TextStyle(fontSize: 15),
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    Icon(Icons.local_laundry_service_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    widget.order?.provider != null
                        ? Text(
                            'المغسلة: ${widget.order?.provider}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(
                            'المغسلة: لايوجد',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(fontSize: 15),
                          ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.dry_cleaning),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'عدد القطع : ${'Back End'}', //! get this value from backend
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),

                SizedBox(
                  height: 1.h,
                ),

                Text(
                  'القيمة الكلية: ${widget.order?.total}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'كود العميل: ${widget.order?.customer?.customerId}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
                if (widget.order?.customer?.newCustomerWithBag == true)
                  SizedBox(
                    height: 1.h,
                  ),
                if (widget.order?.customer?.newCustomerWithBag == true)
                  const Text(
                    'يجب تسليم شنطه للعميل',
                    style: TextStyle(
                        backgroundColor: Colors.green,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ConditionalBuilder(
                      condition:
                          widget.state is! OrderPerStatusNextStatusLoadingState,
                      fallback: (context) => const CupertinoActivityIndicator(),
                      builder: (context) => Container(
                        alignment: Alignment.bottomRight,
                        child: widget.order?.nextStatus == null
                            ? widget.order?.canCollect == true
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CupertinoAlertDialog(
                                                    title: const Text('!تاكيد'),
                                                    content: StatefulBuilder(
                                                      builder:
                                                          (context, setStatee) {
                                                        return Card(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 0.0,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            children: [
                                                              CheckboxListTile(
                                                                  title: const Text(
                                                                      'الدفع عند الاستلام'),
                                                                  value:
                                                                      checkCollectByHand,
                                                                  onChanged:
                                                                      (value) {
                                                                    setStatee(
                                                                        () {
                                                                      checkCollectByMachine =
                                                                          false;
                                                                      checkCollectByHand =
                                                                          value!;
                                                                      selectedMachinType =
                                                                          null;
                                                                    });
                                                                  }),

                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              CustomDropdown<
                                                                  CardType>(
                                                                items:
                                                                    byMachinList,
                                                                displayText:
                                                                    (item) {
                                                                  return item
                                                                      .name
                                                                      .toString();
                                                                },
                                                                onChanged:
                                                                    (selectedItem) {
                                                                  selectedMachinType =
                                                                      selectedItem;
                                                                  checkCollectByHand =
                                                                      false;
                                                                  checkCollectByMachine =
                                                                      true;

                                                                  setStatee(
                                                                    () {},
                                                                  );
                                                                },
                                                                selectedItem:
                                                                    selectedMachinType,
                                                                hintText:
                                                                    'اختر ',
                                                                mainTitle:
                                                                    'الدفع بالبطاقة الاتمانية',
                                                              )
                                                              // CheckboxListTile(
                                                              //     title: const Text(
                                                              //         'الدفع بالبطاقة الائتمانية'),
                                                              //     value:
                                                              //         checkCollectByMachine,
                                                              //     onChanged:
                                                              //         (value) {
                                                              //       setStatee(
                                                              //           () {
                                                              //         checkCollectByHand =
                                                              //             false;
                                                              //         checkCollectByMachine =
                                                              //             value!;
                                                              //       });
                                                              //     }),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        child:
                                                            const Text('نعم'),
                                                        onPressed: () {
                                                          if (checkCollectByHand ==
                                                                  true ||
                                                              checkCollectByMachine ==
                                                                  true) {
                                                            widget.cubit?.collectOrder(
                                                                byMachineOption:
                                                                    selectedMachinType
                                                                        ?.key,
                                                                orderId: widget
                                                                    .order?.id,
                                                                collectMethod:
                                                                    checkCollectByHand
                                                                        ? "collected_by_hand"
                                                                        : "collected_by_machine");

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: const Text('لا'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: const Text(
                                          'تجميع',
                                        )),
                                  )
                                : Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                                title: const Text('!تاكيد'),
                                                content: Card(
                                                  color: Colors.transparent,
                                                  elevation: 0.0,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      if (widget.order
                                                                  ?.coreNextStatus ==
                                                              'picked' ||
                                                          widget.order
                                                                  ?.coreNextStatus ==
                                                              'from_provider')
                                                        TextField(
                                                          controller:
                                                              itemCountController,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'item count',
                                                          ),
                                                        ),
                                                      TextField(
                                                        controller:
                                                            commentController,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'comment',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: const Text('نعم'),
                                                    onPressed: () async {
                                                      // context.popScreen();
                                                      await widget.cubit
                                                          ?.goToNextStatus(
                                                              isDeliveryMan:
                                                                  true,
                                                              orderId: widget
                                                                  .order?.id,
                                                              itemCount:
                                                                  int.tryParse(
                                                                      itemCountController
                                                                          .text),
                                                              comment:
                                                                  commentController
                                                                      .text)
                                                          .then((value) =>
                                                              context.goReplac(
                                                                  const HomeDelivery()));
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                    child: const Text('لا'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              ));
                                    },
                                    child: Text(
                                      '${widget.order?.nextStatus}',
                                    )),
                              ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            // bottom: 1,
            left: 10,
            child: Hero(
              tag: '${widget.order}',
              child: Material(
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'رقم الأوردر',
                        style: TextStyle(color: Colors.white, fontSize: 8.sp),
                      ),
                      Text(
                        "#${widget.order?.id}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              // top: 20,
              bottom: 20,
              left: 50,
              child: InkWell(
                  onTap: () {
                    debugPrint(
                        'customer comment : ${widget.order?.comments?.customerComment}');
                    debugPrint(
                        'pick comment : ${widget.order?.comments?.pickComment}');
                    debugPrint(
                        'requests comment : ${widget.order?.comments?.requests}');
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          child: Column(children: [
                            const Text(
                              'تعليقات الأوردر',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Expanded(child: SizedBox()),
                                Text(
                                  '${widget.order?.comments?.customerComment}',
                                  style: const TextStyle(fontSize: 15),
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.order?.comments?.pickComment}',
                                  style: const TextStyle(fontSize: 15),
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
                              indent: 50,
                              endIndent: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            widget.order?.comments?.requests != null
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${widget.order?.comments?.requests?[index].comment}',
                                              style:
                                                  const TextStyle(fontSize: 15),
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
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  )
                                                : const Text(
                                                    ' : جميع لاوردرات',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                          ],
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemCount: widget.order?.comments?.requests
                                            ?.length ??
                                        0)
                                : const Text('لا يوجد بيانات متوفره حاليا !')
                          ])),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/comments.png',
                        height: 30,
                        width: 30,
                      )
                    ],
                  ))),
          //! Prefrences Botttom Sheet
          Positioned(
              // top: 20,
              bottom: 25,
              left: 9,
              child: InkWell(
                  onTap: () {
                    // debugPrint('pref : ${widget.order?.prefrences}');
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // enableDrag : true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                          padding: const EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height * 0.50,
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
                              Text(
                                'تفضيلات الأوردر',
                                style: GoogleFonts.cairo(fontSize: 25),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              widget.order?.pref?.isEmpty ?? false
                                  ? Center(
                                      child: Text(
                                      'لا يوجد تفضيلات',
                                      style: GoogleFonts.cairo(
                                        fontSize: 30,
                                      ),
                                    ))
                                  : Expanded(
                                      child: ListView.separated(
                                          // shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                ImageAsIcon(
                                                  image: widget
                                                      .order?.pref?[index].icon,
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
                                                          "${widget.order?.pref?[index].name}",
                                                          style: GoogleFonts
                                                              .cairo()),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${widget.order?.pref?[index].preference}',
                                                  style: GoogleFonts.cairo(),
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 15,
                                              ),
                                          itemCount:
                                              widget.order!.pref?.length ?? 0),
                                    )
                            ],
                          )),
                    );
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/pref.png',
                        height: 30,
                        width: 30,
                        color: Colors.green,
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
