import 'dart:io';

class UploadedImageModel{
  File? imageFile;
  String? imagePath;
  String? comment;

  UploadedImageModel({this.imageFile,this.imagePath,this.comment});
}


class RemoteImage{
  
  dynamic url ;
  int? id;
  String? comment;

  RemoteImage(this.url,this.id,{this.comment}); 

  RemoteImage.fromjson(dynamic json){
   url = json["path"].toString().replaceAll('\\', '');
   id = json["id"];
   comment = json["comment"]??'';

  }
}