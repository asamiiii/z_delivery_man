import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/screens/status_orders/status_orders_states.dart';

import '../../models/orders_per_status_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/widgets/constants.dart';

class OrderPerStatusCubit extends Cubit<OrderPerStatusStates> {
  OrderPerStatusCubit() : super(OrderPerStatusInitialState());

  static OrderPerStatusCubit get(context) => BlocProvider.of(context);

  var allOrders = <Orders>[];
  OrdersPerStatusModel? ordersPerStatusModel;

  int _currentPage = 1;
  int? get currentPage => _currentPage;
  int? _lastPage = 1;
  int? get lastPage => _lastPage;

  void setCurrentPage({bool isInit = false}) {
    if (isInit == true) {
      _currentPage = 1;
    } else {
      _currentPage++;
    }
    emit(SetterSuccess());
  }

  void getOrderPerStatus({String? status, int? isAll, int? page}) {
    // if (state is OrderPerStatusLoadingState) return;

    // final currentState = state;

    // var oldOrderes = <Orders>[];
    // if (currentState is OrderPerStatusLoadedState) {
    //   oldOrderes = currentState.orders;
    // }

    emit(OrderPerStatusLoadingState());

    DioHelper.getData(
        url: EndPoints.GET_ORDERS_PER_STATUS,
        token: token,
        query: {"status": status, "page": page, "all": isAll}).then((value) {
      debugPrint('getOrderPerStatus Resp : ${value.data}');
      if (page == 1 || page == null) {
        allOrders = [];
        ordersPerStatusModel = OrdersPerStatusModel.fromJson(value.data);
        _lastPage = ordersPerStatusModel?.lastPage;
        allOrders = ordersPerStatusModel!.orders!;
        emit(OrderPerStatusSuccessState());
      }
      if (allOrders.isNotEmpty && page! > 1) {
        ordersPerStatusModel = OrdersPerStatusModel.fromJson(value.data);
        _lastPage = ordersPerStatusModel?.lastPage;
        allOrders.addAll(ordersPerStatusModel!.orders!);
        emit(OrderPerStatusNextPageSuccessState());
      }
      emit(OrderPerStatusSuccessState());
      // if (page <= ordersPerStatusModel.lastPage) {
      //   page++;

      print('page num $page');

      // final orders = (state as OrderPerStatusLoadingState).oldOrders;
      // orders.addAll(ordersPerStatusModel.orders);
      // emit(OrderPerStatusLoadedState(orders: orders));
      // } else {
      //   return;
      // }
    }).catchError((e) {
      print(e);
      emit(OrderPerStatusFailedState());
    });
  }

  void collectOrder(
      {required int? orderId,
      required String? collectMethod,
      required String? byMachineOption}) {
    emit(OrderPerStatusCollectOrderStatusLoadingState());
    DioHelper.postData(
        url: '${EndPoints.POST_COLLECT_ORDER}/$orderId/collect',
        token: token,
        data: {
          'collect_method': collectMethod,
          'collect_type': byMachineOption
        }).then((value) {
      emit(OrderPerStatusCollectOrderStatusSuccessState());
    }).catchError((e) {
      print('$e collect error');
      emit(OrderPerStatusCollectOrderStatusFailedState());
    });
  }

  Future<void> goToNextStatus(
      {required int? orderId,
      int? itemCount,
      String? comment,
      required bool isDeliveryMan}) async {
    emit(OrderPerStatusNextStatusLoadingState());
    await DioHelper.postData(
        url: isDeliveryMan
            ? "${EndPoints.POST_ORDERS_NEXT_STATUS}/$orderId/nextStatus"
            : "${EndPoints.POST_ORDERS_NEXT_STATUS_PROVIDER}/$orderId/nextStatus",
        token: token,
        data: {"item_count": itemCount, "comment": comment}).then((value) {
      debugPrint('Response :  ${value.data} ');
      if (value.data.toString().contains('errors')) {
        emit(OrderPerStatusNextStatusFailedState());
      } else {
        emit(OrderPerStatusNextStatusSuccessState());
      }
    }).catchError((e) {
      print("$e error of next status");
      emit(OrderPerStatusNextStatusFailedState());
    });
  }
}
