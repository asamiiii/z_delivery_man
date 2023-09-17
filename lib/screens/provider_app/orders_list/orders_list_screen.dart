import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../models/order_per_status_provider.dart';
import '../../../shared/widgets/components.dart';
import '../../../styles/color.dart';
import '../../home/cubit.dart';
import '../../order_details/order_details_screen.dart';
import 'cubit/orderslist_cubit.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({Key? key, this.statusName}) : super(key: key);
  final String? statusName;

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  ScrollController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollListeners);
    BlocProvider.of<OrderslistCubit>(context, listen: false)
        .getOrderserStatus(pageIndex: 1, status: widget.statusName);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListeners);
  }

  void _scrollListeners() {
    int? currentPage = BlocProvider.of<OrderslistCubit>(context, listen: false)
        .orderCurrentPage;
    int? lastPgae =
        BlocProvider.of<OrderslistCubit>(context, listen: false).orderlastPage;
    print('currentPage :$currentPage');
    print('lastPage :$lastPgae');
    if (_controller?.position.pixels ==
            (_controller?.position.maxScrollExtent) &&
        currentPage! < lastPgae!) {
      BlocProvider.of<OrderslistCubit>(context, listen: false)
          .getOrderserStatus(
              pageIndex: currentPage + 1, status: widget.statusName);
      BlocProvider.of<OrderslistCubit>(context, listen: false).setCurrentPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderslistCubit, OrderslistState>(
      listener: (context, state) {
        if (state is OrderNextStatusSuccessState) {
          if (state.successModel?.status != null) {
            showToast(
                message: 'تم تحدث حالة الاوردر بنجاح',
                state: ToastStates.SUCCESS);
            BlocProvider.of<OrderslistCubit>(context, listen: false)
                .getOrderserStatus(pageIndex: 1, status: widget.statusName);
          } else {
            showToast(
                message: 'مشكلة في تحديث الاوردر بسبب عدد الاصناف',
                state: ToastStates.ERROR);
          }
        } else if (state is OrderNextStatusFailedState) {
          showToast(message: 'فشل في تحديث الاوردر', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        final cubit = OrderslistCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'حالة: ${BlocProvider.of<HomeCubit>(context).handleStatusName(widget.statusName)}',
              ),
              backgroundColor: primaryColor,
            ),
            body: ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                showLeading: false,
                color: primaryColor,
                axisDirection: AxisDirection.down,
                child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: cubit.orders?.length,
                    itemBuilder: (context, index) => OrdersSection(
                        order: cubit.orders![index],
                        state: state,
                        cubit: cubit)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrdersSection extends StatefulWidget {
  const OrdersSection({
    Key? key,
    this.order,
    this.state,
    this.cubit,
  }) : super(key: key);
  final Orders? order;
  final OrderslistState? state;
  final OrderslistCubit? cubit;

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  var itemCountController = TextEditingController();
  var commentController = TextEditingController();

  @override
  void dispose() {
    itemCountController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            OrderDetailsScreen(
              fromNotification: false,
              orderId: widget.order?.id,
            ));
      },
      child: Stack(
        children: [
          Card(
            elevation: 8,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('تاريخ الاستلام'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('${widget.order?.pick?.date}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('من:'),
                      Text('${widget.order?.pick?.from}'),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('الي:'),
                      Text('${widget.order?.pick?.to}')
                    ],
                  ),
                  Row(
                    children: [
                      const Text('تاريخ التسليم'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('${widget.order?.deliver?.date}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('من:'),
                      Text('${widget.order?.deliver?.from}'),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('الي:'),
                      Text('${widget.order?.deliver?.to}')
                    ],
                  ),
                  ConditionalBuilder(
                    condition: widget.state is! OrderNextStatusLoadingState,
                    fallback: (context) => const CupertinoActivityIndicator(),
                    builder: (context) => Container(
                      alignment: Alignment.bottomRight,
                      child: widget.order?.nextStatus == null ||
                              widget.order?.coreNextStatus == "check_up"
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
                                                if (widget.order
                                                        ?.coreNextStatus ==
                                                    'provider_received')
                                                  TextField(
                                                    controller:
                                                        itemCountController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'item count',
                                                    ),
                                                  ),
                                                TextField(
                                                  controller: commentController,
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
                                                widget.cubit?.goToNextStatus(
                                                    isDeliveryMan: false,
                                                    orderId: widget.order?.id,
                                                    itemCount: int.tryParse(
                                                        itemCountController
                                                            .text),
                                                    comment:
                                                        commentController.text);
                                                Navigator.of(context).pop();
                                                // widget.cubit.deleteCustomer(id: widget.item.id);
                                                // if (BlocProvider.of<OrderDetailsCubit>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .checkedItemsNumber <
                                                //         BlocProvider.of<
                                                //                     OrderDetailsCubit>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .providerOrderDetails
                                                //             .itemCount ||
                                                //     BlocProvider.of<OrderDetailsCubit>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .checkedItemsNumber >
                                                //         BlocProvider.of<
                                                //                     OrderDetailsCubit>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .providerOrderDetails
                                                //             .itemCount) {
                                                //   ScaffoldMessenger.of(context)
                                                //       .showSnackBar(
                                                //           const SnackBar(
                                                //     content:
                                                //         Text('عدم تطابق القطع'),
                                                //     backgroundColor: Colors.red,
                                                //   ));
                                                // } else {

                                                // }
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
                                '${widget.order?.nextStatus}',
                              )),
                    ),
                  )
                ],
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
