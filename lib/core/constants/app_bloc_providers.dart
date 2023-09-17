import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/view_model/cubit.dart';
import '../../screens/home/cubit.dart';
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
        ];
}