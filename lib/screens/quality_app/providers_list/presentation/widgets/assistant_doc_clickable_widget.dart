import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/app_text_styles.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/custom_card.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/row_info_widget.dart';
import 'package:z_delivery_man/styles/color.dart';

class AssistantDocClickableWidget extends StatelessWidget {
  const AssistantDocClickableWidget({
    super.key,
    this.isSelected,
    required this.onTap,
    // required this.doctorModel
  });
  final bool? isSelected;
  final Function onTap;
  // final SecondDoctorModel? ;

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
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Z-station',
                      maxLines: 2,
                      style: AppTextStyles.font16SemiBold
                          .copyWith(color: primaryColor),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              const Spacer(),
              const RowInfo(
                title1: 'لم يتم استلامه',
                value1: '100',
                title2: ' تم استلامه',
                value2: '5',
              ),
              const RowInfo(
                title1: 'تم الفحص القطع',
                value1: '100',
                title2: 'تم موافقة العميل',
                value2: '5',
              ),

              const RowInfo(
                title1: 'في التشغيل',
                value1: '100',
                title2: 'تم الانتهاء',
                value2: '5',
              ),
              const RowInfo(
                title1: 'تم تسليمه للمندوب',
                value1: '100',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
