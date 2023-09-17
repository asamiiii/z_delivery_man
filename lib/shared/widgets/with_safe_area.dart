import 'package:flutter/material.dart';

class WithSafeArea extends StatelessWidget {
  final bool withSafeArea;
  final  Widget child;

  const WithSafeArea({Key? key, this.withSafeArea = false,required this.child})
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
