import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/app_text_styles.dart';

class RowInfo extends StatelessWidget {
  const RowInfo(
      {super.key, this.title1, this.title2, this.value1, this.value2});

  final String? title1;
  final String? title2;
  final String? value1;
  final String? value2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title1 ?? '',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyles.font10Regular.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                value1 ?? '',
                style: AppTextStyles.font14Bold.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            children: [
              Text(
                title2 ?? '',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyles.font10Regular.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                value2 ?? '',
                style: AppTextStyles.font14Bold.copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
