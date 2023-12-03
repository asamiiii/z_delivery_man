import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/order_per_status_provider.dart';
import '../../../../models/success_model.dart';
import '../../../../network/end_points.dart';
import '../../../../network/remote/dio_helper.dart';
import '../../../../shared/widgets/constants.dart';

part 'orderslist_state.dart';

class OrderslistCubit extends Cubit<OrderslistState> {
  OrderslistCubit() : super(OrderslistInitial());

  static OrderslistCubit get(context) => BlocProvider.of(context);

  List<Orders>? _orders = [];
  List<Orders>? get orders => _orders;

  int? _orderlastPage = 1;
  int? get orderlastPage => _orderlastPage;

  int? _orderCurrentPage = 1;
  int? get orderCurrentPage => _orderCurrentPage;

  void setCurrentPage() {
    _orderCurrentPage = _orderCurrentPage! + 1;
    emit(SetterState());
  }

  OrderPerStatusProvider? _orderPerStatusModel;
  void getOrderserStatus({String? status, int? pageIndex}) {
    if (pageIndex == 1 || pageIndex == null) {
      _orders = [];
      _orderCurrentPage = 1;
    }

    emit(OrdersListLoading());
    DioHelper.getData(
        url: Get_OrdersPreStatus,
        token: token,
        query: {"status": status, "page": pageIndex}).then((value) {
          debugPrint('orders list : ${value.data}');
      _orderPerStatusModel = OrderPerStatusProvider.fromJson(value.data);
      if (_orders!.isNotEmpty) {
        _orderlastPage = _orderPerStatusModel?.lastPage;
        _orders?.addAll(_orderPerStatusModel!.orders ?? []);
        emit(OrdersListSuccess());
      } else {
        _orderlastPage = _orderPerStatusModel?.lastPage;
        _orders = _orderPerStatusModel?.orders;
        emit(OrdersListSuccess());
      }
    }).catchError((e) {
      emit(OrdersListFailed());
    });
  }

  SuccessModel? successModel;
  void goToNextStatus(
      {required int? orderId,
      int? itemCount,
      String? comment,
      required bool isDeliveryMan}) {
    emit(OrderNextStatusLoadingState());
     DioHelper.postData(
        url: isDeliveryMan
            ? "$POST_ORDERS_NEXT_STATUS/$orderId/nextStatus"
            : "$POST_ORDERS_NEXT_STATUS_PROVIDER/$orderId/nextStatus",
        token: token,
        data: {"item_count": itemCount ?? 0, "comment": comment?? ''}).then((value) {
      debugPrint("Next status ${value.data}"  );

      try {
        successModel = SuccessModel.fromJson(value.data);
        emit(OrderNextStatusSuccessState(successModel: successModel));
      } catch (e) {
        debugPrint('error : $e');
        emit(OrderNextStatusFailedState());
      }
    }).catchError((e) {
      print("$e error of next status");
      emit(OrderNextStatusFailedState());
    });
  }
}
