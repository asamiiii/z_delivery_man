import '/../models/orders_per_status_model.dart';

abstract class OrderPerStatusStates {}

class OrderPerStatusInitialState extends OrderPerStatusStates {}

class OrderPerStatusLoadingState extends OrderPerStatusStates {
  final List<Orders>? oldOrders;
  final bool? isFirstFetch;

  OrderPerStatusLoadingState({this.oldOrders, this.isFirstFetch = false});
}

class OrderPerStatusLoadedState extends OrderPerStatusStates {
  final List<Orders>? orders;

  OrderPerStatusLoadedState({this.orders});
}

class OrderPerStatusSuccessState extends OrderPerStatusStates {}

class OrderPerStatusNextPageSuccessState extends OrderPerStatusStates {}

class OrderPerStatusFailedState extends OrderPerStatusStates {}

class OrderPerStatusCollectOrderStatusLoadingState
    extends OrderPerStatusStates {}

class OrderPerStatusCollectOrderStatusSuccessState
    extends OrderPerStatusStates {}

class OrderPerStatusCollectOrderStatusFailedState
    extends OrderPerStatusStates {}

class OrderPerStatusNextStatusLoadingState extends OrderPerStatusStates {}

class OrderPerStatusNextStatusSuccessState extends OrderPerStatusStates {}

class OrderPerStatusNextStatusFailedState extends OrderPerStatusStates {}

class SetterSuccess extends OrderPerStatusStates {}
