import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:z_delivery_man/core/global_cubit/global_state.dart';
import 'package:z_delivery_man/core/global_repo/update_location_repo.dart';
import 'package:z_delivery_man/core/location_services/location_service.dart';

class GlobalCubit extends Cubit<UpdateCurrentLocationStates> {
  GlobalCubit() : super(UpdateCurrentLocationInitialState()) {
    // startUpdateLocation();
  }

  updateCurrentLocation(BuildContext ctx) async {
    emit(UpdateCurrentLocationLoadingState());
    Position? position = await LocationService().getCurrentLocation(ctx);
    final lat = position?.latitude;
    final long = position?.longitude;
UpdateLocationRepo.updateLocation(position);
    // add logic here
    debugPrint('Lat : $lat');
    debugPrint('Long : $long');
  }

  Timer? _timer;
  // / Method to start update location every 10 seconds
  void startUpdateLocation(BuildContext ctx) {
    debugPrint('startUpdateLocation');
    _timer?.cancel();

    // Update location immediately the first time
    updateCurrentLocation(ctx);

    // Then start update location periodically every 20 seconds
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      updateCurrentLocation(ctx);
    });
  }
}
