import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/network/remote/dio_helper.dart';
import 'package:z_delivery_man/network/remote/fire_storage.dart';
import 'package:z_delivery_man/screens/order_details/order_details_state.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/upladed_image_model.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

class OrderItemImagesCubit extends Cubit<OrderItemImagesState> {
  OrderItemImagesCubit() : super(OrderItemImagesInitialState());

  static OrderItemImagesCubit get(context) => BlocProvider.of(context);

  final imageKey = GlobalKey<ImagePainterState>();
  List<UploadedImageModel> imagesLocalFiles = [];
  List<String> remoteList = [];

//* Pick Image Form Camera
//* and Add Picked Image To imagesLocalFiles List
  pickImageFromCamera() async {
    emit(OrderItemImagesLoadingState());
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    if (pickedFile != null){
      var imageLength= (await pickedFile.length()/ (1024 * 1024)).toStringAsFixed(3);
      debugPrint('imageLength $imageLength');
      emit(OrderItemImagesSuccessState());
      imagesLocalFiles.add(UploadedImageModel(
          imageFile: File(pickedFile.path), imagePath: pickedFile.path));
    }
    debugPrint('imagesLocalFiles : $imagesLocalFiles');
  }

  //* Save Image After Edit
  Future<void> saveImage(BuildContext context, File localImage) async {
    var index = 0;
    emit(OrderItemImagesLoadingState());
    final image = await imageKey.currentState?.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath =
        '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File(fullPath);
    if (image != null) {
      for (var element in imagesLocalFiles) {
        if (element.imageFile == localImage) {
          index = imagesLocalFiles.indexOf(element);
          imagesLocalFiles.removeAt(index);
          imagesLocalFiles.insert(
              index,
              UploadedImageModel(
                  imageFile: File(fullPath), imagePath: fullPath));
          debugPrint('image is exist');
          imgFile.writeAsBytesSync(image);
          break;
        }
      }
      emit(OrderItemImagesSuccessState());
    }
  }

//! Canceled
//* Uploade All Local Images To Fire Storage and Get URL
  Future<void> uploadImagesToStorage() async {
    List<String> imagesUrl = [];
    emit(OrderItemImagesLoadingState());
    try {
      if (imagesLocalFiles.isNotEmpty) {
        for (var element in imagesLocalFiles) {
          imagesUrl.add(await FireStorage.uploadImageOnFirebaseStorage(
              element.imageFile!, element.imagePath!));
          debugPrint('images URL  $imagesUrl');

          remoteList = imagesUrl;
          // emit(OrderItemImagesSuccessState());
        }
      } else {
        showToast(message: 'لا يوجد صور !', state: ToastStates.ERROR);
      }
      emit(OrderItemImagesSuccessState());
    } catch (error) {
      showToast(message: '$error', state: ToastStates.ERROR);
      emit(OrderItemImagesFailedState());
    }
    emit(OrderItemImagesStopLoadingState());
  }

//! Upload List Of Images Into Item order
  Future<void> postAssociateImage(
      {required int? orderId, required int? itemId}) async {
        var totalImagesSize = 0.0;
    // emit(PostAssociateImagesLoading());
    emit(OrderItemImagesLoadingState());
    List<MultipartFile> imagesFiles = [];
    //! Convert List Of Files (images) To List Of MultipartFile
    for (var element in imagesLocalFiles) {
      String fileName = element.imageFile!.path.split('/').last;
      debugPrint('fileName : $fileName');
      imagesFiles.add(await MultipartFile.fromFile(element.imageFile!.path,
          filename: fileName));
      totalImagesSize =( totalImagesSize + await element.imageFile!.length()/ (1024 * 1024));
    }
    debugPrint('imagesFiles : $imagesFiles');
    debugPrint('Total Images Size : ${totalImagesSize.toStringAsFixed(4)}');
    var formData = FormData();
    formData = FormData.fromMap({"images[]": imagesFiles, "item_id": itemId});

    await DioHelper.postDataMultipart(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/associateImages",
            token: token,
            data: formData)
        .then((value) {
      debugPrint(value.data);
      // successModel = SuccessModel.fromJson(value.data);
      if (value.data.toString() == '{"status":true}') {
        emit(OrderItemImagesSuccessState());
        // emit(PostAssociateImagesSuccess());
      } else {
        emit(OrderItemImagesFailedState());
        // emit(PostAssociateImagesFailed());
      }
    }).catchError((e) {
      debugPrint(e.toString());
      emit(OrderItemImagesFailedState());
    });
  }

  removeImageFromFireStorage(String? imageUrl) {
    emit(OrderItemImagesLoadingState());
    remoteList.remove(imageUrl);
    emit(OrderItemImagesSuccessState());
  }

  removeImageFromLocalStorageList(File? image) {
    emit(OrderItemImagesLoadingState());
    imagesLocalFiles.removeWhere((element) => element.imageFile == image);
    emit(OrderItemImagesSuccessState());
  }

  getOrderItemImages() {
    //! get order images from backend
  }

  sendOrderItemImages() {
    //! send the images to backend
  }
}
