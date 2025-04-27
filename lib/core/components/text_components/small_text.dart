// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'generic_text.dart';

class SmallText extends GenericText {
  const SmallText(
    super.data, {
    super.key,
    super.size = 14,
    super.weight = FontWeight.w400,
    super.height,
    super.color,
    super.textAlign,
    super.overflow,
    super.style,
    super.softWrap,
    super.maxLines,
  });
}
