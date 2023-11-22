// ignore_for_file: avoid_unnecessary_containers

import 'dart:math';

// import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:z_delivery_man/screens/provider_app/price_list/widget.dart';
import 'package:z_delivery_man/styles/color.dart';

import '/../models/price_list_model.dart';
import '/../screens/order_details/cubit.dart';
import '/../screens/order_details/order_details_state.dart';
import '/../shared/widgets/image_as_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PriceListSystemOrder extends StatefulWidget {
  final Items? item;
  final int? index;
  final int? indexList;
  final bool fromShoppingCard;
  final bool isMetersView;
  final Function? increase;
  final Function? decrease;
  // final CartsModel cartsModel;

  const PriceListSystemOrder(
      {Key? key,
      required this.item,
      // this.cartsModel,
      this.index,
      this.indexList,
      this.fromShoppingCard = false,
      this.isMetersView = false,
      this.increase,
      this.decrease})
      : super(key: key);
  @override
  _PriceListSystemOrderState createState() => _PriceListSystemOrderState();
}

class _PriceListSystemOrderState extends State<PriceListSystemOrder> {
  @override
  void initState() {
    super.initState();
    // Provider.of<CartsViewModel>(context, listen: false).getCartList();
    // Provider.of<CartsViewModel>(context, listen: false).getShoppingCartsData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = OrderDetailsCubit.get(context);
        return Container(
            // cartsViewModel.isLoading
            //     ? CustomLoading()
            //     :
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  ImageAsIcon(
                    image: widget.item?.icon,
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
                          "${widget.item?.name} (${widget.item?.categoryItemServiceId})",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
                alignment: Alignment.bottomRight,
                child: OrderItemSystem(
                    isMetersView: widget.isMetersView,
                    item: widget.item,
                    index: widget.index,
                    // cartsViewModel: cartsViewModel,
                    cubit: cubit)),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
      },
    );
  }
}

class OrderItemSystem extends StatefulWidget {
  const OrderItemSystem(
      {Key? key, this.item, this.index, this.cubit, this.isMetersView = false})
      : super(key: key);
  final Items? item;
  final int? index;
  final bool isMetersView;
  final OrderDetailsCubit? cubit;

  @override
  State<OrderItemSystem> createState() => _OrderItemSystemState();
}

class _OrderItemSystemState extends State<OrderItemSystem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            // height: 32,
            // width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
                child: orderItemSystem(
              index: widget.index,
              cubit: widget.cubit,
              item: widget.item,
              isMetersView: widget.isMetersView,
            )
                // Form(
                //   child: TextFormField(
                //     controller: widget.item?.txtController,
                //     textAlignVertical: TextAlignVertical.center,
                //     keyboardType:
                //         const TextInputType.numberWithOptions(decimal: true),
                //     textAlign: TextAlign.center,
                //     // initialValue: widget.item.selectedQuantity.toString(),
                //     decoration: const InputDecoration(
                //       hintText: "0",
                //       border: InputBorder.none,
                //       isCollapsed: true,
                //       contentPadding: EdgeInsets.zero,
                //     ),
                //     // onSaved: (newValue) {
                //     //   if (int.tryParse(newValue) == 0) {
                //     //     widget.item.selectedQuantity = int.tryParse(newValue);
                //     //   } else {
                //     //     setState(() {
                //     //       widget.cubit.selectedItems.add(widget.item);
                //     //       widget.item.selectedQuantity = int.tryParse(newValue);
                //     //       // item.selectedQuantity =
                //     //       //     int.tryParse(textEditingController.text);
                //     //     });
                //     //   }
                //     // },
                //     onFieldSubmitted: (newValue) {
                //       if (int.tryParse(newValue) == 0) {
                //         widget.item?.selectedQuantity = int.tryParse(newValue);
                //       } else {
                //         if (widget.item?.txtController?.text != null) {
                //           setState(() {
                //             widget.cubit?.selectedItems.add(widget.item!);
                //             widget.item?.selectedQuantity =
                //                 int.tryParse(newValue);
                //             // item.selectedQuantity =
                //             //     int.tryParse(textEditingController.text);
                //           });
                //         }
                //       }
                //     },
                //   ),
                // ),
                )
            //  Center(
            //     child: Text(
            //   item.selectedQuantity.toString(),
            //   style: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600),
            // ))
            ),
        // InkWell(
        //     borderRadius: BorderRadius.circular(32),
        //     onTap: () {
        //       // cartsViewModel.increaseOrDecreaseOrderCount(
        //       //     increase: true, itemIndex: serIndexOrder);
        //       widget.cubit.decreaseQuantityOfItem(widget.item);
        //     },
        //     child: Container(
        //         height: 28,
        //         width: 28,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(32), color: BLUE_RGPO),
        //         child: Icon(
        //           FontAwesomeIcons.plus,
        //           size: 12,
        //           color: primaryColor,
        //         ))),
      ],
    );
  }
}

class orderItemSystem extends StatefulWidget {
  Items? item;
  int? index;
  OrderDetailsCubit? cubit;
  bool isMetersView;
  orderItemSystem(
      {Key? key, this.index, this.item, this.cubit, this.isMetersView = false})
      : super(key: key);

  @override
  _orderItemSystemState createState() => _orderItemSystemState();
}

class _orderItemSystemState extends State<orderItemSystem> {
  

  @override
  Widget build(BuildContext context) {
    TextEditingController hightController = TextEditingController(text:widget.item?.lenght.toString()=='0'?'':widget.item?.lenght.toString());
  TextEditingController widthController = TextEditingController(text:widget.item?.width.toString()=='0'?'':widget.item?.width.toString());
  widthController.selection = TextSelection.fromPosition(
        TextPosition(offset: widthController.text.length));
    hightController.selection = TextSelection.fromPosition(
        TextPosition(offset: hightController.text.length));
    return widget.isMetersView == false
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: () async {
                    decreaseQuantity(item: widget.item!, cubit: widget.cubit);
                    setState(() {});
                  },
                  child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: BLUE_RGPO),
                      child: const Icon(
                        Icons.remove,
                        size: 21,
                        color: Colors.blue,
                      ))),
              Container(
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: Center(
                      child: Text(
                    '${widget.item?.selectedQuantity}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ))),
              InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: () async {
                    increaseQuantity(item: widget.item!,cubit: widget.cubit);
                    setState(() {});
                  },
                  child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: BLUE_RGPO),
                      child: const Icon(
                        Icons.add,
                        size: 21,
                        color: Colors.blue,
                      ))),
            ],
          )
        : Form(
            // key: context.read<MetersViewModel>().formKey,
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    const Text(
                      "الطول",
                      style: TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.14,
                        // height: ,
                        child: CustomTextField(
                          onTap: () {},
                          isMetersHW: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          onChange: (value) {
                            widget.item?.lenght = value;
                            debugPrint(
                                'widget.item.localId : ${widget.item?.localId}');
                            setState(() {});
                          },
                          controller: hightController,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text('X'),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    const Text(
                      'العرض',
                      style: TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.14,
                        child: CustomTextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          isMetersHW: true,
                          onChange: (value) {
                            widget.item?.width = value;
                            debugPrint(
                                'widget.item.localId : ${widget.item?.localId}');
                            setState(() {});
                            debugPrint(value);
                          },
                          controller: widthController,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          );
  }
}


//!-------------------------------Functions-------------------

decreaseQuantity({required Items item, required OrderDetailsCubit? cubit}) {
  debugPrint('minus');
  if (item.withDimension == false) {
    if (item.selectedQuantity! == 0) {
    } else {
      if (item.selectedQuantity! != 1) {
        item.selectedQuantity = (item.selectedQuantity)! - 1;
      } else {
        item.selectedQuantity = (item.selectedQuantity)! - 1;
        cubit?.selectedItems?.remove(item);
      }
    }
  } else {
    if (item.selectedQuantity == 0) {
    } else {
      if (item.selectedQuantity! <= 1) {
        debugPrint('herrrr');
        item.lenght = null;
        item.width = null;
      }
      item.selectedQuantity = (item.selectedQuantity)! - 1;
      Items? itemm =
          cubit?.selectedItems?.firstWhere((element) => element.localId != null);
      cubit?.selectedItems?.remove(itemm);
    }
  }
  debugPrint('widget.item.localId : ${item.localId}');
  debugPrint('selectedItems : ${cubit?.selectedItems}');
}

increaseQuantity({required Items item, required OrderDetailsCubit? cubit}){
  int localId = 0;
                    debugPrint('Add');
                    Random random = Random();
                    localId = random.nextInt(10000000);
                    if (item.withDimension == true) {
                      if (item.selectedQuantity! == 0) {
                        debugPrint(
                            'her selectedQuantity : ${item.selectedQuantity!}');
                        cubit?.selectedItems.add(Items(
                          categoryItemServiceId:
                              item.categoryItemServiceId,
                          icon: item.icon,
                          id: item.id,
                          lenght: '0',
                          width: '0',
                          localId: 0,
                          name: item.name,
                          price: item.price,
                          selectedQuantity: 1,
                          txtController: item.txtController,
                          withDimension: item.withDimension,
                        ));
                      } else {
                        cubit?.selectedItems?.add(Items(
                          categoryItemServiceId:
                              item.categoryItemServiceId,
                          icon: item.icon,
                          id: item.id,
                          lenght: '0',
                          width: '0',
                          localId: localId,
                          name: item.name,
                          price: item.price,
                          selectedQuantity: 1,
                          txtController: item.txtController,
                          withDimension: item.withDimension,
                        ));
                      }
                      item.selectedQuantity =
                          (item.selectedQuantity)! + 1;
                    } else {
                      if (item.selectedQuantity == 0) {
                        debugPrint(
                            'her selectedQuantity : ${item.selectedQuantity!}');
                        cubit?.selectedItems?.add(item);
                        item.selectedQuantity =
                            (item.selectedQuantity)! + 1;
                      } else {
                        item.selectedQuantity =
                            (item.selectedQuantity)! + 1;
                      }
                    }
                    debugPrint('widget.item.localId : ${item.localId}');
                    debugPrint(
                        'selectedItems : ${cubit?.selectedItems}');
}
