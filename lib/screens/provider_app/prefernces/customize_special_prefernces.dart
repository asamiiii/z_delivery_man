// ignore_for_file: avoid_unnecessary_containers, prefer_is_empty

import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:z_delivery_man/models/order_details_model.dart';
import 'package:z_delivery_man/models/perferences_model.dart';
import 'package:z_delivery_man/screens/provider_app/prefernces/widget.dart';
import 'package:z_delivery_man/shared/widgets/image_as_icon.dart';
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
import '../../order_details/presentation/manager/provider_order_details_cubit/provider_order_details_cubit.dart';
import '../../order_details/presentation/view/order_details_screen.dart';
import '../../order_details/presentation/manager/provider_order_details_cubit/provider_order_details_state.dart';

List<String?> keepOneInstance(List<String?> list) {
  final seenItems = <dynamic>{};

  final filteredList = list.where((item) {
    final hasSeen = seenItems.contains(item);
    seenItems.add(item);
    return !hasSeen;
  }).toList();

  return filteredList;
}

class CustomizeSpecalPreferences extends StatefulWidget {
  final List<Map<String, dynamic>>? items;
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
  List<String?> cat = [];
  List<String?> catImageUrl = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('cat : $cat');
      debugPrint('catImageUrl : $catImageUrl');
      cat.clear();
      catImageUrl.clear();
      // Provider.of<CustomizeSpecalPreferencesViewModel>(context, listen: false)
      //     .getPreference({'items': widget.items},
      //         Provider.of<UserViewModel>(context, listen: false).userToken());

      await BlocProvider.of<OrderDetailsCubit>(context, listen: false)
          .getPreferences(data: widget.items ?? []);

      List<PreferenceModel> data =
          // ignore: use_build_context_synchronously
          context.read<OrderDetailsCubit>().listData;
      for (var element in data) {
        for (var e in element.items) {
          cat.add(e.category);
          catImageUrl.add(e.catIcon);
        }
        break;
      }
      debugPrint('cat : $cat');
      debugPrint('catImageUrl : $catImageUrl');
      cat = keepOneInstance(cat);
      catImageUrl = keepOneInstance(catImageUrl);
    });

    super.initState();
  }

  // bool _enableAll = false;
  Widget _buildItem(
      {Item? item,
      // CustomizeSpecalPreferencesViewModel provider,
      required List<String?> catList,
      OrderDetailsCubit? cubit,
      String? title,
      PreferenceModel? preferenceModel,
      bool enableAll = false}) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (title == "Hanged" || title == "Folded" || title == "Add Carton") ||
                    ((title?.contains("تعليق") ?? false) ||
                        (title?.contains("تطبيق") ?? false) ||
                        (title?.contains("كرتون") ?? false))
                ? const SizedBox()
                : const SizedBox(
                    // width: 25,
                    ),
            Expanded(
              child: Row(
                children: [
                  Text(
                    title ?? item!.name ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: (title == "Hanged" ||
                                  title == "Folded" ||
                                  title == "Add Carton") ||
                              ((title?.contains("تعليق") ?? false) ||
                                  (title?.contains("تطبيق") ?? false) ||
                                  (title?.contains("كرتون") ?? false))
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                debugPrint(
                    'catSerItemId : ${item?.categoryItemServiceId ?? 0}');
                cubit.setItemIsEnabled(
                    all: enableAll,
                    itemId: item == null ? 0 : item.id ?? 0,
                    catSerItemId: item?.categoryItemServiceId ?? 0,
                    preferenceModel: preferenceModel!);
              },
              child: CustomSwitchButton2(
                backgroundColor: Colors.grey,
                unCheckedColor: Colors.white,
                animationDuration: const Duration(milliseconds: 400),
                checkedColor: Colors.white,
                checked: cubit!.checkIfEnable(
                    catItemSerId: item?.categoryItemServiceId ?? 0,
                    itemId: item == null ? 0 : item.id ?? 0,
                    preferenceModel: preferenceModel!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WithSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفضيلات ',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              // var cubit = OrderDetailsCubit.get(context);
              return ElevatedButton(
                onPressed: () {
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
                        dataApi[i]['length'] =
                            (double.parse(dataApi[i]['length']) +
                                    double.parse(dataApi[j]['length']))
                                .toString();
                        dataApi[i]['width'] =
                            (double.parse(dataApi[i]['width']) +
                                    double.parse(dataApi[j]['width']))
                                .toString();
                        dataApi[i]['quantity'] += dataApi[j]['quantity'];

                        if (dataApi[i]['item_details'] != null) {
                          List<Map<String, dynamic>> currentDetails =
                              List<Map<String, dynamic>>.from(
                                  jsonDecode(dataApi[i]['item_details']));
                          currentDetails.addAll(List<Map<String, dynamic>>.from(
                              jsonDecode(dataApi[j]['item_details'])));
                          dataApi[i]['item_details'] =
                              jsonEncode(currentDetails);
                        } else {
                          dataApi[i]['item_details'] = jsonEncode(details);
                        }

                        dataApi.removeAt(j);
                        j--;
                      }
                    }
                  }
                  // print('Pref List ${cubit.prefereceList}');
                  //  OrderDetailsCubit.get(context);
                  // List<Map<String, dynamic>> itemsList = [];
                  // // widget.selectedItems.forEach((element) {
                  // //   print(
                  // //       " listData: ${element.categoryItemServiceId} + ${element.selectedQuantity}");
                  // // });
                  // for (var ele in widget.selectedItems!) {
                  //   if(ele.withDimension == false){
                  //     itemsList.add({
                  //     "category_item_service_id": ele.categoryItemServiceId,
                  //     "quantity": ele.selectedQuantity,
                  //   });
                  //   }else{
                  //     itemsList.add({
                  //     "category_item_service_id": ele.categoryItemServiceId,
                  //     "quantity": 1,
                  //     "length":ele.lenght,
                  //     "width":ele.width
                  //   });
                  //   }

                  // }
                  // List<Map<String, dynamic>> prefList = [];
                  // for (var ele in cubit.prefereceList!) {
                  //   prefList.add({
                  //     "item_id": ele.,
                  //     "preference_id": ele.id,
                  //     "category_item_service_id":ele.
                  //   });
                  // }
                  print('items List $dataApi');
                  BlocProvider.of<OrderDetailsCubit>(context)
                      .postAssociateItems(
                          orderId: widget.orderId,
                          itemList: dataApi,
                          prefernces:
                              BlocProvider.of<OrderDetailsCubit>(context)
                                  .prefereceList);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10)),
                child: const Text(
                  'انتهاء',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }),
        body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
          listener: (context, state) {
            if (state is AssociateItemsPostSuccess) {
              if (state.successModel!.status!) {
                Navigator.pop(context);
                Navigator.pop(context);
                showToast(
                    message: 'تم الاضافةالقطع بنجاح',
                    state: ToastStates.SUCCESS);
              }
            }
            if (state is AssociateItemsPostFailed) {
              showToast(message: 'فشل الاضافة', state: ToastStates.ERROR);
            }
          },
          builder: (context, state) {
            final cubit = OrderDetailsCubit.get(context);
            //         cat.clear();
            // catImageUrl.clear();
            debugPrint('cat : $cat');
            debugPrint('catImageUrl : $catImageUrl');
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
                            children: cubit.listData
                                .map((element) => element.items.isEmpty
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildItem(
                                              catList: cat,
                                              title: element.name == "Carton" ||
                                                      element.name == 'كرتون'
                                                  ? "اضافه ${element.name}"
                                                  : element.name + ' الكل ',
                                              cubit: cubit,
                                              preferenceModel: element,
                                              enableAll: true),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          // const SizedBox(
                                          //   height: 24,
                                          // ),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemBuilder: (_, i) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .center,
                                                      children: [
                                                        Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            width: 48,
                                                            height: 48,
                                                            child: FDottedLine(
                                                              color:
                                                                  Colors.blue,
                                                              strokeWidth: 2.5,
                                                              dottedLength: 8.0,
                                                              space: 7.0,
                                                              corner: FDottedLineCorner
                                                                  .all(
                                                                      size.width *
                                                                          .15),
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  height: 25.3,
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      ImageAsIcon(
                                                                    height:
                                                                        25.3,
                                                                    width: 20.3,
                                                                    image: catImageUrl[
                                                                            i]
                                                                        .toString(),
                                                                    isActive:
                                                                        true,
                                                                    activeColor:
                                                                        Colors
                                                                            .transparent,
                                                                    defaultColor:
                                                                        Colors.grey[
                                                                            50],
                                                                    blendColor:
                                                                        BlendMode
                                                                            .saturation,
                                                                    fromNetwork:
                                                                        true,
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                          '${cat[i]}',
                                                          style:
                                                              const TextStyle(
                                                            //color: Color(BLACK_COLOR),
                                                            color: Colors.blue,
                                                            fontSize: 15,

                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ScrollPhysics(),
                                                        itemBuilder:
                                                            (_, index) {
                                                          if (element
                                                                  .items[index]
                                                                  .category ==
                                                              cat[i]) {
                                                            return Column(
                                                              children: [
                                                                _buildItem(
                                                                  catList: cat,
                                                                  item: element
                                                                          .items[
                                                                      index],
                                                                  cubit: cubit,
                                                                  preferenceModel:
                                                                      element,
                                                                  enableAll:
                                                                      false,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                )
                                                              ],
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        },
                                                        itemCount: element
                                                            .items.length),
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (_, index) {
                                                return const SizedBox(
                                                  height: 20,
                                                );
                                              },
                                              itemCount: cat.length),

                                          const SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ))
                                .toList(),
                          ),
                        )),
            );
          },
        ),
      ),
    );
  }
}
