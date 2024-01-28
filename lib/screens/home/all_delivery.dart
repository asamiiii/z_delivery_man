import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/models/index_model.dart';
import 'package:z_delivery_man/screens/drawer/cubit.dart';
import 'package:z_delivery_man/screens/drawer/drawer_states.dart';
import 'package:z_delivery_man/screens/home/today.dart';
import 'package:z_delivery_man/screens/provider_app/orders_list/orders_list_screen.dart';
import 'package:z_delivery_man/screens/status_orders/status_orders_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
// opened --> total order or Itemcount
// providerAssigned --> لم يتم استلامه
// provider_received --> تم استلامه
// check_up --> تم الفحص
// finished -- > تم الانتهاء
// from_provider --> تم التسليم للمندوب
// remaining --> المتبقي today only

// ignore: must_be_immutable
class DeliveryTableAll extends StatefulWidget {
  // IndexModel? model;
  DeliveryTableAll({Key? key, }) : super(key: key);

  @override
  State<DeliveryTableAll> createState() => _DeliveryTableAllState();
}

class _DeliveryTableAllState extends State<DeliveryTableAll> {
  @override
  void initState() {
    final drawerCubit = DrawerCubit.get(context);
    drawerCubit..getStatusOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawerCubit,DrawerStates>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        final drawerCubit = DrawerCubit.get(context);
        return state is DrawerLoadingState ? const CircularProgressIndicator(): Container(
          padding: const EdgeInsets.all(15),
          key: const Key('all'),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: drawerCubit.statusOrderModel!.statuses!.today!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor('#ECEEF8')),
                child: ListTile(
                  title: Text(
                    '${drawerCubit.statusOrderModel?.statuses?.today?[index].translate}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: CircleAvatar(
                    child: Text(
                        '${drawerCubit.statusOrderModel?.statuses?.today?[index].count}'),
                  ),
                  onTap: () {
                    navigateTo(
                        context,
                        OrderPerStatusScreen(
                          status: drawerCubit
                              .statusOrderModel?.statuses?.today![index].status,
                          isAll: 0,
                        ));
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 2.h,
              );
            },
          )
          // GridView(
          //   shrinkWrap: true,
          //   physics: const AlwaysScrollableScrollPhysics(),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 10,
          //     childAspectRatio: 0.7,
          //     crossAxisSpacing: 10,
          //   ),
          //   children: [
          //     //? لم يتم استلامه
          //     GestureDetector(
          //       onTap: () {
          //         navigateTo(
          //             context,
          //             const OrdersListScreen(
          //               statusName: 'provider_assigned_all',
          //             ));
          //       },
          //       child: Item(
          //         chocoItem: ItemModel(
          //             label: ' لم يتم استلامه ',
          //             itemCount: '${model?.all?.itemCount.providerAssigned?? '0'}',
          //             orderCount: '${model?.all?.orderCount.providerAssigned?? '0'}',
          //             image: 'assets/images/R.png'),
          //       ),
          //     ),
          //     //? تم استلامه
          //     GestureDetector(
          //       onTap: () {
          //         navigateTo(
          //             context,
          //             const OrdersListScreen(
          //               statusName: 'provider_received_all',
          //             ));
          //       },
          //       child: Item(
          //           chocoItem: ItemModel(
          //               label: '  تم استلامه  ',
          //               itemCount: '${model?.all?.itemCount.providerReceived?? '0'}',
          //               orderCount: '${model?.all?.orderCount.providerReceived?? '0'}',
          //               image: 'assets/images/press.png')),
          //     ),
      
          //     //? تم الفحص
          //     GestureDetector(
          //       onTap: () {
          //         navigateTo(
          //             context,
          //             const OrdersListScreen(
          //               statusName: 'check_up_all',
          //             ));
          //       },
          //       child: Item(
          //           chocoItem: ItemModel(
          //               label: 'تم الفحص',
          //               itemCount: '${model?.all?.itemCount.checkUp ?? '0'}',
          //               orderCount: '${model?.all?.orderCount.checkUp??'0'}',
          //               image: 'assets/images/q.png')),
          //     ),
      
          //     //? تم الانتهاء
          //     GestureDetector(
          //       onTap: () {
          //         navigateTo(
          //             context,
          //             const OrdersListScreen(
          //               statusName: 'finished_all',
          //             ));
          //       },
          //       child: Item(
          //           chocoItem: ItemModel(
          //               label: 'تم الانتهاء',
          //               itemCount: '${model?.all?.itemCount.finished?? '0'}',
          //               orderCount: '${model?.all?.orderCount.finished?? '0'}',
          //               image: 'assets/images/finished.png')),
          //     ),
      
          //     //? تم التسليم للمندوب
          //     GestureDetector(
          //       onTap: () {
          //         navigateTo(
          //             context,
          //             const OrdersListScreen(
          //               statusName: 'from_provider_all',
          //             ));
          //       },
          //       child: Item(
          //           chocoItem: ItemModel(
          //               label: 'تم التسليم',
          //               itemCount: '${model?.all?.itemCount.opened?? '0'}',
          //               orderCount: '${model?.all?.orderCount.opened?? '0'}',
          //               image: 'assets/images/done.png')),
          //     ),
      
          //     //? العدد الاجمالي
          //     GestureDetector(
          //       onTap: () {
          //         navigateTo(
          //             context,
          //             const OrdersListScreen(
          //               statusName: 'opened_all',
          //             ));
          //       },
          //       child: Item(
          //           chocoItem: ItemModel(
          //               label: 'العدد الإجمالي',
          //               itemCount: '${model?.all?.itemCount.opened??0}',
          //               orderCount: '${model?.all?.orderCount.opened??0}',
          //               image: 'assets/images/all.png')),
          //     ),
      
          //   ],
          // ),
          );},
    );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               const Text('الكل',style: TextStyle(color:Colors.black,fontSize: 30)),
    //                               const SizedBox(height: 5,),
    //                               SizedBox(
    //                                 // height: MediaQuery.of(context).size.height*0.25,
    //                                 // width: MediaQuery.of(context).size.width*0.20,
    //                                 child: DataTable(
    //                                   columnSpacing: 30,
    //                                   dataRowHeight: 45,
    //                                   border: TableBorder.all(color: Colors.black),
    //                                 columns: const[
    //                                   DataColumn(label: Text('')),
    //                                   DataColumn(label: Text('الطلبات',style: TextStyle(color:Colors.black),)),
    //                                   DataColumn(label: Text('القطع',style: TextStyle(color:Colors.black))),
    //                                 ],
    //                                 rows: [
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#e4edf2')),
    //                                     cells: [
    //                                      DataCell(const Text('العدد الاجمالي',style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold)),onTap: () {
    //                                       navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'opened_all',
    //                                           ));
    //                                     },),
    //                                     DataCell(Center(child: Text('${model?.all?.orderCount.opened}',style: const TextStyle(color:Colors.green,fontWeight: FontWeight.bold)))),
    //                                     DataCell(Center(child: Text('${model?.all?.itemCount.opened}',style: const TextStyle(color:Colors.green,fontWeight: FontWeight.bold)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#cde2ee')),
    //                                     cells: [
    //                                      DataCell(const Text('لم يتم استلامه',style: TextStyle(color:Colors.black)),onTap: () {
    //                                       navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'provider_assigned_all',
    //                                           ));
    //                                     },),
    //                                     DataCell(Center(child: Text('${model?.all?.orderCount.providerAssigned}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.all?.itemCount.providerAssigned}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#bbdcf0')),
    //                                     cells: [
    //                                      DataCell(const Text('تم استلامه',style: TextStyle(color:Colors.black)),onTap: () {
    //                                       navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'provider_received_all',
    //                                           ));
    //                                     },),
    //                                     DataCell(Center(child: Text('${model?.all?.orderCount.providerReceived}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.all?.itemCount.providerReceived}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#a8daf9')),
    //                                     cells: [
    //                                      DataCell(const Text('تم الفحص',style: TextStyle(color:Colors.black)),onTap: () {
    //                                       navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'check_up_all',
    //                                           ));
    //                                     },),
    //                                     DataCell(Center(child: Text('${model?.all?.orderCount.checkUp}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.all?.itemCount.checkUp}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#92d2f9')),
    //                                     cells: [
    //                                      DataCell(const Text('تم الانتهاء',style: TextStyle(color:Colors.black)),
    //                                      onTap: () {
    //                                       navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'finished_all',
    //                                           ));
    //                                     },),
    //                                     DataCell(Center(child: Text('${model?.all?.orderCount.finished}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.all?.itemCount.finished}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#92d2f9')),
    //                                     cells: [
    //                                      DataCell(
    //                                       const Text('تم التسليم للمندوب',style: TextStyle(color:Colors.black),),onTap: () {
    //                                         navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'from_provider_all',
    //                                           ));
    //                                       },),
    //                                     DataCell(Center(child: Text('${model?.all?.orderCount.fromProvider}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.all?.itemCount.fromProvider}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   // DataRow(cells: [
    //                                   //   const DataCell(Text('المتبقي',style: TextStyle(color:Colors.red))),
    //                                   //   DataCell(Center(child: Text('${model?.all?.orderCount.providerReceived}',style: const TextStyle(color:Colors.white)))),
    //                                   //   DataCell(Center(child: Text('${model?.all?.itemCount.providerReceived}',style: const TextStyle(color:Colors.white)))),
    //                                   // ])
    //                                 ],

    //                                 ),
    //                               ),
    //                             ],
    //                           );
  }
}
