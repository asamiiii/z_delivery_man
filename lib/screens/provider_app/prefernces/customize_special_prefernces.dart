// ignore_for_file: avoid_unnecessary_containers, prefer_is_empty

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '/../models/perferences_model.dart' as prefmodel;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '/../models/price_list_model.dart' as pricelist;

import '../../../shared/widgets/components.dart';
import '../../../shared/widgets/custom_switch_button.dart';
import '../../../shared/widgets/with_safe_area.dart';
import '../../../styles/color.dart';
import '../../order_details/cubit.dart';
import '../../order_details/order_details_screen.dart';
import '../../order_details/order_details_state.dart';

class CustomizeSpecalPreferences extends StatefulWidget {
  final List<int>? items;
  final List<pricelist.Items>? selectedItems;
  final int? orderId;

  const CustomizeSpecalPreferences(
      {Key? key, this.items, this.selectedItems, this.orderId})
      : super(key: key);
  @override
  _CustomizeSpecalPreferencesState createState() =>
      _CustomizeSpecalPreferencesState();
}

class _CustomizeSpecalPreferencesState
    extends State<CustomizeSpecalPreferences> {
  @override
  void initState() {
    // Provider.of<CustomizeSpecalPreferencesViewModel>(context, listen: false)
    //     .getPreference({'items': widget.items},
    //         Provider.of<UserViewModel>(context, listen: false).userToken());

    super.initState();
  }

  // bool _enableAll = false;
  Widget _buildItem(
      {prefmodel.Items? item,
      // CustomizeSpecalPreferencesViewModel provider,
      OrderDetailsCubit? cubit,
      String? title,
      prefmodel.Data? preferenceModel,
      bool enableAll = false}) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              // item == null
              //     ? SizedBox()
              //     : Row(
              //         children: [
              //           Center(
              //             child: ImageAsIcon(
              //               image: item.icon ?? "",
              //               height: 24.07,
              //               width: 26.55,
              //               fromNetwork: true,
              //               orignalColor: true,
              //             ),
              //           ),
              //           SizedBox(
              //             width: size.width * .05,
              //           ),
              //         ],
              //       ),
              Container(
                  child: Text(
                '${title ?? item?.name}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            cubit?.setItemIsEnabled(
                all: enableAll,
                itemId: item == null ? 0 : item.id,
                preferenceModel: preferenceModel);
          },
          child: Container(
            child: CustomSwitchButton(
              backgroundColor: Colors.grey[200]!,
              unCheckedColor: Colors.white,
              animationDuration: const Duration(milliseconds: 400),
              checkedColor: Colors.white,
              checked: cubit?.checkIfEnable(
                  itemId: item == null ? 0 : item.id,
                  preferenceModel: preferenceModel),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WithSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفضيلات '),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (context) =>
              OrderDetailsCubit()..getPreferences(itemsId: widget.items),
          child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
            listener: (context, state) {
              if (state is AssociateItemsPostSuccess) {
                if (state.successModel!.status!) {
                  showToast(
                      message: 'تم الاضافةالقطع بنجاح',
                      state: ToastStates.SUCCESS);
                  navigateAndReplace(
                      context,
                      OrderDetailsScreen(
                        fromNotification: false,
                        orderId: widget.orderId,
                      ));
                }
              }
              if (state is AssociateItemsPostFailed) {
                showToast(message: 'فشل الاضافة', state: ToastStates.ERROR);
              }
            },
            builder: (context, state) {
              final cubit = OrderDetailsCubit.get(context);
              return ConditionalBuilder(
                condition: state is! PreferencesLoading,
                fallback: (context) => const Center(
                  child: CupertinoActivityIndicator(),
                ),
                builder: (context) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(top: 16),
                    child: cubit.listData.length == 0
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.help_center,
                                color: Colors.black,
                                size: 50,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Center(
                                  child: Text(
                                'NO_PREFRENCESS_AVAILABLE_FOR_ORDER_ITEM',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              )),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: cubit.listData
                                      .map((element) => element.items?.length ==
                                              0
                                          ? const SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildItem(
                                                    title: element.name
                                                    //  +
                                                    // " " +
                                                    // "ALL"
                                                    ,
                                                    cubit: cubit,
                                                    preferenceModel: element,
                                                    enableAll: true),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                const Divider(
                                                  color: Color(0xffF4F4F4),
                                                  thickness: 1.5,
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemBuilder: (_, index) {
                                                      return _buildItem(
                                                        item: element
                                                            .items?[index],
                                                        cubit: cubit,
                                                        preferenceModel:
                                                            element,
                                                        enableAll: false,
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (_, index) {
                                                      return const SizedBox(
                                                        height: 24,
                                                      );
                                                    },
                                                    itemCount:
                                                        element.items!.length),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                              ],
                                            ))
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                ConditionalBuilder(
                                  condition:
                                      state is! AssociateItemsPostLoading,
                                  fallback: (context) => const Center(
                                      child: CupertinoActivityIndicator()),
                                  builder: (context) => ElevatedButton(
                                    onPressed: () {
                                      // print(widget.selectedItems);
                                      // widget.selectedItems.forEach((element) {
                                      //   print(
                                      //       " listData: ${element.categoryItemServiceId} + ${element.selectedQuantity}");
                                      // });
                                      // cubit.prefereceList.forEach((element) {
                                      //   print('pref List : $element');
                                      // });

                                      List<Map<String, dynamic>> itemsList = [];
                                      // widget.selectedItems.forEach((element) {
                                      //   print(
                                      //       " listData: ${element.categoryItemServiceId} + ${element.selectedQuantity}");
                                      // });
                                      for (var ele in widget.selectedItems!) {
                                        itemsList.add({
                                          "category_item_service_id":
                                              ele.categoryItemServiceId,
                                          "quantity": ele.selectedQuantity
                                        });
                                      }
                                      List<Map<String, dynamic>> prefList = [];
                                      for (var ele in cubit.prefereceList) {
                                        prefList.add({
                                          "item_id": ele['item_id'],
                                          "preference_id": ele['preference_id']
                                        });
                                      }
                                      // print('items List $itemsList');
                                      // print('Pref List $prefList');
                                      cubit.postAssociateItems(
                                          orderId: widget.orderId,
                                          itemList: itemsList,
                                          prefernces: prefList);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w)),
                                    child: const Text('انتهاء'),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ),
                          )),
              );
            },
          ),
        ),
      ),
    );
  }
}
