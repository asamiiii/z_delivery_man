import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/status_order_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/widgets/constants.dart';
import 'drawer_states.dart';

class DrawerCubit extends Cubit<DrawerStates> {
  DrawerCubit() : super(DrawerInitialState());

  static DrawerCubit get(context) => BlocProvider.of(context);

  StatusOrderModel? statusOrderModel;

  Future<void> getStatusOrder() {
    emit(DrawerGetStatusOrdersLoadingState());
    return DioHelper.getData(url: EndPoints.GET_STATUS_ORDER, token: token)
        .then((value) {
      debugPrint('getStatusOrder : ${value.data}');
      statusOrderModel = StatusOrderModel.fromJson(value.data);
      emit(DrawerGetStatusOrdersSuccessState());
    }).catchError((e) {
      print(e);
      emit(DrawerGetStatusOrdersFailedState());
    });
  }
}
