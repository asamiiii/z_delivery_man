import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static bool isDialogShowing = false;
  // Check and request permission
  Future<bool> _handleLocationPermission(BuildContext context,
      {bool isMandatory = false}) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Show a dialog asking the user to enable permission
        _showPermissionDeniedDialog(context, isMandatory: isMandatory);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      _showPermissionPermanentlyDeniedDialog(context, isMandatory: isMandatory);
      return false;
    }

    return true;
  }

  // Show a dialog to prompt the user to enable permission
  void _showPermissionDeniedDialog(BuildContext context,
      {bool isMandatory = false}) {
    isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('الاذن مرفوض'),
        content: Text(
         'تم رفض الاذن',
        ),
        actions: [
          if (!isMandatory)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('الغاء'),
            ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: Text('افتح الاعدادات'),
          ),
        ],
      ),
    ).then((value) => isDialogShowing = false);
  }

  // Show a dialog when permission is permanently denied
  void _showPermissionPermanentlyDeniedDialog(BuildContext context,
      {bool isMandatory = false}) {
    isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('تم رفض الإذن بشكل دائم'),
        content: Text(
          'تم رفض الإذن بشكل دائم',
        ),
        actions: [
          if (!isMandatory)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('الغاء'),
            ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: Text('افتح الاعدادات'),
          ),
        ],
      ),
    ).then((value) => isDialogShowing = false);
  }

  // Show a dialog to prompt the user to enable location services
  void _showLocationServicesDisabledDialog(BuildContext context,
      {bool isMandatory = false}) {
    isDialogShowing = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('خدمة الموقع غير متاحه'),
          content: Text('خدمة الموقع غير متاحه'),
          actions: [
            if (!isMandatory)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("االغاء"),
              ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
              child: Text('افتح الاعدادات'),
            ),
          ],
        );
      },
    ).then((value) => isDialogShowing = false);
  }

  // Get current location
  Future<Position?> getCurrentLocation(BuildContext context,
      {bool isMandatory = false}) async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Show dialog to enable location services
      _showLocationServicesDisabledDialog(context, isMandatory: isMandatory);
      return null;
    }

    // Handle permission
    bool hasPermission =
        await _handleLocationPermission(context, isMandatory: isMandatory);
    if (!hasPermission) {
      // Permission denied or permanently denied
      return null;
    }
    var current = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // Get the current position
    debugPrint(
        'getCurrentLocation lat : ${current.latitude} ,  getCurrentLocation lng :${current.longitude}');
    return current;
  }
}
