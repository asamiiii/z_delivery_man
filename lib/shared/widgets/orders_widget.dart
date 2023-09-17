import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../styles/color.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 1.5.h, left: 2.h),
          child: Card(
            elevation: 10,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40))),
            child: Container(
              height: 10.h,
              // margin: EdgeInsets.symmetric(horizontal: 2.h),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(120))),
              child: const Row(
                children: [],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 9,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: primaryColor,
            child: Text(
              '#680',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
