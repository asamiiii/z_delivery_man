// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'generic_text.dart';

class TitleText extends GenericText {
  const TitleText(
    super.data, {
    super.key,
    super.size = 20,
    super.weight = FontWeight.w500,
    super.height,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
  });
}
