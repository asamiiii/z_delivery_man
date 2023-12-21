import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/shared/widgets/image_as_icon.dart';
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
    debugPrint('statusName : ${widget.statusName}');
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
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'حالة: ${BlocProvider.of<HomeCubit>(context).handleStatusName(widget.statusName)}',
                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                ),
              ),
              backgroundColor: primaryColor,
            ),
            body: state is OrdersListLoading
                ? const Center(child: CircularProgressIndicator())
                : ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      showLeading: false,
                      color: primaryColor,
                      axisDirection: AxisDirection.down,
                      child: cubit.orders!.isNotEmpty
                          ? ListView.builder(
                              controller: _controller,
                              shrinkWrap: true,
                              itemCount: cubit.orders!.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                child: OrdersSection(
                                  statusName: widget.statusName,
                                    order: cubit.orders![index],
                                    state: state,
                                    cubit: cubit),
                              ),
                                  // separatorBuilder: (context, index) => const SizedBox(height: 10,),
                                  )
                          :  Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Oredrs',
                                  style: GoogleFonts.cairo(
                                    fontSize: 40
                                ),
                                ),
                                const Icon(
                                  Icons.breakfast_dining,
                                  size: 33,
                                )
                              ],
                            )),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class OrdersSection extends StatefulWidget {
   OrdersSection({
    Key? key,
    this.order,
    this.state,
    this.cubit,
    this.statusName
  }) : super(key: key);
  final Orders? order;
  final OrderslistState? state;
  final OrderslistCubit? cubit;
  String? statusName;

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
  void initState() {
    debugPrint('status : ${widget.statusName}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      onTap: () {
        debugPrint('the current :${widget.order?.currentStatus} ');
        if (widget.order?.currentStatus == 'تم اسنادة الي المغسلة' ||
            widget.order?.currentStatus == 'في الطريق الي المغسلة') {
               showToast(
                    message: 'لا يوجد صلاحية علي الأوردر',
                    state: ToastStates.SUCCESS);
        } else {
          navigateTo(
              context,
              OrderDetailsScreen(
                fromNotification: false,
                orderId: widget.order?.id,
                order: widget.order,
              ));
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
             borderRadius: BorderRadius.circular(25)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                     Text('كود العميل',style: GoogleFonts.cairo(),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.order?.customerCode}',style: GoogleFonts.cairo(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
                Row(
                  children: [
                     Text('تاريخ الاستلام',),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.order?.pick?.date}',style: GoogleFonts.cairo(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 5,),
                // Row(
                //   children: [
                //      Text(' من : ',style: GoogleFonts.cairo(),),
                //     Text('${widget.order?.pick?.from}',style: GoogleFonts.cairo(fontSize: 20,fontWeight: FontWeight.bold),),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //      Text(' الي : ',style: GoogleFonts.cairo(),),
                //     Text('${widget.order?.pick?.to}',style: GoogleFonts.cairo(fontSize: 20,fontWeight: FontWeight.bold),)
                //   ],
                // ),
                // const SizedBox(height: 5,),
                Row(
                  children: [
                     Text('تاريخ التسليم',style: GoogleFonts.cairo(),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.order?.deliver?.date}',style: GoogleFonts.cairo(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 5,),
                // Row(
                //   children: [
                //      Text(' من : ',style: GoogleFonts.cairo(),),
                //     Text('${widget.order?.deliver?.from}',style: GoogleFonts.cairo(fontSize: 20,fontWeight: FontWeight.bold),),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //      Text(' الي : ',style: GoogleFonts.cairo(),),
                //     Text('${widget.order?.deliver?.to}',style: GoogleFonts.cairo(fontSize: 20,fontWeight: FontWeight.bold),)
                //   ],
                // ),
                // widget.order?.pickDeliveryMan != null
                //     ? Row(
                //         children: [
                //           const Text('مندوب الاستلام : '),
                //           Text('${widget.order?.pickDeliveryMan}'),
                //         ],
                //       )
                //     : const SizedBox(),
                // widget.order?.deliverDeliveryMan != null
                //     ? Row(
                //         children: [
                //           const Text('مندوب التوصيل : '),
                //           Text('${widget.order?.deliverDeliveryMan}'),
                //         ],
                //       )
                //     : const SizedBox(),
                 widget.order?.currentStatus != 'تم اسنادة الي المغسلة'? Row(
                  children: [
                     Text('عدد القطع',style: GoogleFonts.cairo(),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.order?.itemsCount}',style: GoogleFonts.cairo(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ):const SizedBox(),


                Row(
                  children: [
                     Text('نوع الخدمه',style: GoogleFonts.cairo(),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.order?.serviceType}',style: GoogleFonts.cairo(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
                
                //! White space
                const SizedBox(
                  height: 5,
                ),
                ConditionalBuilder(
                  condition: widget.state is! OrderNextStatusLoadingState,
                  fallback: (context) => const CupertinoActivityIndicator(),
                  builder: (context) => Container(
                    alignment: Alignment.bottomRight,
                    child:
                        widget.order?.nextStatus == null ||
                                widget.order?.coreNextStatus == "check_up"
                            ? Container()
                            : ElevatedButton(
                                onPressed: () {
                                  widget.order?.coreNextStatus ==
                                          'provider_received'
                                      ? showCupertinoDialog(
                                          context: context,
                                          builder: (contextt) =>
                                              CupertinoAlertDialog(
                                                title:  Text('!تاكيد',style: GoogleFonts.cairo(),),
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
                                                          'provider_received')
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
                                                    child:  Text('نعم',style: GoogleFonts.cairo(),),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      widget.cubit?.goToNextStatus(
                                                          isDeliveryMan:
                                                              false,
                                                          orderId: widget
                                                              .order?.id,
                                                          itemCount: int.tryParse(
                                                              itemCountController
                                                                  .text),
                                                          comment:
                                                              commentController
                                                                  .text);
                                                      debugPrint(
                                                          'goToNextStatus');
                                                     
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
                                              ))
                                      : showModalBottomSheet(
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
                                                     Text(
                                                      'تفضيلات الأوردر',
                                                      style:GoogleFonts.cairo(fontSize: 20),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    widget.order?.prefrences
                                                                ?.isEmpty ??
                                                            false
                                                        ?  Center(
                                                            child: Text(
                                                            'لا يوجد تفضيلات',
                                                            style: GoogleFonts.cairo(fontSize: 30),
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
                                                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                                                                        widget.order!.prefrences?.length ??
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
                                                     Text(
                                                      'تعليقات الأوردر',style: GoogleFonts.cairo(),
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
                                },
                                child: Text(
                                  '${widget.order?.nextStatus}',
                                  style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                )),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 10,
            // bottom: 10,
            left: 9,
            child: Hero(
              tag: '${widget.order?.id}',
              child: Material(
                color: Colors.transparent,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'رقم الاوردر',
                        style:GoogleFonts.cairo(color: Colors.white,fontSize: 10),
                      ),
                      Text(
                        "#${widget.order?.id}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(color: Colors.white,fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              // top: 20,
              bottom: 25,
              left: 9,
              child: InkWell(
                  onTap: () {
                    debugPrint('pref : ${widget.order?.prefrences}');
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // enableDrag: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                          padding: const EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height * 0.50,
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
                              widget.order?.prefrences?.isEmpty ?? false
                                  ?  Center(
                                      child: Text(
                                      'لا يوجد تفضيلات',
                                      style: GoogleFonts.cairo(fontSize: 30,),
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
                                                  image: widget.order
                                                      ?.prefrences?[index].icon,
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
                                                        style: GoogleFonts.cairo()
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${widget.order?.prefrences?[index].preference}',
                                                  style: GoogleFonts.cairo(),
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 15,
                                              ),
                                          itemCount: widget
                                                  .order!.prefrences?.length ??
                                              0),
                                    )
                            ],
                          )),
                    );
                  },
                  child:  Row(
                    children: [Image.asset('assets/images/pref.png',height: 30,width: 30,color: Colors.green,)],
                  ))),
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
                                // const Expanded(child: SizedBox()),
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
                  child:  Row(
                    children: [
                      Image.asset('assets/images/comments.png',height: 30,width: 30,)
                    ],
                  ))),
        ],
      ),
    );
  }
}
