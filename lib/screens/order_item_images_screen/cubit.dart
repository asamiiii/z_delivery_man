import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:z_delivery_man/models/success_model.dart';
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
  List<RemoteImage> remoteList = [];
  bool addLocalShimmer = false;

//* Pick Image Form Camera
//* and Add Picked Image To imagesLocalFiles List
  Future pickImageFromCamera(
      {required int? orderId, required int? itemId}) async {
    emit(OrderItemImagesLoadingState());
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    if (pickedFile != null) {
      // var imageLength =
      //     (await pickedFile.length() / (1024 * 1024)).toStringAsFixed(3);
      // debugPrint('imageLength $imageLength');

      imagesLocalFiles.add(UploadedImageModel(
          imageFile: File(pickedFile.path), imagePath: pickedFile.path));

      emit(OrderItemImagesUpLoadingState());
      // await uploadImagesToStorage(UploadedImageModel(
      //     imageFile: File(pickedFile.path), imagePath: pickedFile.path));
      await postAssociateImage(
          itemId: itemId,
          orderId: orderId,
          imageFile: UploadedImageModel(
              imageFile: File(pickedFile.path), imagePath: pickedFile.path));
      // emit(OrderItemImagesSuccessState());
    }
    debugPrint('imagesLocalFiles : $imagesLocalFiles');
  }

  //* Save Image After Edit
  Future<void> saveImage(BuildContext context, File localImage , int? orderId , int? itemId) async {
    var index = 0;
    emit(OrderItemImagesLoadingState());
    final image = await imageKey.currentState?.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath =
        '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File(fullPath);
    imgFile.writeAsBytesSync(image!);
    await postAssociateImage(imageFile: UploadedImageModel(imageFile: imgFile,imagePath: imgFile.path), orderId: orderId, itemId: itemId);
    if (image != null) {
      for (var element in imagesLocalFiles) {
        if (element.imageFile == localImage) {
          // index = imagesLocalFiles.indexOf(element);
          // imagesLocalFiles.removeAt(index);
          // imagesLocalFiles.insert(
          //     index,
          //     UploadedImageModel(
          //         imageFile: File(fullPath), imagePath: fullPath));
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
  Future<void> uploadImagesToStorage(UploadedImageModel imageFile) async {
    // String imagesUrl = ;

    emit(OrderItemImagesLoadingState());
    try {
      if (imagesLocalFiles.isNotEmpty) {
        var url = await FireStorage.uploadImageOnFirebaseStorage(
            imageFile.imageFile!, imageFile.imagePath!);

        //  remoteList.removeLast();
        remoteList.add(RemoteImage(url, null));
        emit(OrderItemImagesSuccessState());
      } else {
        emit(OrderItemImagesFailedState());
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
      {required UploadedImageModel imageFile,
      required int? orderId,
      required int? itemId}) async {
    var totalImagesSize = 0.0;
    debugPrint('orderId : $orderId');
    debugPrint('itemId : $itemId');
    // emit(PostAssociateImagesLoading());
    emit(OrderItemImagesLoadingState());
    // List<MultipartFile> imagesFiles = [];
    //! Convert List Of Files (images) To List Of MultipartFile
    // for (var element in imagesLocalFiles) {
    String fileName = imageFile.imageFile!.path.split('/').last;
    debugPrint('fileName : $fileName');

    debugPrint('Total Images Size : ${totalImagesSize.toStringAsFixed(3)}');
    var formData = FormData();
    formData = FormData.fromMap({
      "images[]": await MultipartFile.fromFile(imageFile.imageFile!.path,
          filename: fileName),
      "item_id": itemId
    });
    remoteList.add(RemoteImage('', null));
    await DioHelper.postDataMultipart(
            url: "$POST_ASSOCIATE_ITEMS/$orderId/associateImages",
            token: token,
            data: formData)
        .then((value) {
      List<dynamic> response = jsonDecode(value.data);
      List<RemoteImage> remoteImages =
          response.map((json) => RemoteImage.fromjson(json)).toList();
      // remoteList.add(remoteImages.first);

      int usedIndex = remoteList
          .indexWhere((element) => element.url == '' || element.id == null);
      remoteList[usedIndex] =
          RemoteImage(remoteImages.first.url, remoteImages.first.id);
      debugPrint('remoteList.length : ${remoteList.length}');
      emit(OrderItemImagesSuccessState());
      // imageFile.imageFile?.delete();
    }).catchError((e) {
      debugPrint(e.toString());
      int usedIndex = remoteList
          .indexWhere((element) => element.url == '' || element.id == null);
      remoteList.removeAt(usedIndex);
      emit(OrderItemImagesFailedState());
    });
  }

  //! delete Image In Order
  Future<void> deleteAssociateImage(
      {required int? orderId, required int? imageId}) {
    emit(OrderItemRemoveImagesLoadingState());
    return DioHelper.deleteData(
            url: "$DELETE_ASSOCIATE_IMAGE/$orderId/images/$imageId",
            token: token)
        .then((value) {
       debugPrint('deleteAssociateImage Response :  ${value.data}');
      if (value.data.toString().contains('"status":true') ) {
        emit(OrderItemRemoveImagesSuccessState());
        debugPrint('Done');
        remoteList.removeWhere((item) => item.id == imageId);
      }else{
        debugPrint('Fail');
        emit(OrderItemRemoveImagesFailedState());
      }

    }).catchError((e) {
      debugPrint('deleteAssociateImage Error :  $e');
      emit(OrderItemImagesFailedState());
    });
  }


    //! delete Image In Order
  Future<void> addComment(
      {required int? orderId, required int? imageId,String? comment}) {
    emit(OrderItemCommentLoadingState());
    debugPrint('addComment EndPoint : $DELETE_ASSOCIATE_IMAGE/$orderId/images/$imageId');
    return DioHelper.updateData(
            url: "$DELETE_ASSOCIATE_IMAGE/$orderId/images/$imageId",
            data: {"comment":comment},
            token: token)
        .then((value) {
        final jsonData = jsonDecode(value.data.toString());
       debugPrint('addComment Response :  ${value.data}');
       RemoteImage image = RemoteImage.fromjson(jsonData);
       debugPrint('comment Response :  ${image.comment}');
       if(image.id == imageId){
        debugPrint('Done');
        // remoteList.(remoteList.indexWhere((element) => element.id==imageId), RemoteImage(comment: image.comment,image.url,image.id));
        int usedIndex = remoteList
          .indexWhere((element) => element.id == imageId);
      remoteList[usedIndex] =
          RemoteImage(image.url,image.id,comment: image.comment);
        emit(OrderItemCommentSuccessState());
       }else{
        debugPrint('Fail');
        emit(OrderItemCommentFailedState());
       }
    }).catchError((e) {
      debugPrint('deleteAssociateImage Error :  $e');
      emit(OrderItemCommentFailedState());
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


Future<File> downloadAndSaveImage(String imageUrl) async {
  final dio = Dio();
  emit(PaintLoading());
  final appDir = await getApplicationDocumentsDirectory();
  final fileName = 'image.jpg'; // Provide a desired file name and extension

  final file = File('${appDir.path}/$fileName');
  emit(PaintLoading());
  await dio.download(imageUrl, file.path);
  emit(PaintSuccess());
  print('Image downloaded and saved at: ${file.path}');
  
  return file;
}

}



