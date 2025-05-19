// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Clip clipBehavior;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      clipBehavior: clipBehavior,
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        color: color ?? Colors.white,
        boxShadow: [
          globalCardBoxShadow,
        ],
      ),
      child: child,
    );
  }
}

var globalCardBoxShadow = BoxShadow(
  color: Color(0xff101828).withOpacity(.04),
  blurRadius: 2,
  offset: Offset(0, 1),
);