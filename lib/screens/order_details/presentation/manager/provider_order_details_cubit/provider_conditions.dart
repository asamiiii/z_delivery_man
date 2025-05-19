import 'package:flutter/material.dart';

class ProviderConditions {
  static bool showAddItemButton(
      {required bool isDeliveyMan, required String status}) {
    debugPrint('status: $status');
    if (isDeliveyMan == false && status == 'provider_received'||status == 'client_confirm') {
      return true;
    }
    return false;

    // return status == 'provider_received';
  }
}
