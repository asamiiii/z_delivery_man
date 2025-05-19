import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/home/home_delivery/home_delivery.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_screen.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/providers_list_view.dart';

Widget userHome(String userType) {
  if (userType == UserType.delivery_man.name) {
    return const HomeDelivery();
  } else if (userType == UserType.provider.name) {
    return const HomeScreen();
  } else if (userType == UserType.quality_manager.name) {
    return const QualityManagerSelectView();
  }
  return const SizedBox();
}
