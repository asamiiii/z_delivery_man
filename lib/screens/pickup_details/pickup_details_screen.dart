// import 'dart:async';
// import 'dart:collection';

// import 'package:conditional_builder/conditional_builder.dart';
// import 'package:deliveryapp/models/order_mode.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:map_launcher/map_launcher.dart' as maplauncher;
// import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';
import 'package:z_delivery_man/screens/pickup_details/pickup_details_states.dart';
import 'package:z_delivery_man/screens/status_orders/status_orders_screen.dart';
import 'package:z_delivery_man/shared/widgets/custom_dropdown_menu.dart';

import '../../models/order_per_time_slot_model.dart';
import '../../shared/widgets/components.dart';
import '../../styles/color.dart';
import '../order_details/presentation/view/order_details_screen.dart';
import 'cubit.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();

class PickUpDetails extends StatefulWidget {
  const PickUpDetails({Key? key, this.timeSlotId, this.fromPickup})
      : super(key: key);
  final int? timeSlotId;
  final bool? fromPickup;

  @override
  State<PickUpDetails> createState() => _PickUpDetailsState();
}

class _PickUpDetailsState extends State<PickUpDetails> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // _allowAccessLocation();
  //   // getCurrntLocation();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // if (_locationSubscription != null) {
  //   //   _locationSubscription.cancel();
  //   // }
  // }

  // rebuild() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickupDetailsCubit()
        ..allowAccessLocation()
        ..getCurrntLocation(context)
        ..getOrdersPerTimeSlot(id: widget.timeSlotId),
      child: BlocConsumer<PickupDetailsCubit, PickupDetailsStates>(
        listener: (context, state) {
          if (state is PickupDetailsNextStatusSuccessState) {
            showToast(
                message: 'تم تحديث حالة الاوردر', state: ToastStates.SUCCESS);
            BlocProvider.of<PickupDetailsCubit>(context)
                .getOrdersPerTimeSlot(id: widget.timeSlotId);
          } else if (state is PickupDetailsNextStatusFailedState) {
            showToast(
                message: 'فشل تحديث حالة الاوردر', state: ToastStates.ERROR);
          } else if (state is PickupDetailsCollectOrderStatusSuccessState) {
            showToast(
                message: 'collect successfully', state: ToastStates.SUCCESS);
            BlocProvider.of<PickupDetailsCubit>(context)
                .getOrdersPerTimeSlot(id: widget.timeSlotId);
          } else if (state is PickupDetailsCollectOrderStatusFailedState) {
            showToast(message: 'collect Failed', state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          final cubit = PickupDetailsCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            // endDrawer: const BuildDrawer(),
            appBar: AppBar(
              centerTitle: true,
              title: const Text('الاوردرات'),
              backgroundColor: primaryColor,
              // leading: IconButton(
              //     onPressed: () {
              //       navigateAndReplace(context, const HomeScreen());
              //     },
              //     icon: const Icon(Icons.home)),
            ),
            body: RefreshIndicator(
              onRefresh: () =>
                  cubit.getOrdersPerTimeSlot(id: widget.timeSlotId),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:
                      // SizedBox(
                      //   height: 50.h,
                      //   child: Stack(
                      //     children: [

                      //       GoogleMap(
                      //         initialCameraPosition: cubit.initialLocation,
                      //         onMapCreated:
                      //             (GoogleMapController googleMapController) {
                      //           //   markers.add(
                      //           //     Marker(
                      //           //         markerId: MarkerId('1'),
                      //           //         position: LatLng(30.048745, 30.976736),
                      //           //         infoWindow: InfoWindow(title: 'Current Location'),
                      //           //         icon: BitmapDescriptor.defaultMarker),
                      //           //   );
                      //           // for (var order in cubit.ordersPerTimeSlots) {
                      //           //   cubit.markers.add(Marker(
                      //           //       markerId: MarkerId(order.id.toString()),
                      //           //       position: LatLng(
                      //           //           order.address.lat, order.address.long),
                      //           //       icon: BitmapDescriptor.defaultMarker));
                      //           // }
                      //           cubit.addOrdersMarkers();

                      //           cubit.googleMapController = googleMapController;
                      //         },
                      //         // markers: markers,
                      //         markers: Set.of((cubit.marker != null)
                      //             ? [cubit.marker, ...cubit.markers]
                      //             : []),
                      //         circles: Set.of(
                      //             (cubit.circle != null) ? [cubit.circle] : []),
                      //       ),
                      //       Positioned(
                      //           bottom: 4,
                      //           left: 2,
                      //           child: FloatingActionButton(
                      //             backgroundColor: primaryColor,
                      //             child: const Icon(Icons.location_searching),
                      //             onPressed: () {
                      //               // cubit.getCurrntLocation(context);
                      //               cubit.calculateDistanceOfOrderes();
                      //             },
                      //           ))

                      //     ],
                      //   ),
                      // ),

                      // cubit.sortedMap == null
                      //     ?
                      ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 2.h,
                    ),
                    shrinkWrap: true,
                    itemCount: cubit.ordersPerTimeSlots!.length,
                    itemBuilder: (context, index) {
                      return OrdersSection(
                        cubit: cubit,
                        order: cubit.ordersPerTimeSlots![index],
                        state: state,
                        timeSlotId: widget.timeSlotId,
                      );
                    },
                  )
                  // :
                  //  ListView.separated(
                  //     physics: AlwaysScrollableScrollPhysics(),
                  //     separatorBuilder: (context, index) => SizedBox(
                  //       height: 2.h,
                  //     ),
                  //     shrinkWrap: true,
                  //     itemCount: cubit.sortedMap.keys.length,
                  //     itemBuilder: (context, index) {
                  //       return OrdersSection(
                  //         cubit: cubit,
                  //         state: state,
                  //         order: cubit.sortedMap.keys.elementAt(index),
                  //         timeSlotId: widget.timeSlotId,
                  //       );
                  //     },
                  //   ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

class OrdersSection extends StatefulWidget {
  const OrdersSection({
    Key? key,
    this.order,
    this.state,
    this.cubit,
    this.timeSlotId,
    this.rebuild,
  }) : super(key: key);
  final OrdersPerTimeSlotModel? order;
  final PickupDetailsStates? state;
  final PickupDetailsCubit? cubit;
  final int? timeSlotId;
  final Function? rebuild;

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  CardType? selectedMachinType;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    var itemCountController = TextEditingController();
    bool checkCollectByHand = false;
    bool checkCollectByMachine = false;
    return InkWell(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (_, __, ___) => OrderDetailsScreen(
          orderId: widget.order?.id,
          fromNotification: false,
        ),
      )),
      child: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: 1.5.h, left: 2.h, top: 1.h, bottom: 1.h),
            child: Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      bottomLeft: Radius.circular(40))),
              child: Container(
                padding: EdgeInsets.only(left: 4.h, right: 2.h),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(120))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          'اسم العميل: ${widget.order?.customer?.name}',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                        SmallText(
                          'كود العميل: ${widget.order?.customer?.id}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () =>
                          launch("tel:${widget.order?.customer?.mobile}"),
                      child: SmallText(
                        'رقم العميل: ${widget.order?.customer?.mobile}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        color: primaryColor,
                      ),
                    ),
                    SmallText(
                      'المنطقة: ${widget.order?.zone}',
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SmallText(
                            'الكمباوند: ${widget.order?.address?.compound}',
                          ),
                        ],
                      ),
                    ),
                    widget.order?.provider != null
                        ? SmallText(
                            'المغسلة: ${widget.order?.provider}',
                          )
                        : const SmallText(
                            'المغسلة: لايوجد',
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
                          if (await maplauncher.MapLauncher.isMapAvailable(
                                  maplauncher.MapType.google) ??
                              false) {
                            await maplauncher.MapLauncher.showMarker(
                              mapType: maplauncher.MapType.google,
                              coords: maplauncher.Coords(
                                  widget.order?.address?.lat??0,
                                  widget.order?.address?.long??0),
                              title: "عنوان العميل",
                            );
                          }
                        },
                        child: Text(
                          'الي العنوان',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        )),
                    //     Text(
                    //   'المنطقة: ${widget.order.}',
                    //   style: const TextStyle(fontSize: 12),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          'القيمة الكلية: ${widget.order?.total}',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ConditionalBuilder(
                          condition: widget.state
                              is! PickupDetailsNextStatusLoadingState,
                          fallback: (context) =>
                              const CupertinoActivityIndicator(),
                          builder: (context) => Container(
                            alignment: Alignment.bottomRight,
                            child: widget.order?.nextStatus == null
                                ? widget.order?.canCollect == true
                                    ? ElevatedButton(
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
                                                                    });

                                                                    widget
                                                                        .rebuild!();
                                                                  }),

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
                                        ))
                                    : Container()
                                : ElevatedButton(
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
                                                          orderId:
                                                              widget.order?.id,
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
                                    child: Text(
                                      '${widget.order?.nextStatus}',
                                    )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 9,
            child: Hero(
              tag: '${widget.order?.id}',
              child: Material(
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 40,
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
