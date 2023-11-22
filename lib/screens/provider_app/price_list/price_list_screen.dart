// import 'package:conditional_builder/conditional_builder.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/provider_app/price_list/meters_view.dart';

import '../../../shared/widgets/components.dart';
import '../../../styles/color.dart';
import '../../order_details/cubit.dart';
import '../../order_details/order_details_state.dart';
import '../prefernces/customize_special_prefernces.dart';
import 'clothes_list.dart';
import 'clothes_type_list.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({Key? key, this.orderId}) : super(key: key);
  final int? orderId;

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    var cubit = context.read<OrderDetailsCubit>();
    cubit.getPriceList(orderId: widget.orderId);
    cubit.selectedItems.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final orderDetailsCubit = OrderDetailsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text('كود الاوردر: ${widget.orderId}'),
            centerTitle: true,
            actions: [ElevatedButton(
                style:ButtonStyle(backgroundColor:MaterialStateProperty.all(primaryColor) ) ,
                onPressed: () {
                  showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child:  MetersView(),
                          ),
                        );
                },
                child: const Text('تعديل الامتار'))],
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25)),
                    height: 40,
                    child: ConditionalBuilder(
                      condition: state is! PriceListLoading,
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      builder: (context) => Column(
                        children: [
                          
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: orderDetailsCubit.priceList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    orderDetailsCubit.setSelectedServicesId(
                                        orderDetailsCubit.priceList[index].id);
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: orderDetailsCubit
                                                    .priceList[index].id ==
                                                orderDetailsCubit.selectedServicesId
                                            ? primaryColor
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(25)),
                                    child: Center(
                                      child: Text(
                                        '${orderDetailsCubit.priceList[index].name}',
                                        style: TextStyle(
                                            color: orderDetailsCubit
                                                        .priceList[index].id ==
                                                    orderDetailsCubit
                                                        .selectedServicesId
                                                ? Colors.white
                                                : Colors.grey.shade500),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                width: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  ConditionalBuilder(
                      condition: state is! PriceListLoading,
                      fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      builder: (context) => const ClothesTypeList()),
                  SizedBox(
                    height: 1.h,
                  ),
                  SearchInput(
                    hintText: 'ابحث عن الصنف',
                    searchController: searchController,
                    onChanged: orderDetailsCubit.onSearchTextChanged,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  ConditionalBuilder(
                      condition: state is! PriceListLoading,
                      fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      builder: (context) => ClothesListWithPrice(
                            isSearch:
                                orderDetailsCubit.searchPriceList!.isNotEmpty,
                          )),
                  SizedBox(
                    height: 1.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // orderDetailsCubit.formKey.currentState.save();
                      // List<int> itemsInt = [];
                      // for (var item in orderDetailsCubit.selectedItems) {
                      //   itemsInt.add(item.id!);
                      // }
                      List<Map<String, dynamic>> items = [];
                      for (var element in orderDetailsCubit.selectedItems) {
                        items.add({
                          'item_id': element.id,
                          'category_item_service_id':
                              element.categoryItemServiceId
                        });
                      }

                      debugPrint('pref : $items');
                      bool validForm = true;
                      for (var element in orderDetailsCubit.selectedItems) {
                        debugPrint('Local Id : ${element.localId}');
                        if (element.withDimension == true) {
                          if (element.width == '0' ||
                              element.lenght == '0' ||
                              element.width == '' ||
                              element.lenght == '' ||
                              element.width == '0.0' ||
                              element.lenght == '0.0' ||
                              element.width == null ||
                              element.lenght == null) {
                            validForm = false;

                            break;
                          }
                        }
                      }
                      if (validForm == false) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           MetersView(
                        //               areaid: widget
                        //                   .areaId),
                        //     ));
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child:  MetersView(),
                          ),
                        );
                      } else {
                        navigateTo(
                            context,
                            CustomizeSpecalPreferences(
                                items: items,
                                selectedItems: orderDetailsCubit.selectedItems,
                                orderId: widget.orderId));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 15.w)),
                    child: const Text(
                      'متابعة',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final Function(String)? onChanged;

  const SearchInput(
      {required this.searchController,
      required this.hintText,
      Key? key,
      this.onChanged})
      : super(
          key: key,
        );

  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primaryColor, primaryColor]),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
      child: TextField(
        controller: searchController,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: accentColor),
        decoration: InputDecoration(
          // prefixIcon: Icon(Icons.email),
          prefixIcon: Icon(Icons.search, size: 20, color: accentColor),
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(color: accentColor.withOpacity(.75)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
