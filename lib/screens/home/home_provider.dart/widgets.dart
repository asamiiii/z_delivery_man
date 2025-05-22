import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/network/remote/dio_helper.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/cubit.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

PreferredSizeWidget? providerAppBar(
    {required String? providerName,
    required BuildContext? ctx,
    required HomeCubit? cubit}) {
  // final homeCubit = HomeCubit.get(ctx);
  return AppBar(
      title: Text(
        providerName ?? '',
        style: GoogleFonts.cairo(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      // leading: ,
      actions: [
        const SizedBox(
          width: 15,
        ),
        StatefulBuilder(
          builder: (context, setState) => DropdownButton<String>(
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            autofocus: true,
            hint: Text(cubit?.isToday == true ? 'اليوم' : 'الكل',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                )),
            items: <String>['اليوم', 'الكل', 'الخروج'].map((String value) {
              return DropdownMenuItem<String>(
                // enabled: false,
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.cairo(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == 'اليوم') {
                cubit?.isTodayToggle(true);
              } else if (value == 'الكل') {
                cubit?.isTodayToggle(false);
              } else {
                showAreYouSureDialoge(
                    context: ctx!,
                    yesFun: () {
                      signOut(ctx);
                    },
                    noFun: () {
                      Navigator.of(ctx).pop();
                    });
              }
              setState;
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
         CircleAvatar(
          radius: 5,
          backgroundColor: EndPoints.baseUrl == "http://zdev.z-laundry.com/public/api/v1/"
              ? Colors.red
              : Colors.green,
        ),
        const SizedBox(
          width: 15,
        ),
      ]);
}
