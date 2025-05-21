import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/core/global_cubit/global_cubit.dart';
import 'package:z_delivery_man/screens/drawer/cubit.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/cubit.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_cubit.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/provider_order_details_cubit/provider_order_details_cubit.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/cubit.dart';
import '../../screens/login/cubit.dart';
import '../../screens/provider_app/orders_list/cubit/orderslist_cubit.dart';
import '../../screens/status_orders/cubit.dart';

class AppProviders {
  static List<BlocProvider> appProviders = [
    BlocProvider<GlobalCubit>(create: (BuildContext context) => GlobalCubit()),
    BlocProvider<OrderslistCubit>(
        create: (BuildContext context) => OrderslistCubit()),
    BlocProvider<OrderPerStatusCubit>(
        create: (BuildContext context) => OrderPerStatusCubit()),
    BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
    BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
    BlocProvider<DrawerCubit>(create: (BuildContext context) => DrawerCubit()),
    BlocProvider<OrderDetailsCubit>(
        create: (BuildContext context) => OrderDetailsCubit()),
    BlocProvider<DMOrderDetailsCubit>(
        create: (BuildContext context) => DMOrderDetailsCubit()),
    BlocProvider<OrderItemImagesCubit>(
        create: (BuildContext context) => OrderItemImagesCubit()),
  ];
}
