import 'dart:io';

import '../../models/price_list_model.dart' as pricelist;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/order_details_model.dart';
import '../../models/perferences_model.dart';
import '../../models/provider_order_details.dart';
import '../../models/success_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/widgets/constants.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(OrderDetailsInitialState());

  static OrderDetailsCubit get(context) => BlocProvider.of(context);

  OrderDetailsModel? orderDetailsModel;

  Future<void> getOrderDetails({required int? orderId}) {
    emit(OrderDetailsLoadingState());

    return DioHelper.getData(url: "$GET_ORDER_DETAILS/$orderId", token: token)
        .then((value) {
      print(value.data);
      orderDetailsModel = OrderDetailsModel.fromJson(value.data);
      print("$orderDetailsModel  order datails model");

      emit(OrderDetailsSuccessState());
    }).catchError((e) {
      print('details filed $e');
      emit(OrderDetailsFailedState());
    });
  }

  ProviderOrderDetails? providerOrderDetails;
  Future<void> getProviderOrderDetails({required int? orderId}) {
    emit(OrderProviderDetailsLoadingState());

    return DioHelper.getData(
            url: "$GET_PROVIDER_ORDER_DETAILS/$orderId", token: token)
        .then((value) {
      providerOrderDetails = ProviderOrderDetails.fromJson(value.data);
      checkedItemsNumber();
      emit(OrderProviderDetailsSuccessState());
      if (providerOrderDetails?.images != null) {
        for (var item in providerOrderDetails!.images!) {
          networkImages.add(item);
        }
        emit(OrderProviderDetailsSuccessState());
      }
    }).catchError((e) {
      print('details filed $e');
      emit(OrderProviderDetailsFailedState());
    });
  }

  void goToNextStatus(
      {required int? orderId,
      int? itemCount,
      String? comment,
      required bool isDeliveryMan}) {
    emit(OrderDetailsNextStatusLoadingState());
    DioHelper.postData(
        url: isDeliveryMan
            ? "$POST_ORDERS_NEXT_STATUS/$orderId/nextStatus"
            : "$POST_ORDERS_NEXT_STATUS_PROVIDER/$orderId/nextStatus",
        token: token,
        data: {"item_count": itemCount, "comment": comment}).then((value) {
      print(value.data);
      emit(OrderDetailsNextStatusSuccessState());
    }).catchError((e) {
      print("$e error of next status");
      emit(OrderDetailsNextStatusFailedState());
    });
  }

  void collectOrder({
    required int? orderId,
    required String? collectMethod,
  }) {
    emit(OrderDetailsCollectOrderStatusLoadingState());
    DioHelper.postData(
        url: '$POST_COLLECT_ORDER/$orderId/collect',
        token: token,
        data: {'collect_method': collectMethod}).then((value) {
      emit(OrderDetailsCollectOrderStatusSuccessState());
    }).catchError((e) {
      print('$e collect error');
      emit(OrderDetailsCollectOrderStatusFailedState());
    });
  }

  List<pricelist.PriceList> priceList = [];
  void getPriceList({
    required int? orderId,
  }) {
    emit(PriceListLoading());
    DioHelper.getData(
            url: "$Get_STATUS_PROVIDER/$orderId/priceList", token: token)
        .then((value) {
      priceList = pricelist.priceListFromJson(value.data);
      setInitServicesAndCat(priceList.first.id);
      getItemList();
      emit(PriceListSuccess());
    }).catchError((e) {
      print(e);
      emit(PriceListFailed());
    });
  }

  int? _selectedServicesId = 1;
  int? get selectedServicesId => _selectedServicesId;
  void setSelectedServicesId(int? value) {
    _selectedServicesId = value;
    setInitServicesAndCat(value);
    getItemList();
    emit(SetterSuccess());
  }

  setInitServicesAndCat(int? serId) {
    _selectedServicesId = serId;
    int? index = priceList.indexWhere((element) => element.id == serId);
    _selectedCatId = priceList[index].categories?.first.id;
    emit(SetterSuccess());
  }

  int? _selectedCatId = 1;
  int? get selectedCatId => _selectedCatId;
  void setSelectedCatId(int? value) {
    _selectedCatId = value;
    getItemList();
    emit(SetterSuccess());
  }

  PreferencesModel? preferencesModel;
  void getPreferences({
    required List<int>? itemsId,
  }) {
    emit(PreferencesLoading());
    DioHelper.postData(
        url: Get_PREFERENCSE,
        token: token,
        data: {"items": itemsId}).then((value) {
      preferencesModel = PreferencesModel.fromJson(value.data);
      for (var ele in preferencesModel!.data!) {
        _listData.add(ele);
      }
      emit(PreferencesSuccess());
    }).catchError((e) {
      print(e);
      emit(PreferencesFailed());
    });
  }

  final List<Data> _listData = [];
  List<Data> get listData => _listData;

  List<Map<String, int>> _prefereceList = [];
  List<Map<String, int>> get prefereceList => _prefereceList;

  removePrefereceList() {
    _prefereceList = [];
    emit(RemovePrefereceList());
  }

  void setItemIsEnabled({
    required Data? preferenceModel,
    required int? itemId,
    bool all = false,
  }) {
    int indexLocal = _prefereceList.indexWhere((item) =>
        item['item_id'] == itemId &&
        item['preference_id'] == preferenceModel?.id);

    if (all) {
      int prefLength = _prefereceList
          .where((element) => element['preference_id'] == preferenceModel?.id)
          .toList()
          .length;
      int _index =
          _listData.indexWhere((element) => element.id == preferenceModel?.id);
      int listLength = _listData[_index].items!.length;
      if (prefLength != listLength) {
        _prefereceList.removeWhere(
            (element) => element['preference_id'] == preferenceModel?.id);
        for (var element in preferenceModel!.items!) {
          _prefereceList.add(
              {'preference_id': preferenceModel.id!, 'item_id': element.id!});
          emit(NotifyListeners());
        }
      } else {
        _prefereceList.removeWhere(
            (element) => element['preference_id'] == preferenceModel?.id);
        emit(NotifyListeners());
      }
    } else {
      if (indexLocal == -1) {
        _prefereceList
            .add({'preference_id': preferenceModel!.id!, 'item_id': itemId!});
        emit(NotifyListeners());

        for (var map in _prefereceList) {
          if (map.containsKey('preference_id')) {
            if (map['preference_id'] != preferenceModel.id &&
                map['item_id'] == itemId) {
              _prefereceList.remove(map);
              emit(NotifyListeners());
            }

            // _prefereceList.removeWhere((element) => element["item_id"] == itemId &&element['preference_id'] ==preferenceModel.id);
            //          notifyListeners();
          }
        }
        // _prefereceList
        //     .add({'preference_id': preferenceModel.id, 'item_id': itemId});
        // notifyListeners();
      } else {
        _prefereceList.removeAt(indexLocal);
        emit(NotifyListeners());
      }
      emit(NotifyListeners());
    }
  }

  bool checkIfEnable({
    required Data? preferenceModel,
    required int? itemId,
  }) {
    int indexLocal = _prefereceList.indexWhere((item) =>
        item['item_id'] == itemId &&
        item['preference_id'] == preferenceModel?.id);

    if (itemId == 0) {
      int prefLength = _prefereceList
          .where((element) => element['preference_id'] == preferenceModel?.id)
          .toList()
          .length;
      int _index =
          _listData.indexWhere((element) => element.id == preferenceModel?.id);
      int listLength = _listData[_index].items!.length;
      return prefLength == listLength;
    } else {
      if (indexLocal == -1) {
        return false;
      } else {
        return true;
      }
    }
  }

  List<pricelist.Items> selectedItems = [];

  SuccessModel? successModel;
  void postAssociateItems(
      {required int? orderId,
      required List<Map<String, dynamic>>? itemList,
      required List<Map<String, dynamic>>? prefernces}) {
    emit(AssociateItemsPostLoading());
    print(itemList);
    print(prefernces);
    DioHelper.postData(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/associateItems",
            data: {"item_list": itemList, "preferences": prefernces},
            token: token)
        .then((value) {
      print(value.data);
      successModel = SuccessModel.fromJson(value.data);
      emit(AssociateItemsPostSuccess(successModel: successModel));
    }).catchError((e) {
      print(e);
      emit(AssociateItemsPostFailed());
    });
  }

  Future<void> updateAssociateItems(
      {required int? orderId, required int? itemId, required int? quantity}) {
    emit(AssociateItemsUpdateLoading());
    return DioHelper.updateData(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/items/$itemId",
            data: {'quantity': quantity},
            token: token)
        .then((value) {
      successModel = SuccessModel.fromJson(value.data);
      emit(AssociateItemsUpdateSuccess(successModel: successModel));
    }).catchError((e) {
      print(e);
      emit(AssociateItemsUpdateFailed());
    });
  }

  Future<void> deleteAssociateItems(
      {required int? orderId, required int? itemId}) {
    emit(AssociateItemsDeleteLoading());
    return DioHelper.deleteData(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/items/$itemId", token: token)
        .then((value) {
      successModel = SuccessModel.fromJson(value.data);
      emit(AssociateItemsDeleteSuccess(successModel: successModel));
    }).catchError((e) {
      print(e);
      emit(AssociateItemsDeleteFailed());
    });
  }

  // pick image
  final ImagePicker picker = ImagePicker();
  List<Images> networkImages = [];
  List<File> pickedImages = [];
  Future<File?> pickImage({required ImageSource source}) async {
    emit(ImagePickedStateLoading());

    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      File? file = File(image.path);
      emit(ImagePickedStateSuccess());
      return file;
    } else {
      print("No Image Selected");
      emit(ImagePickedStateFailed());

      return null;
    }
  }

  Future<void> postAssociateImage({required int? orderId}) async {
    emit(PostAssociateImagesLoading());
    // var formData = FormData.fromMap({
    //   'images[]': [
    //     for (var item in pickedImages)
    //       {
    //         await MultipartFile.fromFile(
    //           item.path,
    //           filename: item.path.split('/').last,
    //           contentType: MediaType("image", item.path.split(".").last),
    //         )
    //       }.toList()
    //   ]
    // });
    // var formData = FormData.fromMap({"images[]": pickedImages});

    var formData = FormData();
    for (var file in pickedImages) {
      formData.files.addAll([
        MapEntry("images[]", await MultipartFile.fromFile(file.path)),
      ]);
    }
    // formData.files.addAll(
    //   [
    //     for(var image in pickedImages){
    //       MapEntry("images[]", await MultipartFile.fromFile(image.path))
    //     }
    //   ]
    // );
    print(formData.files[0].key);
    print(formData.files[0].value.filename);

    DioHelper.postDataMultipart(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/associateImages",
            token: token,
            data: formData)
        .then((value) {
      print(value.data);
      // successModel = SuccessModel.fromJson(value.data);
      // if (value.data.toString() == "{'status':true}") {
      emit(PostAssociateImagesSuccess());
      // } else {
      //   emit(PostAssociateImagesFailed());
      // }
    }).catchError((e) {
      print(e.toString());
      emit(PostAssociateImagesFailed());
    });
  }

  Future<void> deleteAssociateImage(
      {required int? orderId, required int? imageId}) {
    emit(AssociateItemsDeleteLoading());
    return DioHelper.deleteData(
            url: "$DELETE_ASSOCIATE_IMAGE/$orderId/images/$imageId",
            token: token)
        .then((value) {
      successModel = SuccessModel.fromJson(value.data);
      networkImages.removeWhere((item) => item.id == imageId);
      emit(AssociateItemsDeleteSuccess(successModel: successModel));
    }).catchError((e) {
      print(e);
      emit(AssociateItemsDeleteFailed());
    });
  }

  int checkedNumberSum = 0;

  void checkedItemsNumber() {
    checkedNumberSum = 0;
    if (providerOrderDetails?.items == null) {
      checkedNumberSum = 0;
    } else {
      for (var ele in providerOrderDetails!.items!) {
        checkedNumberSum += ele.quantity!;
      }
    }
    emit(GetterSuccess());
  }

  increaseQuantityOfItem(pricelist.Items item) {
    if (item.selectedQuantity == 0) {
      selectedItems.add(item);
    }
    item.selectedQuantity = item.selectedQuantity! + 1;
    emit(NotifyListeners());
  }

  decreaseQuantityOfItem(pricelist.Items item) {
    if (item.selectedQuantity! > 0) {
      item.selectedQuantity = item.selectedQuantity! - 1;
    }
    if (item.selectedQuantity == 0) {
      selectedItems.remove(item);
    }
    emit(NotifyListeners());
  }

  List<pricelist.Items?>? itemList = [];
  getItemList() {
    int? _serIndex =
        priceList.indexWhere((element) => element.id == selectedServicesId);

    int? catIndex = priceList[_serIndex]
        .categories
        ?.indexWhere((element) => element.id == selectedCatId);
    itemList = priceList[_serIndex].categories?[catIndex!].items;
    emit(NotifyListeners());
  }

  // search
  List<pricelist.Items?>? searchPriceList = [];

  onSearchTextChanged(String text) {
    searchPriceList?.clear();
    if (text.isEmpty) {
      emit(NotifyListeners());
      return;
    }
    for (var element in itemList!) {
      if (element!.name!.contains(text) ||
          element.categoryItemServiceId.toString().contains(text)) {
        searchPriceList?.add(element);
      }
    }
    emit(NotifyListeners());
  }

  var formKey = GlobalKey<FormState>();
}
