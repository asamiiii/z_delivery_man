import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
import 'package:z_delivery_man/models/price_list_model.dart';
import 'package:z_delivery_man/screens/provider_app/price_list/widget.dart';
import 'package:z_delivery_man/shared/widgets/price_list_system_order.dart';

import '../../order_details/cubit.dart';

class MetersView extends StatelessWidget {
  final int? areaid;
  final int? itemId;
  final int? orderId;
  final int? quantity;

  bool? isUpdate;
  MetersView(
      {Key? key,
      this.areaid,
      this.isUpdate = false,
      this.itemId,
      this.orderId,
      this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderDetailsCubit = OrderDetailsCubit.get(context);
    // var cartViewModel = context.read<CartsViewModel>();
    // var priceListViewModel = context.read<PriceListViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('من فضلك ادخل عدد الامتار لكل قطعه'),
      ),
      body: orderDetailsCubit.selectedItems
              .where((element) => element.withDimension == true)
              .isNotEmpty
          ? Column(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  // margin: const EdgeInsets.only(top: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (_, index2) {
                      List<Items> sortedList = orderDetailsCubit.selectedItems
                          .where((element) => element.withDimension == true)
                          .toList()
                        ..sort((a, b) => a.categoryItemServiceId!
                            .compareTo(b.categoryItemServiceId!));

                      Items item = sortedList[index2];
                      // Category itemAsCat = priceListViewModel.getItem(item);

                      return Column(
                        children: [
                          PriceListSystemOrder(
                            isMetersView: true,
                            fromShoppingCard: true,
                            indexList: index2,
                            // item: itemAsCat,
                            item: item,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      );
                    },
                    itemCount: orderDetailsCubit.selectedItems
                        .where((element) => element.withDimension == true)
                        .length,
                  ),
                )),
                Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                        bgColor: Colors.blue,
                        buttonTitle: isUpdate == false ? 'التالي' : 'تعديل',
                        onPrss: () async {
                          bool validForm = true;
                          for (var element in orderDetailsCubit.selectedItems) {
                            if (element.withDimension == true) {
                              dynamic w = element.width ?? '0';
                              dynamic l = element.lenght ?? '0';
                              if (element.width == '0' ||
                                  element.lenght == '0' ||
                                  element.width == '' ||
                                  element.lenght == '' ||
                                  element.width == '0.0' ||
                                  element.lenght == '0.0' ||
                                  element.width == null ||
                                  element.lenght == null ||
                                  l == null ||
                                  w == null) {
                                validForm = false;
                                break;
                              }
                            }
                          }

                          if (validForm == false) {
                            SharedMethods.showInSnackBar(
                                context: context,
                                message: 'Please Verify The Data',
                                bgColor: Colors.blue);
                          } else {
                            Navigator.pop(context);
                            final cubit = OrderDetailsCubit.get(context);
                            List<Map<String, dynamic>> dataApi = [];
                            List<Map<String, dynamic>> details = [];
                            // List<Map<String, dynamic>> itemDetails =
                            //     [];
                            for (var element in cubit.selectedItems) {
                              if (element.withDimension == true) {
                                details.add({
                                  'category_item_service_id':
                                      element.categoryItemServiceId!,
                                  'quantity': 1,
                                  'width': element.width,
                                  'length': element.lenght,
                                });

                                dataApi.add({
                                  'category_item_service_id':
                                      element.categoryItemServiceId!,
                                  'quantity': 1,
                                  'width': element.width,
                                  'length': element.lenght,
                                  'item_details': jsonEncode([details.last]),
                                });
                              } else {
                                dataApi.add({
                                  'category_item_service_id':
                                      element.categoryItemServiceId!,
                                  'quantity': element.selectedQuantity!,
                                  'width': element.width,
                                  'length': element.lenght,
                                  'item_details': null,
                                });
                              }
                            }

                            for (int i = 0; i < dataApi.length - 1; i++) {
                              for (int j = i + 1; j < dataApi.length; j++) {
                                if (dataApi[j]['category_item_service_id'] ==
                                    dataApi[i]['category_item_service_id']) {
                                  dataApi[i]['length'] = "7"; //! test
                                  dataApi[i]['width'] = "7"; //! test
                                  dataApi[i]['quantity'] +=
                                      dataApi[j]['quantity'];

                                  if (dataApi[i]['item_details'] != null) {
                                    List<Map<String, dynamic>> currentDetails =
                                        List<Map<String, dynamic>>.from(
                                            jsonDecode(
                                                dataApi[i]['item_details']));
                                    currentDetails.addAll(
                                        List<Map<String, dynamic>>.from(
                                            jsonDecode(
                                                dataApi[j]['item_details'])));
                                    dataApi[i]['item_details'] =
                                        jsonEncode(currentDetails);
                                  } else {
                                    dataApi[i]['item_details'] =
                                        jsonEncode(details);
                                  }

                                  dataApi.removeAt(j);
                                  j--;
                                }
                              }
                            }

                            // var cubitt = context.read<OrderDetailsCubit>();
                            if (isUpdate == true) {
                              debugPrint('dataApi:$dataApi');
                              cubit.updateAssociateItems(
                                  itemId: itemId,
                                  orderId: orderId,
                                  quantity: quantity,
                                  data: dataApi[0],
                                  meter: true);
                            }
                          }
                        },
                        fontSize: 16,
                        textColor: Colors.white)),
              ],
            )
          : const Center(child: Text('لايوجد عناصر بالأمتار')),
    );
  }
}
