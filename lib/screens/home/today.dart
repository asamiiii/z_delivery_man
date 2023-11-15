import 'package:flutter/material.dart';
import 'package:z_delivery_man/models/index_model.dart';
import 'package:z_delivery_man/screens/provider_app/orders_list/orders_list_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';

// opened --> total order or Itemcount
// providerAssigned --> لم يتم استلامه
// provider_received --> تم استلامه
// check_up --> تم الفحص
// finished -- > تم الانتهاء
// from_provider --> تم التسليم للمندوب
// remaining --> المتبقي today only

// ignore: must_be_immutable
class TableToday extends StatelessWidget {
  IndexModel? model ;
   TableToday({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('اليوم',style: TextStyle(color:Colors.black,fontSize: 30)),
                                  const SizedBox(height: 5,),
                                  SizedBox(
                                    // height: MediaQuery.of(context).size.height*0.25,
                                    // width: MediaQuery.of(context).size.width*0.20,
                                    child: DataTable(
                                      columnSpacing: 30,
                                      dataRowHeight: 45,
                                      border: TableBorder.all(color: Colors.black),
                                    columns: const[
                                      DataColumn(label: Text('')),
                                      DataColumn(label: Text('الطلبات',style: TextStyle(color:Colors.black),)),
                                      DataColumn(label: Text('القطع',style: TextStyle(color:Colors.black))),
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                          DataCell(
                                          const Text('العدد الاجمالي',
                                             style: TextStyle(color:Colors.green)),
                                             onTap: () {
                                               navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'opened',
                                              ));
                                             },
                                             ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.opened}',style: const TextStyle(color:Colors.green)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.opened}',style: const TextStyle(color:Colors.green)))),
                                      ]),
                                      DataRow(cells: [
                                         DataCell(
                                           const Text('لم يتم استلامه',style: TextStyle(color:Colors.black)),
                                          onTap: () {
                                             navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'provider_assigned',
                                              ));
                                          },
                                          ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.providerAssigned}',style: const TextStyle(color:Colors.black)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.providerAssigned}',style: const TextStyle(color:Colors.black)))),
                                      ]),
                                      DataRow(cells: [
                                         DataCell(
                                          const Text('تم استلامه',style: TextStyle(color:Colors.black)),
                                          onTap: () {
                                            navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'provider_received',
                                              ));
                                          },
                                          ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.providerReceived}',style: const TextStyle(color:Colors.black)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.providerReceived}',style: const TextStyle(color:Colors.black)))),
                                      ]),
                                      DataRow(cells: [
                                         DataCell(const Text('تم الفحص',style: TextStyle(color:Colors.black)),
                                          onTap: () {
                                            navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'check_up',
                                              ));
                                          },
                                          ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.checkUp}',style: const TextStyle(color:Colors.black)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.checkUp}',style: const TextStyle(color:Colors.black)))),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(
                                        const Text('تم الانتهاء',style: TextStyle(color:Colors.black)),
                                            onTap: () {
                                              navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'finished',
                                              ));
                                            },
                                            ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.finished}',style: const TextStyle(color:Colors.black)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.finished}',style: const TextStyle(color:Colors.black)))),
                                      ]),
                                      DataRow(
                                        
                                        cells: [
                                        DataCell(
                                           const Text('تم التسليم للمندوب',style: TextStyle(color:Colors.black)),
                                         onTap: () {
                                           navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'from_provider',
                                              ));
                                         },
                                          ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.fromProvider}',style: const TextStyle(color:Colors.black)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.fromProvider}',style: const TextStyle(color:Colors.black)))),
                                      ]),
                                      DataRow(cells: [
                                         DataCell(const Text('المتبقي',style: TextStyle(color:Colors.red)),
                                          onTap: () {
                                            navigateTo(context,
                                              const OrdersListScreen(
                                              statusName: 'remaining',
                                              ));
                                          },
                                          ),
                                        DataCell(Center(child: Text('${model?.today?.orderCount.remaining}',style: const TextStyle(color:Colors.red)))),
                                        DataCell(Center(child: Text('${model?.today?.itemCount.remaining}',style: const TextStyle(color:Colors.red)))),
                                      ]),
                                      
                                    ],
                                  
                                    ),
                                  ),
                                ],
                              );
  }
}