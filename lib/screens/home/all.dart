import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:z_delivery_man/models/index_model.dart';
import 'package:z_delivery_man/screens/home/today.dart';
import 'package:z_delivery_man/screens/provider_app/orders_list/orders_list_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';
// opened --> total order or Itemcount
// providerAssigned --> لم يتم استلامه
// provider_received --> تم استلامه
// check_up --> تم الفحص
// finished -- > تم الانتهاء
// from_provider --> تم التسليم للمندوب
// remaining --> المتبقي today only

// ignore: must_be_immutable
class TableAll extends StatelessWidget {
  IndexModel? model;
  TableAll({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      key: const Key('all'),
      child: GridView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
        ),
        children: [
          //? لم يتم استلامه
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'provider_assigned_all',
                  ));
            },
            child: Item(
              chocoItem: ItemModel(
                  label: ' لم يتم استلامه ',
                  itemCount: '${model?.all?.itemCount.providerAssigned}',
                  orderCount: '${model?.all?.orderCount.providerAssigned}',
                  image: 'assets/images/R.png'),
            ),
          ),
          //? تم استلامه
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'provider_received_all',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: '  تم استلامه  ',
                    itemCount: '${model?.all?.itemCount.providerReceived}',
                    orderCount: '${model?.all?.orderCount.providerReceived}',
                    image: 'assets/images/press.png')),
          ),

          //? تم الفحص
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'check_up_all',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'تم الفحص',
                    itemCount: '${model?.all?.itemCount.checkUp}',
                    orderCount: '${model?.all?.orderCount.checkUp}',
                    image: 'assets/images/q.png')),
          ),

          //? تم الانتهاء
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'finished_all',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'تم الانتهاء',
                    itemCount: '${model?.all?.itemCount.finished}',
                    orderCount: '${model?.all?.orderCount.finished}',
                    image: 'assets/images/finished.png')),
          ),

          //? تم التسليم للمندوب
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'from_provider_all',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'تم التسليم',
                    itemCount: '${model?.all?.itemCount.opened}',
                    orderCount: '${model?.all?.orderCount.opened}',
                    image: 'assets/images/done.png')),
          ),

          //? العدد الاجمالي
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'opened_all',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'العدد الإجمالي',
                    itemCount: '${model?.all?.itemCount.opened}',
                    orderCount: '${model?.all?.orderCount.opened}',
                    image: 'assets/images/all.png')),
          ),
          
        ],
      ),
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
