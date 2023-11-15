import 'package:flutter/material.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:z_delivery_man/screens/order_details/cubit.dart';

class WithSafeArea extends StatelessWidget {
  final bool withSafeArea;
  final  Widget child;

  const WithSafeArea({Key? key, this.withSafeArea = false,required this.child, })
      : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return withSafeArea
        ? Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: child,
            ),
          )
        : Container(
            child: child,
          );
  }
}
