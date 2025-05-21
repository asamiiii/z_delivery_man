// import 'package:conditional_builder/conditional_builder.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:z_delivery_man/models/order_per_status_provider.dart';
import 'package:z_delivery_man/network/local/user_helper.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_screen.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_cubit.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_state.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/provider_order_details_cubit/provider_conditions.dart';
import 'package:z_delivery_man/screens/order_details/presentation/view/widgets/delivery/order_details_dm_section.dart';
// import 'package:z_delivery_man/screens/order_details/presentation/view/widgets/order_details_provider_section.dart';
import 'package:z_delivery_man/screens/order_details/widgets/order_details_provider_section.dart';
import '../../../../network/local/cache_helper.dart';
import '../../../../shared/widgets/components.dart';
import '../../../../styles/color.dart';
import '../../../provider_app/price_list/price_list_screen.dart';
import '../manager/provider_order_details_cubit/provider_order_details_cubit.dart';
import '../manager/provider_order_details_cubit/provider_order_details_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen(
      {Key? key,
      this.orderId,
      this.fromNotification,
      this.order,
      this.statusName})
      : super(key: key);
  final int? orderId;
  final bool? fromNotification;
  final Orders? order;
  final String? statusName;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isDeliveryMan = false;
  late OrderDetailsCubit providerCubit;
  late DMOrderDetailsCubit dmCubit;

  @override
  void initState() {
    providerCubit = context.read<OrderDetailsCubit>();
    dmCubit = context.read<DMOrderDetailsCubit>();

    super.initState();
    isDeliveryMan =
        UserHelper.getUserType()?.name == UserType.delivery_man.name;
    debugPrint('isDeliveryMan : $isDeliveryMan');
    isDeliveryMan == true
        ? dmCubit.getOrderDetails(orderId: widget.orderId)
        : providerCubit.getProviderOrderDetails(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, providerState) {
        if (providerState is AssociateItemsUpdateSuccess) {
          if (providerState.successModel!.status!) {
            showToast(
                message: 'تم تحديث العدد بنجاح', state: ToastStates.SUCCESS);
            BlocProvider.of<OrderDetailsCubit>(context)
                .getProviderOrderDetails(orderId: widget.orderId);
          }
        } else if (providerState is AssociateItemsUpdateFailed) {
          showToast(message: 'فشل تحديث العدد ', state: ToastStates.ERROR);
        }
        if (providerState is AssociateItemsDeleteSuccess) {
          if (providerState.successModel!.status!) {
            showToast(message: 'تم مسح القطعة', state: ToastStates.SUCCESS);
            BlocProvider.of<OrderDetailsCubit>(context)
                .getProviderOrderDetails(orderId: widget.orderId);
          }
        } else if (providerState is AssociateItemsDeleteFailed) {
          showToast(message: 'فشل الحذف ', state: ToastStates.ERROR);
        }
      },
      builder: (context, providerState) =>
          BlocConsumer<DMOrderDetailsCubit, DMOrderDetailsState>(
        listener: (context, state) {
          if (state is OrderDetailsNextStatusSuccessState) {
            showToast(
                message: 'تم تحديث حالة الاوردر', state: ToastStates.SUCCESS);
            if (isDeliveryMan) {
              dmCubit.getOrderDetails(orderId: widget.orderId);
            } else {
              //  context.read<HomeCubit>().getStatusWithCount();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          } else if (state is OrderDetailsNextStatusFailedState) {
            showToast(
                message: 'فشل تحديث حالة الاوردر', state: ToastStates.ERROR);
          } else if (state is OrderDetailsCollectOrderStatusSuccessState) {
            showToast(
                message: 'collect successfully', state: ToastStates.SUCCESS);
            dmCubit.getOrderDetails(orderId: widget.orderId);
          } else if (state is OrderDetailsCollectOrderStatusFailedState) {
            showToast(message: 'collect Failed', state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          // final cubit = OrderDetailsCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              floatingActionButton: SizedBox(
                width: 150,
                child: ProviderConditions.showAddItemButton(
                        isDeliveyMan: isDeliveryMan,
                        status: widget.statusName ?? '')
                    ? FloatingActionButton(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('إضافة قطع'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.add)
                          ],
                        ),
                        onPressed: () {
                          navigateTo(
                                  context,
                                  PriceListScreen(
                                    orderId: widget.orderId,
                                  ))
                              .then((value) =>
                                  providerCubit.getProviderOrderDetails(
                                      orderId: widget.orderId));
                        },
                      )
                    : const SizedBox(),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              appBar: AppBar(
                title: const Text(
                  'تفاصيل الاوردر',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
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
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () => isDeliveryMan
                    ? dmCubit.getOrderDetails(orderId: widget.orderId)
                    : providerCubit.getProviderOrderDetails(
                        orderId: widget.orderId),
                child: providerState is OrderProviderDetailsLoadingState? ||
                        state is DMOrderDetailsCollectOrderStatusLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            if (isDeliveryMan)
                              ConditionalBuilder(
                                  condition:
                                      state is! DMOrderDetailsLoadingState,
                                  fallback: (context) => const Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                  builder: (context) {
                                    return dmCubit.orderDetailsModel
                                                    ?.newCustomer !=
                                                null &&
                                            dmCubit
                                                .orderDetailsModel!.newCustomer!
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Transform.rotate(
                                                angle: 170,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'رقم الاوردر',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          "#${widget.orderId}",
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
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            ConditionalBuilder(
                                condition: state
                                        is! DMOrderDetailsLoadingState &&
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
                                      cubit: dmCubit,
                                      state: state,
                                      orderId: widget.orderId!,
                                    );
                                  } else {
                                    return ProviderSection(
                                      orderId: widget.orderId!,
                                      cubit: providerCubit,
                                      state: providerState,
                                      order: widget.order,
                                      statusName: widget.statusName,
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
