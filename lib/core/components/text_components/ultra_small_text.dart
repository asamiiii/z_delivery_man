// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'generic_text.dart';

class UltraSmallText extends GenericText {
  const UltraSmallText(
    super.data, {
    super.key,
    super.size = 12,
    super.weight = FontWeight.w500,
    super.height,
    super.color,
    super.textAlign,
    super.overflow,
    super.softWrap,
    super.maxLines,
  });
}
