import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/index_model.dart';
import '../../models/time_slots_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/widgets/constants.dart';
import 'home_sates.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitalState());

  static HomeCubit get(context) => BlocProvider.of(context);

  // List pickupSlots = [];

  List<TimeSlotsModel>? timeSlots = [];
  List pickupLists = [];
  List deliveryLists = [];

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
  Future<void> getStatusWithCount() {
    emit(HomeLoadingStatus());
    return DioHelper.getData(url: Get_STATUS_PROVIDER, token: token)
        .then((value) {
      indexModel = IndexModel.fromJson(value.data);
      print(value);
      print(indexModel);
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
        break;

      case 'waiting_deliveryMan':
        return 'في انتظار تسليم الاوردر للمندوب';
        break;

      case 'finished':
        return 'تم الانتهاء من الطلب عند المغسلة';
        break;

      case 'check_up':
        return 'مطلوب فحص الاوردر';
        break;

      case 'deliver_today':
        return 'اوردرات يجب تسليمها اليوم';
        break;

      case 'in_progress':
        return 'عرض الاوردرات الجارية';
        break;

      case 'ended':
        return 'عرض الاوردرات المنتهية';
        break;

      default:
        return '';
    }
  }
}
