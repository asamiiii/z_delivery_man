import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart';

class GenericText extends StatelessWidget {
  const GenericText(
    this.data, {
    super.key,
    this.size,
    this.weight,
    this.height,
    this.color,
    this.textAlign = TextAlign.center,
    this.overflow = TextOverflow.visible,
    this.softWrap,
    this.style,
    this.maxLines,
    this.decoration,
  });

  final String data;
  final double? size;
  final double? height;
  final FontWeight? weight;
  final Color? color;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextStyle? style;
  final int? maxLines;
  final TextDecoration? decoration;

  Widget get widget {
    return Text(
      data,
      style: style ??
          TextStyle(
            fontSize: size?.sp,
            fontWeight: weight,
            height: height,
            color: color,
            decoration: decoration,
          ),
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }

  Widget get returnWidget {
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return returnWidget;
  }
}
