part of 'orderslist_cubit.dart';

@immutable
abstract class OrderslistState {}

class OrderslistInitial extends OrderslistState {}

class SetterState extends OrderslistState {}

class OrdersListLoading extends OrderslistState {}

class OrdersListFailed extends OrderslistState {}

class OrdersListSuccess extends OrderslistState {}

class PaginationLoading extends OrderslistState {}

class OrderNextStatusLoadingState extends OrderslistState {}

class OrderNextStatusFailedState extends OrderslistState {}

class OrderNextStatusSuccessState extends OrderslistState {
  final SuccessModel? successModel;

  OrderNextStatusSuccessState({this.successModel});
}
