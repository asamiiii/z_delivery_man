import 'package:flutter/material.dart';

class InstructionsDelivery extends StatefulWidget {
  InstructionsDelivery({Key? key}) : super(key: key);

  @override
  _InstructionsDeliveryState createState() => _InstructionsDeliveryState();
}

class _InstructionsDeliveryState extends State<InstructionsDelivery> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('تعليمات للمندوب'));
  }
}