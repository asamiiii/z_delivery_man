import 'generic_text.dart';
import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  final GenericText text;
  const RowText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [text],
    );
  }
}
