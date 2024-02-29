import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/models/index_model.dart';
import 'package:z_delivery_man/models/time_slots_model.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/network/remote/dio_helper.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

import 'home_sates.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitalState());

  static HomeCubit get(context) => BlocProvider.of(context);

  // List pickupSlots = [];

  List<TimeSlotsModel>? timeSlots = [];
  List pickupLists = [];
  List deliveryLists = [];

  bool isToday = true;

  isTodayToggle(bool value){
     isToday = value;
     emit(HomeuccessStatus());
  }

  TimeSlotsModel? timeSlotsModel;

  Future<void> logout() {
    emit(LogoutLoading());
    return DioHelper.postData(url: LOGOUT, token: token).then((value) {
      emit(LogoutSuccess());
    }).catchError((e) {
      emit(LogoutFailed());
    });
  }

  Future<void> getTimeSlots() {
    emit(HomeLoadingState());
    return DioHelper.getData(url: GET_ORDERS, token: token).then((value) {
      timeSlots?.clear();
      pickupLists.clear();
      deliveryLists.clear();
      timeSlots = timeSlotsFromJson(value.data);
      print(timeSlots);

      // print(timeSlotsModel.toString() + 'time slot model');
      // timeSlots.where((element) => false)
      for (var element in timeSlots!) {
        if (element.type == 1) {
          pickupLists.add(element);
        } else if (element.type == 2) {
          deliveryLists.add(element);
        }
      }
      emit(HomeSuccessState(timeSlotsModel: timeSlotsModel));
    }).catchError((e) {
      print(e);
      emit(HomeFailedState());
    });
  }

  IndexModel? indexModel;
  Future<void> getStatusWithCount() async{
    emit(HomeLoadingStatus());
    await DioHelper.getData(url: Get_STATUS_PROVIDER, token: token)
        .then((value) {
      // debugPrint('resp $value');
      indexModel = IndexModel.fromJson(value.data);
      debugPrint('resp $value');
      print('index model :$indexModel');
      emit(HomeuccessStatus());
    }).catchError((e) {
      print(e);
      emit(HomeFailedStatus());
    });
  }

  String? handleStatusName(String? statusName) {
    switch (statusName) {
      case 'new':
        return 'عرض الاوردرات الجديدة';

      case 'waiting_deliveryMan':
        return 'في انتظار تسليم الاوردر للمندوب';

      case 'finished'||'finished_all':
        return 'تم الانتهاء من الطلب عند المغسلة';

      case 'check_up'||'check_up_all':
        return 'مطلوب فحص الاوردر';

      case 'deliver_today':
        return 'اوردرات يجب تسليمها اليوم';

      case 'in_progress':
        return 'عرض الاوردرات الجارية';

      case 'ended':
        return 'عرض الاوردرات المنتهية';

      case 'opened'||'opened_all':
        return 'العدد الاجمالي';

        case 'provider_assigned'||'provider_assigned_all':
        return 'لم يتم استلامه';

        case 'provider_received'||'provider_received_all':
        return 'تم استلامه';


        case 'remaining'||'remaining_all':
        return 'المتبقي';

        case 'from_provider'||'from_provider_all':
        return 'تم التسليم للمندوب';
      default:
        return '';
    }
  }
}
