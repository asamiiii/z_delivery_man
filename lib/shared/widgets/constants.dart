import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../network/local/cache_helper.dart';
import '../../features/auth/presentation/view/login_screen.dart';
import 'components.dart';

void signOut(BuildContext context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndReplace(context, const LoginScreen());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String? token = '';
bool? isDeliveryMan = false;

// enum VisitTime { AM, PM }

String deliveryMan = "delivery_man";
