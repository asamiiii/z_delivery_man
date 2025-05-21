// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String text;
  final String? actionText;
  final VoidCallback? onActionTapped;
  const EmptyState({
    super.key,
    required this.text,
    this.actionText,
    this.onActionTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/no-doctors.png',
          width: 120,
        ),
        SizedBox(height: 16),
        Text(text),
                SizedBox(height: 16),

        if (actionText != null && onActionTapped != null)
          TextButton(
            onPressed: onActionTapped,
            child: Text(actionText!),
          )
      ],
    );
  }
}
