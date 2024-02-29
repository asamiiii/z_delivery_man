import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/network/remote/dio_helper.dart';
import 'package:z_delivery_man/network/remote/fire_storage.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/upladed_image_model.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

class OrderItemImagesCubit extends Cubit<OrderItemImagesState> {
  OrderItemImagesCubit() : super(OrderItemImagesInitialState());

  static OrderItemImagesCubit get(context) => BlocProvider.of(context);

  List<UploadedImageModel> imagesLocalFiles = [];
  List<RemoteImage> remoteList = [];
  bool addLocalShimmer = false;
  final imageKey = GlobalKey<ImagePainterState>();

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

      // imagesLocalFiles.add(UploadedImageModel(
      //     imageFile: File(pickedFile.path), imagePath: pickedFile.path));

      // emit(OrderItemImagesUpLoadingState());
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

  Future<void> saveImage({int? orderId, int? itemId,int? imageId}) async {
    emit(PaintLoading());
    final image = await imageKey.currentState?.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath =
        '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File(fullPath);
    if (image != null) {
      try {
        imgFile.writeAsBytesSync(image);
        var imageLength =
          (await imgFile.length() / (1024 * 1024)).toStringAsFixed(3);
        debugPrint('Save Image Size : $imageLength');
        emit(PaintLoading());
        await updateAssociateImage(
            imageFile:
                UploadedImageModel(imageFile: imgFile, imagePath: imgFile.path),
            orderId: orderId,
            imageId: imageId);
        emit(PaintSuccess());
      } catch (e) {
        emit(PaintFailed());
      }
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

  String generateRandomString(int len) {
    var r = Random();
    String randomString =
        String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
    return randomString;
  }

//! Upload List Of Images Into Item order
  Future<void> postAssociateImage(
      {required UploadedImageModel imageFile,
      required int? orderId,
      required int? itemId,
      bool? isUpdate =false
      }) async {
    var totalImagesSize = 0.0;
    debugPrint('orderId : $orderId');
    debugPrint('itemId : $itemId');
    debugPrint('Image Path : ${imageFile.imagePath}');
    debugPrint('Image Name : ${imageFile.imageFile}');
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
    remoteList.add(RemoteImage('', null, comment: ''));
    await DioHelper.postDataMultipart(
            url:"$POST_ASSOCIATE_ITEMS/$orderId/associateImages",
            token: token,
            data: formData)
        .then((value) {
      debugPrint('postAssociateImage Response : ${value.data}');
      List<dynamic> response = jsonDecode(value.data);
      debugPrint('response type : ${response.runtimeType}');
      debugPrint('postAssociateImage Response : $response');
      List<RemoteImage> remoteImages =
          response.map((json) => RemoteImage.fromjson(json)).toList();

      int usedIndex = remoteList
          .indexWhere((element) => element.url == '' || element.id == null);
      remoteList[usedIndex] =
          RemoteImage(remoteImages.first.url, remoteImages.first.id);
      debugPrint('remoteList.length : ${remoteList.length}');
      emit(OrderItemImagesSuccessState());
      // imageFile.imageFile?.delete();
    }).catchError((e) {
      debugPrint('Image uploade Error : ${e.toString()}');
      int usedIndex = remoteList
          .indexWhere((element) => element.url == '' || element.id == null);
      remoteList.removeAt(usedIndex);
      emit(OrderItemImagesFailedState());
    });
  }


    Future<void> updateAssociateImage(
      {required UploadedImageModel imageFile,
      required int? orderId,
      required int? imageId
      }) async {
    var totalImagesSize = 0.0;
    debugPrint('orderId : $orderId');
    // debugPrint('itemId : $itemId');
    debugPrint('Image Path : ${imageFile.imagePath}');
    debugPrint('Image Name : ${imageFile.imageFile}');
    emit(OrderItemImagesLoadingState());
    // List<MultipartFile> imagesFiles = [];
    //! Convert List Of Files (images) To List Of MultipartFile
    // for (var element in imagesLocalFiles) {
    String fileName = imageFile.imageFile!.path.split('/').last;
    debugPrint('fileName : $fileName');

    debugPrint('Total Images Size : ${totalImagesSize.toStringAsFixed(3)}');
    var formData = FormData();
    formData = FormData.fromMap({
      "new_image": await MultipartFile.fromFile(imageFile.imageFile!.path,
          filename: fileName),
    });
    // remoteList.add(RemoteImage('', null, comment: ''));
    int usedIndex = remoteList
          .indexWhere((element) => element.id == imageId);
      remoteList[usedIndex] =
          RemoteImage('', null);
    await DioHelper.postDataMultipart(
            url:"provider/orders/$orderId/images/$imageId/update",
            token: token,
            data: formData)
        .then((value) {
      debugPrint('postAssociateImage Response : ${value.data}');
      dynamic response = jsonDecode(value.data);
      debugPrint('response type : ${response.runtimeType}');
      debugPrint('postAssociateImage Response : $response');
      RemoteImage remoteImages =  RemoteImage.fromjson(response);

      // int usedIndex = remoteList
      //     .indexWhere((element) => element.id == imageId);
      remoteList[usedIndex] =
          RemoteImage(remoteImages.url, remoteImages.id);
      debugPrint('remoteList.length : ${remoteList.length}');
      emit(OrderItemImagesSuccessState());
      // imageFile.imageFile?.delete();
    }).catchError((e) {
      debugPrint('Image uploade Error : ${e.toString()}');
      // int usedIndex = remoteList
      //     .indexWhere((element) => element.url == '' || element.id == null);
      // remoteList.removeAt(usedIndex);
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
      debugPrint(
          'deleteAssociateImage Response :  ${value.data.toString().trim()}');
      if (value.data.toString().trim().contains('true')) {
        emit(OrderItemRemoveImagesSuccessState());
        debugPrint('Done');
        remoteList.removeWhere((item) => item.id == imageId);
      } else {
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
      {required int? orderId, required int? imageId, String? comment}) {
    debugPrint('image Id $imageId');
    debugPrint('Order Id $orderId');
    emit(OrderItemCommentLoadingState());
    debugPrint(
        'addComment EndPoint : $DELETE_ASSOCIATE_IMAGE/$orderId/images/$imageId');
    return DioHelper.updateData(
            url: "$DELETE_ASSOCIATE_IMAGE/$orderId/images/$imageId",
            data: {"comment": comment},
            token: token)
        .then((value) {
      //   final jsonData = jsonDecode(value.data.toString());
      //   debugPrint('addComment Response : $jsonData');
      //  debugPrint('addComment Response :  ${value.data}');
      RemoteImage image = RemoteImage.fromjson(value.data);
      debugPrint('comment Response :  ${image.comment}');
      if (image.id == imageId) {
        debugPrint('Done');
        // remoteList.(remoteList.indexWhere((element) => element.id==imageId), RemoteImage(comment: image.comment,image.url,image.id));
        int usedIndex =
            remoteList.indexWhere((element) => element.id == imageId);
        remoteList[usedIndex] =
            RemoteImage(image.url, image.id, comment: image.comment);
        emit(OrderItemCommentSuccessState());
      } else {
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
