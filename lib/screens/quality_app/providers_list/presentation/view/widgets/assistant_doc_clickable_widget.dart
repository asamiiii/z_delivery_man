import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/models/provider_model/provider_model.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/view/widgets/app_text_styles.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/view/widgets/custom_card.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/view/widgets/row_info_widget.dart';
import 'package:z_delivery_man/styles/color.dart';

class AssistantDocClickableWidget extends StatelessWidget {
  const AssistantDocClickableWidget({
    super.key,
    this.isSelected,
    required this.onTap,
    required this.providerModel
  });
  final bool? isSelected;
  final Function onTap;
  final ProviderModel? providerModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected! ? primaryColor : Colors.white,
            width: 2,
          ),
          // color: AppColors.lightBrown,
        ),
        child: CustomCard(
          // color: Colors.red,
          child: Column(
            children: [
              Text(
                      providerModel?.providerName??'',
                      maxLines: 2,
                      style: AppTextStyles.font16SemiBold
                          .copyWith(color: primaryColor),
                    ),
              // Row(
              //   children: [
              //     // Container(
              //     //   width: 40,
              //     //   height: 40,
              //     //   clipBehavior: Clip.hardEdge,
              //     //   decoration: BoxDecoration(
              //     //     borderRadius: BorderRadius.circular(8),
              //     //   ),
              //     // ),
              //     // const SizedBox(width: 8),
              //     Expanded(
              //       child: 
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),
              const Spacer(),
               RowInfo(
                title1: 'لم يتم استلامه',
                value1: providerModel?.orderCount?.providerAssigned.toString(),
                title2: ' تم استلامه',
                value2:  providerModel?.orderCount?.providerReceived.toString(),
              ),
               RowInfo(
                title1: 'تم الفحص القطع',
                value1: providerModel?.orderCount?.itemsChecked.toString(),
                title2: 'تم موافقة العميل',
                value2: providerModel?.orderCount?.clientConfirm.toString(),
              ),

               RowInfo(
                title1: 'في التشغيل',
                value1: providerModel?.orderCount?.inProcess.toString(),
                title2: 'تم الانتهاء',
                value2: providerModel?.orderCount?.finished.toString(),
              ),
               RowInfo(
                title1: 'تم تسليمه للمندوب',
                value1: providerModel?.orderCount?.fromProvider.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
