import 'dart:io';

class UploadedImageModel{
  File? imageFile;
  String? imagePath;
  String? comment;

  UploadedImageModel({this.imageFile,this.imagePath,this.comment});
}