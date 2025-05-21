import 'package:z_delivery_man/models/time_slots_model.dart';

abstract class HomeStates {}

class HomeInitalState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeFailedState extends HomeStates {}

class NotifyListeners extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final TimeSlotsModel? timeSlotsModel;
  HomeSuccessState({this.timeSlotsModel});
}

class HomeLoadingStatus extends HomeStates {}

class HomeuccessStatus extends HomeStates {}

class HomeFailedStatus extends HomeStates {}

class LogoutLoading extends HomeStates {}

class LogoutSuccess extends HomeStates {}

class LogoutFailed extends HomeStates {}
