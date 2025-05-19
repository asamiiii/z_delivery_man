import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/widgets/assistant_select_doc_view_body.dart';
import 'package:z_delivery_man/styles/color.dart';

class QualityManagerSelectView extends StatelessWidget {
  const QualityManagerSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'اختر المغسله',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: const AssistantSelectDocViewBody(),
    );
  }
}
