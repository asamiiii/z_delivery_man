import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:z_delivery_man/network/remote/fire_storage.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/upladed_image_model.dart';

class OrderItemImagesCubit extends Cubit<OrderItemImagesState> {
  OrderItemImagesCubit() : super(OrderItemImagesInitialState());

  static OrderItemImagesCubit get(context) => BlocProvider.of(context);

  final imageKey = GlobalKey<ImagePainterState>();
  List<UploadedImageModel> imagesLocalFiles = [];
  List<String> remoteList = [];

  pickImageFromCamera() async {
    emit(OrderItemImagesLoadingState());
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    if (pickedFile != null) {
      emit(OrderItemImagesSuccessState());
      imagesLocalFiles
          .add(UploadedImageModel(File(pickedFile.path), pickedFile.path));
    }
    debugPrint('imagesLocalFiles : $imagesLocalFiles');
  }

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
              index, UploadedImageModel(File(fullPath), fullPath));
          debugPrint('image is exist');
          imgFile.writeAsBytesSync(image);
          break;
        }
      }
      emit(OrderItemImagesSuccessState());
    }
  }

  Future<void> uploadImagesToStorage() async {
    List<String> imagesUrl = [];
    emit(OrderItemImagesLoadingState());
    try {
      for (var element in imagesLocalFiles) {
        imagesUrl.add(await FireStorage.uploadImageOnFirebaseStorage(
            element.imageFile!, element.imagePath!));
        debugPrint('images URL  $imagesUrl');

        remoteList = imagesUrl;
        emit(OrderItemImagesSuccessState());
      }
    } catch (error) {
      emit(OrderItemImagesFailedState());
    }

    // return imagesUrl;
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
}
