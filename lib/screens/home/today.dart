import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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
  IndexModel? model;
  TableToday({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      key: const Key('today'),
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
                    statusName: 'provider_assigned',
                  ));
            },
            child: Item(
              chocoItem: ItemModel(
                  label: ' لم يتم استلامه ',
                  itemCount: '${model?.today?.itemCount.providerAssigned}',
                  orderCount: '${model?.today?.orderCount.providerAssigned}',
                  image: 'assets/images/R.png'),
            ),
          ),
          //? تم استلامه
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'provider_received',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: '  تم استلامه  ',
                    itemCount: '${model?.today?.itemCount.providerReceived}',
                    orderCount: '${model?.today?.orderCount.providerReceived}',
                    image: 'assets/images/press.png')),
          ),
      
          //? تم الفحص
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'check_up',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'تم الفحص',
                    itemCount: '${model?.today?.itemCount.checkUp}',
                    orderCount: '${model?.today?.orderCount.checkUp}',
                    image: 'assets/images/q.png')),
          ),
      
          //? تم الانتهاء
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'finished',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'تم الانتهاء',
                    itemCount: '${model?.today?.itemCount.finished}',
                    orderCount: '${model?.today?.orderCount.finished}',
                    image: 'assets/images/finished.png')),
          ),
      
          //? تم التسليم للمندوب
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'from_provider',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'تم التسليم',
                    itemCount: '${model?.today?.itemCount.opened}',
                    orderCount: '${model?.today?.orderCount.opened}',
                    image: 'assets/images/done.png')),
          ),
      
          //? العدد الاجمالي
          GestureDetector(
            onTap: () {
              navigateTo(
                  context,
                  const OrdersListScreen(
                    statusName: 'opened',
                  ));
            },
            child: Item(
                chocoItem: ItemModel(
                    label: 'العدد الإجمالي',
                    itemCount: '${model?.today?.itemCount.opened}',
                    orderCount: '${model?.today?.orderCount.opened}',
                    image: 'assets/images/all.png')),
          ),
      
          
        ],
      ),
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               const Text('اليوم',style: TextStyle(color:Colors.black,fontSize: 30)),
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
    //                                       DataCell(
    //                                       const Text('العدد الاجمالي',
    //                                          style: TextStyle(color:Colors.green,fontWeight: FontWeight.bold)),
    //                                          onTap: () {
    //                                            navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'opened',
    //                                           ));
    //                                          },
    //                                          ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.opened}',style: const TextStyle(color:Colors.green,fontWeight: FontWeight.bold)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.opened}',style: const TextStyle(color:Colors.green,fontWeight: FontWeight.bold)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#cde2ee')),
    //                                     cells: [
    //                                      DataCell(
    //                                        const Text('لم يتم استلامه',style: TextStyle(color:Colors.black)),
    //                                       onTap: () {
    //                                          navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'provider_assigned',
    //                                           ));
    //                                       },
    //                                       ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.providerAssigned}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.providerAssigned}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#bbdcf0')),
    //                                     cells: [
    //                                      DataCell(
    //                                       const Text('تم استلامه',style: TextStyle(color:Colors.black)),
    //                                       onTap: () {
    // navigateTo(context,
    //   const OrdersListScreen(
    //   statusName: 'provider_received',
    //   ));
    //                                       },
    //                                       ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.providerReceived}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.providerReceived}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#a8daf9')),
    //                                     cells: [
    //                                      DataCell(const Text('تم الفحص',style: TextStyle(color:Colors.black)),
    //                                       onTap: () {
    // navigateTo(context,
    //   const OrdersListScreen(
    //   statusName: 'check_up',
    //   ));
    //                                       },
    //                                       ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.checkUp}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.checkUp}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#92d2f9')),
    //                                     cells: [
    //                                     DataCell(
    //                                     const Text('تم الانتهاء',style: TextStyle(color:Colors.black)),
    //                                         onTap: () {
    // navigateTo(context,
    // const OrdersListScreen(
    // statusName: 'finished',
    // ));
    //                                         },
    //                                         ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.finished}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.finished}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#92d2f9')),
    //                                     cells: [
    //                                     DataCell(
    //                                        const Text('تم التسليم للمندوب',style: TextStyle(color:Colors.black)),
    //                                      onTap: () {
    //  navigateTo(context,
    //     const OrdersListScreen(
    //     statusName: 'from_provider',
    //     ));
    //                                      },
    //                                       ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.fromProvider}',style: const TextStyle(color:Colors.black)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.fromProvider}',style: const TextStyle(color:Colors.black)))),
    //                                   ]),
    //                                   DataRow(
    //                                     color: MaterialStateProperty.all(HexColor('#7297d6')),
    //                                     cells: [
    //                                      DataCell(const Text('المتبقي',style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold)),
    //                                       onTap: () {
    //                                         navigateTo(context,
    //                                           const OrdersListScreen(
    //                                           statusName: 'remaining',
    //                                           ));
    //                                       },
    //                                       ),
    //                                     DataCell(Center(child: Text('${model?.today?.orderCount.remaining}',style: const TextStyle(color:Colors.red,fontWeight: FontWeight.bold)))),
    //                                     DataCell(Center(child: Text('${model?.today?.itemCount.remaining}',style: const TextStyle(color:Colors.red,fontWeight: FontWeight.bold)))),
    //                                   ]),

    //                                 ],

    //                                 ),
    //                               ),
    //                             ],
    //                           );
  }
}

class ItemModel {
  String? label;
  String? orderCount;
  String? itemCount;
  String? image;

  ItemModel({this.itemCount, this.label, this.orderCount, this.image});
}

// ignore: must_be_immutable
class Item extends StatelessWidget {
  int? index;
  ItemModel? chocoItem;
  String? image;
  Item({
    super.key,
    required this.chocoItem,
    this.index,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
                topLeft: Radius.circular(10)),
            child: Container(
              color: Colors.blueAccent,
              height: 210,
              width: 190,
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 20,
            child: Image.asset(
              chocoItem?.image ?? '',
              width: 130,
              height: 130,
              fit: BoxFit.fill,
            )),
        Positioned(
            top: 140,
            right: 30,
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  // height: 50,
                  child: Text(
                    chocoItem?.label ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 17),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      // height: 50,
                      child: Text('الطلبات',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.cairo(
                              color: Colors.white, fontSize: 10)),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    SizedBox(
                      width: 50,
                      // height: 50,
                      child: Text(chocoItem?.orderCount ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.cairo(
                              color: Colors.white, fontSize: 20)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      // height: 50,
                      child: Text(
                        'القطع',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.cairo(
                            color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    SizedBox(
                      width: 50,
                      // height: 50,
                      child: Text(
                        chocoItem?.itemCount ?? '',
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                        style: GoogleFonts.cairo(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: ,)
              ],
            )),
      ],
    );
  }
}
