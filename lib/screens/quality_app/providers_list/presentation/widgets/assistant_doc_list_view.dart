import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/assistant_doc_clickable_widget.dart';

class AssistantDocListView extends StatelessWidget {
  const AssistantDocListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
            itemCount: 5,
            padding: EdgeInsets.all(8.sp),
            itemBuilder: (context, index) {
              return AssistantDocClickableWidget(
                onTap: () {},
                isSelected: index == 3,
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7)));
  }
}
