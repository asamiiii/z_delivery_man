import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/screens/order_details/cubit.dart';
import '../../screens/home/cubit.dart';
import '../../screens/login/cubit.dart';
import '../../screens/provider_app/orders_list/cubit/orderslist_cubit.dart';
import '../../screens/status_orders/cubit.dart';

class AppProviders{
  static List<BlocProvider> appProviders=[
         BlocProvider<OrderslistCubit>(
         create: (BuildContext context) => OrderslistCubit()),
         BlocProvider<OrderPerStatusCubit>(
         create: (BuildContext context) => OrderPerStatusCubit()),
         BlocProvider<LoginCubit>(
         create: (BuildContext context) => LoginCubit()),
         BlocProvider<HomeCubit>(
         create: (BuildContext context) => HomeCubit()),
              BlocProvider<OrderDetailsCubit>(
         create: (BuildContext context) => OrderDetailsCubit()),
        ];
}