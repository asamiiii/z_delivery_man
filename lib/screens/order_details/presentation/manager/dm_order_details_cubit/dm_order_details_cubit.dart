import 'package:z_delivery_man/screens/order_details/presentation/manager/dm_order_details_cubit/dm_order_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/order_details_model.dart';
import '../../../../../network/end_points.dart';
import '../../../../../network/remote/dio_helper.dart';
import '../../../../../shared/widgets/constants.dart';

class DMOrderDetailsCubit extends Cubit<DMOrderDetailsState> {
  DMOrderDetailsCubit() : super(DMOrderDetailsInitialState());

  static DMOrderDetailsCubit get(context) => BlocProvider.of(context);

  OrderDetailsModel? orderDetailsModel;

  Future<void> getOrderDetails({required int? orderId}) {
    emit(DMOrderDetailsLoadingState());

    debugPrint("order ID $orderId");
    return DioHelper.getData(
            url: "${EndPoints.GET_ORDER_DETAILS}/$orderId", token: token)
        .then((value) {
      debugPrint("Details ${value.data}");
      orderDetailsModel = OrderDetailsModel.fromJson(value.data);
      debugPrint("$orderDetailsModel  order datails model");
      emit(DMOrderDetailsSuccessState());
    }).catchError((e) {
      debugPrint('details filed $e');
      emit(DMOrderDetailsFailedState());
    });
  }

  Future<void> goToNextStatus({
    required int? orderId,
    int? itemCount,
    String? comment,
  }) async {
    emit(DMOrderDetailsNextStatusLoadingState());
    await DioHelper.postData(
        url: "${EndPoints.POST_ORDERS_NEXT_STATUS}/$orderId/nextStatus",
        token: token,
        data: {"item_count": itemCount, "comment": comment}).then((value) {
      debugPrint('Go to next : ${value.data}');
      emit(DMOrderDetailsNextStatusSuccessState());
    }).catchError((e) {
      debugPrint("$e error of next status");
      emit(DMOrderDetailsNextStatusFailedState());
    });
  }

  void collectOrder(
      {required int? orderId,
      required String? collectMethod,
      required String? byMachineOption}) {
    emit(DMOrderDetailsCollectOrderStatusLoadingState());
    DioHelper.postData(
        url: '${EndPoints.POST_COLLECT_ORDER}/$orderId/collect',
        token: token,
        data: {
          'collect_method': collectMethod,
          'collect_type': byMachineOption
        }).then((value) {
      emit(DMOrderDetailsCollectOrderStatusSuccessState());
    }).catchError((e) {
      debugPrint('$e collect error');
      emit(DMOrderDetailsCollectOrderStatusFailedState());
    });
  }
}
