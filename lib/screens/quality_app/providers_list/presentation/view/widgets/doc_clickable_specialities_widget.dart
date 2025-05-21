import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/view/widgets/app_text_styles.dart';
import 'package:z_delivery_man/styles/color.dart';

class DocClickableSpecialitiesWidget extends StatelessWidget {
  const DocClickableSpecialitiesWidget({
    super.key,
    required this.txt,
    required this.onTap,
    required this.isSelected,
  });
  final String txt;
  final Function onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(txt,
            style: AppTextStyles.font10Bold.copyWith(
                color: isSelected == true ? primaryColor : Colors.grey)),
      ),
    );
  }
}
