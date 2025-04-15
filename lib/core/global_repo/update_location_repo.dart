import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/network/remote/dio_helper.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

class UpdateLocationRepo {
  static updateLocation(Position? currentPosition) {
    try {
      DioHelper.postData(
          url: EndPoints.updateLocation,
          data: {
            "latitude": currentPosition?.latitude,
            "longitude": currentPosition?.longitude
          },
          token: token);
    } catch (e) {
      debugPrint("Error:$e");
    }
  }
}
