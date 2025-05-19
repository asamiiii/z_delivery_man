import '../../../../../models/success_model.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitialState extends OrderDetailsState {}

class OrderDetailsLoadingState extends OrderDetailsState {}

class OrderDetailsFailedState extends OrderDetailsState {}

class OrderDetailsSuccessState extends OrderDetailsState {}

class OrderDetailsNextStatusSuccessState extends OrderDetailsState {}

class OrderDetailsNextStatusLoadingState extends OrderDetailsState {}

class OrderDetailsNextStatusFailedState extends OrderDetailsState {}

class OrderDetailsCollectOrderStatusLoadingState extends OrderDetailsState {}

class OrderDetailsCollectOrderStatusFailedState extends OrderDetailsState {}

class OrderDetailsCollectOrderStatusSuccessState extends OrderDetailsState {}

class OrderDetailsChangeCheckBoxSuccessState extends OrderDetailsState {}

class OrderProviderDetailsLoadingState extends OrderDetailsState {}

class OrderProviderDetailsSuccessState extends OrderDetailsState {}

class OrderProviderDetailsFailedState extends OrderDetailsState {}

class PriceListLoading extends OrderDetailsState {}

class PriceListSuccess extends OrderDetailsState {}

class PriceListFailed extends OrderDetailsState {}

class SetterSuccess extends OrderDetailsState {}

class PreferencesLoading extends OrderDetailsState {}

class PreferencesSuccess extends OrderDetailsState {}

class PreferencesFailed extends OrderDetailsState {}

class RemovePrefereceList extends OrderDetailsState {}

class NotifyListeners extends OrderDetailsState {}

class AssociateItemsPostSuccess extends OrderDetailsState {
  late SuccessModel? successModel;

  AssociateItemsPostSuccess({required this.successModel});
}

class AssociateItemsPostLoading extends OrderDetailsState {}

class AssociateItemsPostFailed extends OrderDetailsState {}

class AssociateItemsUpdateSuccess extends OrderDetailsState {
  late SuccessModel? successModel;

  AssociateItemsUpdateSuccess({required this.successModel});
}

class AssociateItemsUpdateFailed extends OrderDetailsState {}

class AssociateItemsUpdateLoading extends OrderDetailsState {}

class AssociateItemsDeleteSuccess extends OrderDetailsState {
  late SuccessModel? successModel;

  AssociateItemsDeleteSuccess({required this.successModel});
}

class AssociateItemsDeleteLoading extends OrderDetailsState {}

class AssociateItemsDeleteFailed extends OrderDetailsState {}

class ImagePickedStateLoading extends OrderDetailsState {}

class ImagePickedStateSuccess extends OrderDetailsState {}

class ImagePickedStateFailed extends OrderDetailsState {}

class PostAssociateImagesLoading extends OrderDetailsState {}

class PostAssociateImagesSuccess extends OrderDetailsState {
  PostAssociateImagesSuccess();
}

class PostAssociateImagesFailed extends OrderDetailsState {}

class GetterSuccess extends OrderDetailsState {}
