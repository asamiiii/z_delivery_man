import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/assistant_doc_list_view.dart';

class AssistantSelectDocViewBody extends StatelessWidget {
  const AssistantSelectDocViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      // padding: const EdgeInsets.all(16),
      children: [
        AssistantDocListView()
      ],
    );
  }
}
