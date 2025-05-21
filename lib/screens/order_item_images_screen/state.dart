abstract class OrderItemImagesState {}

class OrderItemImagesInitialState extends OrderItemImagesState {}

class OrderItemImagesLoadingState extends OrderItemImagesState {}

class OrderItemCommentLoadingState extends OrderItemImagesState {}

class OrderItemImagesUpLoadingState extends OrderItemImagesState {}

class OrderItemImagesStopLoadingState extends OrderItemImagesState {}

class OrderItemImagesSuccessState extends OrderItemImagesState {}

class OrderItemRemoveImagesSuccessState extends OrderItemImagesState {}

class OrderItemRemoveImagesLoadingState extends OrderItemImagesState {}

class OrderItemRemoveImagesFailedState extends OrderItemImagesState {}

class OrderItemCommentSuccessState extends OrderItemImagesState {}

class OrderItemImagesFailedState extends OrderItemImagesState {}

class OrderItemCommentFailedState extends OrderItemImagesState {}

class PaintLoading extends OrderItemImagesState {}

class PaintSuccess extends OrderItemImagesState {}

class PaintFailed extends OrderItemImagesState {}
