import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';

import '../../../models/price_list_model.dart';
import '../../../shared/widgets/image_as_icon.dart';
import '../../../styles/color.dart';
import '../../order_details/presentation/manager/provider_order_details_cubit/provider_order_details_cubit.dart';
import '../../order_details/presentation/manager/provider_order_details_cubit/provider_order_details_state.dart';

class ClothesTypeList extends StatefulWidget {
  const ClothesTypeList({Key? key}) : super(key: key);

  @override
  _ClothesTypeListState createState() => _ClothesTypeListState();
}

class _ClothesTypeListState extends State<ClothesTypeList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = OrderDetailsCubit.get(context);
          int index = cubit.priceList
              .indexWhere((element) => element.id == cubit.selectedServicesId);
          List<Categories>? catList = cubit.priceList[index].categories;
          return SizedBox(
              height: 100,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          onTap: () {
                            cubit.setSelectedCatId(catList[index].id);
                            // final cubit = OrderDetailsCubit.get(context);
                            for (var element in cubit.initQuantityInPriceList) {
                              for (int i = 0; i < cubit.itemList!.length; i++) {
                                if (element.catItemServiceId ==
                                    cubit.itemList![i]?.categoryItemServiceId) {
                                  cubit.itemList![i]
                                          ?.selectedQuantityFromOrder =
                                      element.initQuantity;
                                  debugPrint('init : $i');
                                }
                              }
                            }
                            setState(() {});
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              width: 48,
                              height: 48,
                              child: FDottedLine(
                                color: cubit.selectedCatId == catList[index].id
                                    ? primaryColor
                                    : Colors.transparent,
                                strokeWidth: 2.5,
                                dottedLength: 8.0,
                                space: 7.0,
                                corner: FDottedLineCorner.all(size.width * .15),
                                child: Center(
                                  child: Container(
                                    height: 25.3,
                                    color:
                                        cubit.selectedCatId == catList[index].id
                                            ? Colors.transparent
                                            : Colors.transparent,
                                    child: ImageAsIcon(
                                      height: 25.3,
                                      width: 20.3,
                                      image: catList[index].icon,
                                      isActive: cubit.selectedCatId ==
                                          catList[index].id,
                                      activeColor: Colors.transparent,
                                      defaultColor: Colors.grey[50],
                                      blendColor: BlendMode.saturation,
                                      fromNetwork: true,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: SmallText(
                              '${catList[index].name}',
                              color: cubit.selectedCatId == catList[index].id
                                  ? Colors.black
                                  : const Color(0xffBDBDBD),
                              weight: FontWeight.w600,
                            ))
                      ],
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(
                      width: 25,
                    );
                  },
                  itemCount: catList!.length));
        });
  }
}
