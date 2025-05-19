import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_cubit.dart';
import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_state.dart';
import 'package:z_delivery_man/screens/order_details/presentation/view/widgets/delivery/customer_details_widget.dart';
import 'package:z_delivery_man/screens/order_details/presentation/view/widgets/delivery/dm_actions_section.dart';
import 'package:z_delivery_man/screens/order_details/presentation/view/widgets/delivery/order_details_widget.dart';
import 'package:z_delivery_man/screens/order_details/presentation/view/widgets/delivery/pick_deliver_time_widget.dart';

//? Delivey man order details section view

class DeliverySection extends StatelessWidget {
  const DeliverySection({Key? key, this.cubit, this.state, this.orderId})
      : super(key: key);
  final DMOrderDetailsCubit? cubit;
  final DMOrderDetailsState? state;
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PickDeliverTimeWidget(),
        const CustomerDetailsWidget(),
        const OrderDetailsWidget(),
        DmActionsSection(
          state: state,
          orderId: orderId,
        )
      ],
    );
  }
}
