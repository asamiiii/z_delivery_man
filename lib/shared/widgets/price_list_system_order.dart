// ignore_for_file: avoid_unnecessary_containers

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
                    item: widget.item,
                    index: widget.index,
                    // cartsViewModel: cartsViewModel,
                    cubit: cubit)),
          ],
        ));
      },
    );
  }
}

class OrderItemSystem extends StatefulWidget {
  const OrderItemSystem({Key? key, this.item, this.index, this.cubit})
      : super(key: key);
  final Items? item;
  final int? index;

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
            height: 32,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200),
            child: Center(
              child: Form(
                child: TextFormField(
                  controller: widget.item?.txtController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  // initialValue: widget.item.selectedQuantity.toString(),
                  decoration: const InputDecoration(
                    hintText: "0",
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  // onSaved: (newValue) {
                  //   if (int.tryParse(newValue) == 0) {
                  //     widget.item.selectedQuantity = int.tryParse(newValue);
                  //   } else {
                  //     setState(() {
                  //       widget.cubit.selectedItems.add(widget.item);
                  //       widget.item.selectedQuantity = int.tryParse(newValue);
                  //       // item.selectedQuantity =
                  //       //     int.tryParse(textEditingController.text);
                  //     });
                  //   }
                  // },
                  onFieldSubmitted: (newValue) {
                    if (int.tryParse(newValue) == 0) {
                      widget.item?.selectedQuantity = int.tryParse(newValue);
                    } else {
                      if (widget.item?.txtController?.text != null) {
                        setState(() {
                          widget.cubit?.selectedItems.add(widget.item!);
                          widget.item?.selectedQuantity =
                              int.tryParse(newValue);
                          // item.selectedQuantity =
                          //     int.tryParse(textEditingController.text);
                        });
                      }
                    }
                  },
                ),
              ),
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
