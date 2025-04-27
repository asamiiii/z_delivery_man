import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/components/text_components/small_text.dart';
import 'package:z_delivery_man/screens/home/home_delivery/home_delivery.dart';
import 'package:z_delivery_man/screens/order_details/cubit.dart';
import 'package:z_delivery_man/screens/order_details/order_details_state.dart';
import 'package:z_delivery_man/screens/status_orders/status_orders_screen.dart';
import 'package:z_delivery_man/shared/widgets/custom_dropdown_menu.dart';

// ignore: must_be_immutable
class DmActionsSection extends StatelessWidget {
  DmActionsSection({Key? key, this.state, this.orderId}) : super(key: key);
  final OrderDetailsState? state;
  final int? orderId;

  var commentController = TextEditingController();
  var itemCountController = TextEditingController();
  bool checkCollectByHand = false;
  bool checkCollectByMachine = false;
  CardType? selectedMachinType;
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<OrderDetailsCubit>();

    return ConditionalBuilder(
      condition: state is! OrderDetailsNextStatusLoadingState &&
          state is! OrderDetailsLoadingState,
      fallback: (context) => const CupertinoActivityIndicator(),
      builder: (context) => Container(
        alignment: Alignment.bottomLeft,
        margin: const EdgeInsets.all(10),
        height: 9.h,
        child: cubit.orderDetailsModel?.nextStatus == null
            ? cubit.orderDetailsModel?.canCollect == true
                ? ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const SmallText('!تاكيد'),
                                content: StatefulBuilder(
                                  builder: (context, setStatee) {
                                    return Card(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CheckboxListTile(
                                              title: const SmallText(
                                                  'الدفع عند الاستلام'),
                                              value: checkCollectByHand,
                                              onChanged: (value) {
                                                setStatee(() {
                                                  checkCollectByMachine = false;
                                                  checkCollectByHand = value!;
                                                });
                                              }),
                                          CustomDropdown<CardType>(
                                            items: byMachinList,
                                            displayText: (item) {
                                              return item.name.toString();
                                            },
                                            onChanged: (selectedItem) {
                                              selectedMachinType = selectedItem;
                                              checkCollectByHand = false;
                                              checkCollectByMachine = true;
                                              setStatee(() {});
                                            },
                                            selectedItem: selectedMachinType,
                                            hintText: 'اختر ',
                                            mainTitle:
                                                'الدفع بالبطاقة الاتمانية',
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const SmallText('نعم'),
                                    onPressed: () {
                                      if (checkCollectByHand == true ||
                                          checkCollectByMachine == true) {
                                        cubit.collectOrder(
                                            byMachineOption:
                                                selectedMachinType?.key,
                                            orderId: orderId,
                                            collectMethod: checkCollectByHand
                                                ? "collected_by_hand"
                                                : "collected_by_machine");
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const SmallText('لا'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: const SmallText('تحصيل'))
                : Container()
            : ElevatedButton(
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            title: const SmallText('!تاكيد'),
                            content: Card(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (cubit.orderDetailsModel?.coreNextStatus ==
                                          'picked' ||
                                      cubit.orderDetailsModel?.coreNextStatus ==
                                          'from_provider')
                                    TextField(
                                      controller: itemCountController,
                                      decoration: const InputDecoration(
                                        hintText: 'item count',
                                      ),
                                    ),
                                  TextField(
                                    controller: commentController,
                                    decoration: const InputDecoration(
                                      hintText: 'comment',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const SmallText('نعم'),
                                onPressed: () async {
                                  await cubit.goToNextStatus(
                                      isDeliveryMan: true,
                                      orderId: orderId,
                                      itemCount: int.tryParse(
                                          itemCountController.text),
                                      comment: commentController.text);
                                  // ignore: use_build_context_synchronously
                                  await Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const HomeDelivery(),
                                  ));
                                },
                              ),
                              CupertinoDialogAction(
                                child: const SmallText('لا'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                },
                child: SmallText('${cubit.orderDetailsModel?.nextStatus}')),
      ),
    );
  }
}
