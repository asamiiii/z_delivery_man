import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';

import '../../network/local/cache_helper.dart';
import '../../screens/login/login_screen.dart';
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
UserType? userType = UserType.delivery_man;

// enum VisitTime { AM, PM }

String deliveryMan = "delivery_man";
