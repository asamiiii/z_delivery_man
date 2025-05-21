import 'dart:convert';

import 'package:z_delivery_man/network/local/cach_constatnts.dart';
import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/models/provider_model/provider_model.dart';

class UserHelper {
  static UserType? getUserType() {
    var stringType = CacheHelper.getData(key: 'type');

    if (stringType == UserType.delivery_man.name) {
      return UserType.delivery_man;
    } else if (stringType == UserType.provider.name) {
      return UserType.provider;
    } else if (stringType == UserType.quality_manager.name) {
      return UserType.quality_manager;
    } else {
      return null;
    }
  }

  static String? getUserToken() {
    return CacheHelper.getData(key: 'token');
  }

// Save the Assistant entity to shared preferences
  static Future<void> saveProviderEntity(ProviderModel? model) async {
    var userJson = model?.toJson(); // Convert the Assistant object to JSON
    var decodedModel =
        jsonEncode(userJson); // Encode the JSON model to a string
    await CacheHelper.saveData(
        key: CachConstants.providerEntity,
        value: decodedModel); // Store in shared preferences
  }

  // Retrieve the related Doctor entity to Assistant from shared preferences
  static ProviderModel? getProviderEntity() {
    String? userString = CacheHelper.getData(
        key: CachConstants.providerEntity); // Get the stored string from prefs
    if (userString != null) {
      try {
        return ProviderModel.fromJson(json.decode(
            userString)); // Decode and convert the JSON string to an AssistantDoctor object
      } catch (e) {
        return null; // Return null if there is any error during parsing
      }
    }
    return null; // Return null if no data is found in preferences
  }

  // Save the Assistant entity to shared preferences
  static Future<void> saveProviderId(int? id) async {
    await CacheHelper.saveData(
        key: CachConstants.providerId,
        value: id); // Store in shared preferences
  }
}
