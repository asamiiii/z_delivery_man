import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '/../models/orders_per_status_model.dart';
import '/../screens/drawer/drawer.dart';
import '/../screens/home/home_screen.dart';
import '/../screens/order_details/order_details_screen.dart';
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
  const OrderPerStatusScreen({Key? key, this.status, this.isAll})
      : super(key: key);
  final String? status;
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
            drawer: const BuildDrawer(),
            appBar: AppBar(
              // backgroundColor: primaryColor,
              title: const Text('الاوردرات'),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      navigateAndReplace(context, const HomeScreen());
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
              builder: (context) => ListView.separated(
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
              ),
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

class _OrdersSectionState extends State<OrdersSection> {
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
          Card(
            elevation: 10,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40))),
            child: Container(
              // padding: EdgeInsets.only(left: 0.5.h, right: 0.5.h),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(120))),
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
                      Text(
                        'اسم العميل: ${widget.order?.customer?.name}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        'كود العميل: ${widget.order?.customer?.id}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(fontSize: 11.sp),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () =>
                        launch("tel:${widget.order?.customer?.mobile}"),
                    child: Row(
                      children: [
                        const Icon(Icons.phone),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'رقم العميل: ${widget.order?.customer?.mobile}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(fontSize: 15, color: primaryColor),
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
                      Icon(Icons.maps_home_work_sharp),
                      SizedBox(width: 10),
                      Text(
                        'المنطقة: ${widget.order?.zone}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        width: 20,
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
                            if (await MapLauncher.isMapAvailable(
                                    MapType.google) ??
                                true) {
                              await MapLauncher.showMarker(
                                mapType: MapType.google,
                                coords: Coords(widget.order?.address?.lat??0,
                                    widget.order?.address?.long??0),
                                title: "عنوان العميل",
                              );
                            }
                          },
                          child: Text(
                            'الي العنوان',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
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
                  Text(
                    'القيمة الكلية: ${widget.order?.total}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConditionalBuilder(
                        condition: widget.state
                            is! OrderPerStatusNextStatusLoadingState,
                        fallback: (context) =>
                            const CupertinoActivityIndicator(),
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
                                                      title:
                                                          const Text('!تاكيد'),
                                                      content: StatefulBuilder(
                                                        builder: (context,
                                                            setStatee) {
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
                                                                      });
                                                                    }),
                                                                CheckboxListTile(
                                                                    title: const Text(
                                                                        'الدفع بالبطاقة الائتمانية'),
                                                                    value:
                                                                        checkCollectByMachine,
                                                                    onChanged:
                                                                        (value) {
                                                                      setStatee(
                                                                          () {
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
                                                          child:
                                                              const Text('نعم'),
                                                          onPressed: () {
                                                            if (checkCollectByHand ==
                                                                    true ||
                                                                checkCollectByMachine ==
                                                                    true) {
                                                              widget.cubit?.collectOrder(
                                                                  orderId:
                                                                      widget
                                                                          .order
                                                                          ?.id,
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
                                                          child:
                                                              const Text('لا'),
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
                                                      onPressed: () {
                                                        // widget.cubit.deleteCustomer(id: widget.item.id);
                                                        widget.cubit?.goToNextStatus(
                                                            isDeliveryMan: true,
                                                            orderId: widget
                                                                .order?.id,
                                                            itemCount: int.tryParse(
                                                                itemCountController
                                                                    .text),
                                                            comment:
                                                                commentController
                                                                    .text);

                                                        Navigator.of(context)
                                                            .pop();
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
                                      child: Flexible(
                                        child: Text(
                                          '${widget.order?.nextStatus}',
                                        ),
                                      )),
                                ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // top: 0,
            bottom: 1,
            left: 5,
            child: Hero(
              tag: '${widget.order}',
              child: Material(
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'كود الاوردر',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "#${widget.order?.id}",
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
            ),
          ),
        ],
      ),
    );
  }
}
