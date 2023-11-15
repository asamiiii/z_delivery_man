// ignore_for_file: avoid_unnecessary_containers

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
                  const SizedBox(width: 20,),
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
                    const SizedBox(width: 10,),
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
            // width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200),
            child: Center(
              child: 
              orderItemSystem(index: widget.index,cubit: widget.cubit,item: widget.item,)
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
   orderItemSystem({Key? key,this.index,this.item,this.cubit}) : super(key: key);

  @override
  _orderItemSystemState createState() => _orderItemSystemState();
}

class _orderItemSystemState extends State<orderItemSystem> {
  
  @override
  Widget build(BuildContext context) {
    return  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () async{
                      debugPrint('minus');
                      if(widget.item!.selectedQuantity! != 0){
                      //  widget.cubit?.selectedItems.add(widget.item!);
                          widget.item?.selectedQuantity =(widget.item?.selectedQuantity)! -1;
                          if(widget.item!.selectedQuantity! < 1){
                          // widget.item?.selectedQuantity =0;
                        widget.cubit?.selectedItems.removeWhere((element) => element.categoryItemServiceId == widget.item?.categoryItemServiceId );
                        }
                        
                        
                      }
                      setState(() {
                          
                          // item.selectedQuantity =
                          //     int.tryParse(textEditingController.text);
                        });
                        debugPrint('selectedItems : ${widget.cubit?.selectedItems}');
                     
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
                    child:  Center(
                        child: Text(
                       '${widget.item?.selectedQuantity}' ,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ))),
                InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () async {
                      debugPrint('Add');
                      // if (widget.item?.txtController?.text != null) {
                        if(widget.item?.selectedQuantity == 0){
                         widget.cubit?.selectedItems.add(widget.item!);
                          widget.item?.selectedQuantity =(widget.item?.selectedQuantity)! +1;
                        }else{
                          widget.item?.selectedQuantity =(widget.item?.selectedQuantity)! +1;
                        }
                        
                        setState(() {
                          
                          // item.selectedQuantity =
                          //     int.tryParse(textEditingController.text);
                        });
                        debugPrint('selectedItems : ${widget.cubit?.selectedItems}');
                      // }
                    
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
            );
  }
}


  //! Order Item with Price
  // Widget _orderItemSystem() {

   
  //   // double total = 0;
    
    
  //   // cartsViewModel.updateItemLengthWidth(itemIndex: serIndexOrder, lengthOrWidth: widget.cartsModel?.lenght ??'0', isWidth: false);
  //   // cartsViewModel.updateItemLengthWidth(itemIndex: serIndexOrder, lengthOrWidth: widget.cartsModel?.width ??'0', isWidth: true);

  //   // var cartsList = await Hive.openBox<CartsModel>('cartsList');
  //   //! get Key Of item , related to the Item
  //   // dynamic key = cartsList.keyAt(serIndexOrder);
  //   // CartsModel editedData = cartsList.values.toList()[serIndexOrder];

  //   return  Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               InkWell(
  //                   borderRadius: BorderRadius.circular(32),
  //                   onTap: () {
                     
  //                   },
  //                   child: Container(
  //                       height: 32,
  //                       width: 32,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(32),
  //                           color: BLUE_RGPO),
  //                       child: const Icon(
  //                         Icons.remove,
  //                         size: 21,
  //                         color: Colors.blue,
  //                       ))),
  //               Container(
  //                   height: 32,
  //                   margin: const EdgeInsets.symmetric(horizontal: 8),
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 25,
  //                   ),
  //                   decoration: BoxDecoration(
  //                       shape: BoxShape.rectangle,
  //                       borderRadius: BorderRadius.circular(16),
  //                       color: Colors.grey),
  //                   child: const Center(
  //                       child: Text(
  //                      '0' ,
  //                     style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600),
  //                   ))),
  //               InkWell(
  //                   borderRadius: BorderRadius.circular(32),
  //                   onTap: () async {
  //                     if (int.tryParse(newValue) == 0) {
  //                     widget.item?.selectedQuantity = int.tryParse(newValue);
  //                   } else {
  //                     if (widget.item?.txtController?.text != null) {
  //                       setState(() {
  //                         widget.cubit?.selectedItems.add(widget.item!);
  //                         widget.item?.selectedQuantity =
  //                             int.tryParse(newValue);
  //                         // item.selectedQuantity =
  //                         //     int.tryParse(textEditingController.text);
  //                       });
  //                     }
  //                   }
  //                   },
  //                   child: Container(
  //                       height: 32,
  //                       width: 32,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(32),
  //                           color: BLUE_RGPO),
  //                       child: const Icon(
  //                         Icons.add,
  //                         size: 21,
  //                         color: Colors.blue,
  //                       ))),
  //             ],
  //           );
          
  // }