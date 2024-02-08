import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

PreferredSizeWidget deliveryHomeAppBar(
    {required String? deliveryManName, required BuildContext? ctx}) {
  return AppBar(
    bottom: const TabBar(
      labelColor: Colors.white,
      // labelStyle: ,
      unselectedLabelColor: Colors.white60,

      tabs: [
        Tab(
          icon: Icon(Icons.delivery_dining),
          text: 'الكل',
        ),
        Tab(
          icon: Icon(Icons.today),
          text: 'اليوم',
        ),
      ],
    ),
    actions: const [
      SizedBox(
        width: 10,
      ),
      CircleAvatar(
        backgroundImage: AssetImage('assets/images/app_logo.png'),
      ),
      SizedBox(
        width: 10,
      ),
    ],
    title: Text(
      deliveryManName ?? '',
      style: GoogleFonts.cairo(
        color: Colors.white,
      ),
    ),
    leading: InkWell(
        onTap: () {
          showAreYouSureDialoge(
              context: ctx!,
              yesFun: () {
                signOut(ctx);
              },
              noFun: () {
                Navigator.of(ctx).pop();
              });
        },
        child: const Icon(Icons.logout)),
    centerTitle: true,
  );
}

class DeliveryHomeShimmer extends StatelessWidget {
  const DeliveryHomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Shimmer.fromColors(
          baseColor: Colors.white70,
          highlightColor: Colors.grey[200]!,
          direction: ShimmerDirection.ltr,
          child: const Card(
            color: Colors.grey,
            shape: RoundedRectangleBorder(),
          ),
        ),
      ),
    );
  }
}
