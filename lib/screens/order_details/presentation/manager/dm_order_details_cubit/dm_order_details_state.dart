import '../../../../../models/success_model.dart';

abstract class DMOrderDetailsState {}

class DMOrderDetailsInitialState extends DMOrderDetailsState {}

class DMOrderDetailsLoadingState extends DMOrderDetailsState {}

class DMOrderDetailsFailedState extends DMOrderDetailsState {}

class DMOrderDetailsSuccessState extends DMOrderDetailsState {}

class DMOrderDetailsNextStatusSuccessState extends DMOrderDetailsState {}

class DMOrderDetailsNextStatusLoadingState extends DMOrderDetailsState {}

class DMOrderDetailsNextStatusFailedState extends DMOrderDetailsState {}

class DMOrderDetailsCollectOrderStatusLoadingState extends DMOrderDetailsState {}

class DMOrderDetailsCollectOrderStatusFailedState extends DMOrderDetailsState {}

class DMOrderDetailsCollectOrderStatusSuccessState extends DMOrderDetailsState {}

class DMOrderDetailsChangeCheckBoxSuccessState extends DMOrderDetailsState {}
