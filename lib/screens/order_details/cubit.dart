import 'dart:convert';
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

    debugPrint("order ID $orderId");
    return DioHelper.getData(url: "$GET_ORDER_DETAILS/$orderId", token: token)
        .then((value) {
      debugPrint("Details ${value.data}");
      orderDetailsModel = OrderDetailsModel.fromJson(value.data);
      debugPrint("$orderDetailsModel  order datails model");

      emit(OrderDetailsSuccessState());
    }).catchError((e) {
      debugPrint('details filed $e');
      emit(OrderDetailsFailedState());
    });
  }

  List<InitQuantityModel> initQuantityInPriceList = [];

  ProviderOrderDetails? providerOrderDetails;
  Future<void> getProviderOrderDetails({required int? orderId}) async{
    // ProviderOrderDetails? providerOrderDetails;
    debugPrint('Order Id : $orderId');
    emit(OrderProviderDetailsLoadingState());
    initQuantityInPriceList = [];
    return await DioHelper.getData(
            url: "$GET_PROVIDER_ORDER_DETAILS/$orderId", token: token)
        .then((value) {
      // print('order id : $orderId');
   
      // var rsponse = jsonDecode(value.data);
      // debugPrint('getProviderOrderDetails : ${value.data}');
      providerOrderDetails = ProviderOrderDetails.fromJson(value.data);
      checkedItemsNumber();
      emit(OrderProviderDetailsSuccessState());
      // if (providerOrderDetails?.images != null) {
      //   for (var item in providerOrderDetails!.images!) {
      //     networkImages.add(item);
      //   }
      //   emit(OrderProviderDetailsSuccessState());
      // }
      for (var i in providerOrderDetails!.items!) {
        initQuantityInPriceList.add(InitQuantityModel(
            initQuantity: i.quantity,
            catItemServiceId: i.categoryItemServiceId));
      }
      debugPrint(
          'initQuantityInPriceList : ${initQuantityInPriceList.map((e) => e.catItemServiceId)}');
    }).catchError((e) {
      debugPrint('details filed $e');
      emit(OrderProviderDetailsFailedState());
    }
    );
  }

  Future <void> goToNextStatus(
      {required int? orderId,
      int? itemCount,
      String? comment,
      required bool isDeliveryMan})async {
    emit(OrderDetailsNextStatusLoadingState());
    await DioHelper.postData(
        url: isDeliveryMan
            ? "$POST_ORDERS_NEXT_STATUS/$orderId/nextStatus"
            : "$POST_ORDERS_NEXT_STATUS_PROVIDER/$orderId/nextStatus",
        token: token,
        data: {"item_count": itemCount, "comment": comment}).then((value) {
      debugPrint('Go to next : ${value.data}');
      emit(OrderDetailsNextStatusSuccessState());
    }).catchError((e) {
      debugPrint("$e error of next status");
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
      debugPrint('$e collect error');
      emit(OrderDetailsCollectOrderStatusFailedState());
    });
  }

  List<pricelist.PriceList> priceList = [];
  Future<void> getPriceList({
    required int? orderId,
  }) async {
    emit(PriceListLoading());
    DioHelper.getData(
            url: "$Get_STATUS_PROVIDER/$orderId/priceList", token: token)
        .then((value) {
      debugPrint('price list : $value');
      priceList = pricelist.priceListFromJson(value.data);
      debugPrint(
          'PriceList : ${priceList[0].categories![0].items![0]?.withDimension}');
      setInitServicesAndCat(priceList.first.id);
      getItemList();
      emit(PriceListSuccess());
    }).catchError((e) {
      debugPrint(e);
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

  PreferenceModel? preferencesModel;
  Future<void> getPreferences({
    required List<Map<String, dynamic>> data,
  }) async {
    _listData.clear();
    emit(PreferencesLoading());
    await DioHelper.postData(
        url: Get_PREFERENCSE,
        token: token,
        data: {"items": data}).then((value) {
      debugPrint('pref resp : ${value.data}');
      List responseData = value.data;
      // preferencesModel = PreferenceModel.fromJson(value.data);
      debugPrint('getPreferences');
      _listData = responseData.map((e) => PreferenceModel.fromJson(e)).toList();
      emit(PreferencesSuccess());
    }).catchError((e) {
      debugPrint(e);
      emit(PreferencesFailed());
    });
  }

  List<PreferenceModel> _listData = [];
  List<PreferenceModel> get listData => _listData;

  List<Map<String, int>>? _prefereceList = [];
  List<Map<String, int>>? get prefereceList => _prefereceList;

  // removePrefereceList() {
  //   _prefereceList = [];
  //   emit(RemovePrefereceList());
  // }

  void setItemIsEnabled({
    required PreferenceModel preferenceModel,
    required int itemId,
    required int catSerItemId,
    bool all = false,
  }) {
    debugPrint('_prefereceList');
    int indexLocal = _prefereceList!.indexWhere((item) =>
        item['item_id'] == itemId &&
        item['preference_id'] == preferenceModel.id &&
        item['category_item_service_id'] == catSerItemId);

    if (all) {
      int prefLength = _prefereceList!
          .where((element) => element['preference_id'] == preferenceModel.id)
          .toList()
          .length;
      int index =
          _listData.indexWhere((element) => element.id == preferenceModel.id);
      int listLength = _listData[index].items.length;
      if (prefLength != listLength) {
        _prefereceList!.removeWhere(
            (element) => element['preference_id'] == preferenceModel.id);
        for (var element in preferenceModel.items) {
          _prefereceList!.add({
            'preference_id': preferenceModel.id,
            'item_id': element.id ?? 0,
            'category_item_service_id': element.categoryItemServiceId ?? 0
          });
          // notifyListeners();
          emit(NotifyListeners());
        }
      } else {
        _prefereceList!.removeWhere(
            (element) => element['preference_id'] == preferenceModel.id);
        // notifyListeners();
        emit(NotifyListeners());
      }
    } else {
      if (indexLocal == -1) {
        debugPrint('Pref : $prefereceList');
        _prefereceList!.add({
          'preference_id': preferenceModel.id,
          'item_id': itemId,
          'category_item_service_id': catSerItemId
        });
        // notifyListeners();
        // emit(NotifyListeners());

        for (var map in _prefereceList!) {
          if (map.containsKey('preference_id')) {
            if (map['preference_id'] != preferenceModel.id &&
                map['item_id'] == itemId &&
                map['category_item_service_id'] == catSerItemId) {
              _prefereceList!.remove(map);
              // notifyListeners();
              emit(NotifyListeners());
            }
            // notifyListeners();
            // emit(NotifyListeners());
          }
        }
      } else {
        _prefereceList!.removeAt(indexLocal);
        // notifyListeners();
        emit(NotifyListeners());
      }
      // notifyListeners();
      emit(NotifyListeners());
    }
    debugPrint('Pref List : $prefereceList');
  }

  // void setItemIsEnabled({
  //   required Item? preferenceModel,
  //   required int? itemId,
  //   bool all = false,
  // }) {
  //   int indexLocal = _prefereceList.indexWhere((item) =>
  //       item['item_id'] == itemId &&
  //       item['preference_id'] == preferenceModel?.id);

  //   if (all) {
  //     int prefLength = _prefereceList
  //         .where((element) => element['preference_id'] == preferenceModel?.id)
  //         .toList()
  //         .length;
  //     int _index =
  //         _listData.indexWhere((element) => element.id == preferenceModel?.id);
  //     int listLength = _listData[_index].items!.length;
  //     if (prefLength != listLength) {
  //       _prefereceList.removeWhere(
  //           (element) => element['preference_id'] == preferenceModel?.id);
  //       for (var element in preferenceModel!.items!) {
  //         _prefereceList.add(
  //             {'preference_id': preferenceModel.id!, 'item_id': element.id!});
  //         emit(NotifyListeners());
  //       }
  //     } else {
  //       _prefereceList.removeWhere(
  //           (element) => element['preference_id'] == preferenceModel?.id);
  //       emit(NotifyListeners());
  //     }
  //   } else {
  //     if (indexLocal == -1) {
  //       _prefereceList
  //           .add({'preference_id': preferenceModel!.id!, 'item_id': itemId!});
  //       emit(NotifyListeners());

  //       for (var map in _prefereceList) {
  //         if (map.containsKey('preference_id')) {
  //           if (map['preference_id'] != preferenceModel.id &&
  //               map['item_id'] == itemId) {
  //             _prefereceList.remove(map);
  //             emit(NotifyListeners());
  //           }

  //           // _prefereceList.removeWhere((element) => element["item_id"] == itemId &&element['preference_id'] ==preferenceModel.id);
  //           //          notifyListeners();
  //         }
  //       }
  //       // _prefereceList
  //       //     .add({'preference_id': preferenceModel.id, 'item_id': itemId});
  //       // notifyListeners();
  //     } else {
  //       _prefereceList.removeAt(indexLocal);
  //       emit(NotifyListeners());
  //     }
  //     emit(NotifyListeners());
  //   }
  // }

  bool checkIfEnable(
      {required PreferenceModel preferenceModel,
      required int itemId,
      required int catItemSerId}) {
    int indexLocal = _prefereceList!.indexWhere((item) =>
        item['item_id'] == itemId &&
        item['preference_id'] == preferenceModel.id &&
        item['category_item_service_id'] == catItemSerId);

    if (itemId == 0) {
      int prefLength = _prefereceList!
          .where((element) => element['preference_id'] == preferenceModel.id)
          .toList()
          .length;
      int index =
          _listData.indexWhere((element) => element.id == preferenceModel.id);
      int listLength = _listData[index].items.length;
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
  int? totalQuantity = 0;

  SuccessModel? successModel;
  void postAssociateItems(
      {required int? orderId,
      required List<Map<String, dynamic>>? itemList,
      required List<Map<String, dynamic>>? prefernces}) {
    emit(AssociateItemsPostLoading());
    debugPrint('$itemList');
    debugPrint('$prefernces');
    debugPrint('associateItems : ${{
      "item_list": itemList,
      "preferences": prefernces
    }}');
    DioHelper.postData(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/associateItems",
            data: {"item_list": itemList, "preferences": _prefereceList},
            token: token)
        .then((value) {
      debugPrint('associateItems response${value.data}');
      successModel = SuccessModel.fromJson(value.data);
      emit(AssociateItemsPostSuccess(successModel: successModel));
    }).catchError((e) {
      debugPrint('$e');
      emit(AssociateItemsPostFailed());
    });
  }

  Future<void> updateAssociateItems(
      {required int? orderId,
      required int? itemId,
      required int? quantity,
      Map<String, dynamic>? data,
      bool? meter = false}) {
    emit(AssociateItemsUpdateLoading());
    debugPrint(
        "updateAssociateItems Url : $POST_ASSOCIATE_ITEMS/$orderId/items/$itemId");
    return DioHelper.updateData(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/items/$itemId",
            data: {
              'quantity': quantity,
              'width': meter == true ? data!['width'] : null,
              'length': meter == true ? data!['length'] : null,
              'item_details': meter == true ? data!['item_details'] : null
            },
            token: token)
        .then((value) {
      try {
        debugPrint('updateAssociateItems: ${value.data}');
        successModel = SuccessModel.fromJson(value.data);
        emit(AssociateItemsUpdateSuccess(successModel: successModel));
      } catch (e) {
        debugPrint('error$e');
        emit(AssociateItemsUpdateFailed());
      }
    }).catchError((e) {
      debugPrint('$e');
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
      debugPrint(e);
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
      debugPrint("No Image Selected");
      emit(ImagePickedStateFailed());

      return null;
    }
  }

  //! Send Images -->
  Future<void> addImagesToThisItem({
    required int? orderId,
    required int? itemId,
    required List<String>? imagesList,
    // Map<String, dynamic>? data,
    // bool? meter = false
  }) {
    emit(AssociateItemsUpdateLoading());
    //! Yes
    debugPrint(
        "Add Images EndPoint : $POST_ASSOCIATE_ITEMS/$orderId/items/$itemId");
    return DioHelper.updateData(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/items/$itemId",
            data: {
              // 'quantity': quantity,
              // 'width': meter == true ? data!['width'] : null,
              // 'length': meter == true ? data!['length'] : null,
              // 'item_details': meter == true ? data!['item_details'] : null
            },
            token: token)
        .then((value) {
      try {
        debugPrint('updateAssociateItems: ${value.data}');
        successModel = SuccessModel.fromJson(value.data);
        emit(AssociateItemsUpdateSuccess(successModel: successModel));
      } catch (e) {
        debugPrint('error$e');
        emit(AssociateItemsUpdateFailed());
      }
    }).catchError((e) {
      debugPrint('$e');
      emit(AssociateItemsUpdateFailed());
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
      debugPrint(e);
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
    // getTotalQuantity();
    emit(NotifyListeners());
  }

  decreaseQuantityOfItem(pricelist.Items item) {
    if (item.selectedQuantity! > 0) {
      item.selectedQuantity = item.selectedQuantity! - 1;
    }
    if (item.selectedQuantity == 0) {
      selectedItems.remove(item);
    }
    // getTotalQuantity();
    emit(NotifyListeners());
  }

  getTotalQuantity() {
    totalQuantity = 0;
    for (var element in selectedItems) {
      totalQuantity = totalQuantity! + element.selectedQuantity!;
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

class InitQuantityModel {
  int? catItemServiceId;
  int? initQuantity;

  InitQuantityModel({this.catItemServiceId, this.initQuantity});
}
