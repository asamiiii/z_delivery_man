import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:z_delivery_man/screens/pickup_details/pickup_details_states.dart';

import '../../models/order_per_time_slot_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/widgets/constants.dart';

class PickupDetailsCubit extends Cubit<PickupDetailsStates> {
  PickupDetailsCubit() : super(PickupDetailsInitialState());

  static PickupDetailsCubit get(context) => BlocProvider.of(context);

  List? ordersPerTimeSlots = [];
  Marker? marker;
  Circle? circle;
  Location? locationTracker = Location();
  BitmapDescriptor? customMarker;
  GoogleMapController? googleMapController;
  Map<OrdersPerTimeSlotModel, double>? ordersWithDistance = {};
  var markers = HashSet<Marker>(); // collection of markers

  static LatLng? target;

  StreamSubscription? _locationSubscription;

  Future<void> getOrdersPerTimeSlot({required int? id}) {
    emit(PickupDetailsLoadingState());
    return DioHelper.getData(url: "${EndPoints.GET_ORDERS_PER_TIMESLOT}/$id", token: token)
        .then((value) {
      ordersPerTimeSlots = [];
      ordersPerTimeSlots = orederPerTimeSlotsFromJson(value.data);
      print(ordersPerTimeSlots);
      // addOrdersMarkers();
      calculateDistanceOfOrderes();

      emit(PickupDetailsSuccessState());
    }).catchError((e) {
      print(e);
      emit(PickupDetailsFailedState());
    });
  }

  LocationData? location;
  // get current location
  void getCurrntLocation(BuildContext context) async {
    try {
      Uint8List imageData = await getMarker(context);
      location = await locationTracker!.getLocation();

      print(location.toString() + 'this is location');
      updateMarkerAndCircle(location!, imageData);

      if (_locationSubscription != null) {
        _locationSubscription?.cancel();
      }

      _locationSubscription =
          locationTracker!.onLocationChanged.listen((newLocalData) {
        if (googleMapController != null) {
          googleMapController
              ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(newLocalData.latitude!, newLocalData.longitude!),

            zoom: 15,
            // tilt: 0,
            // bearing: 192.8334901395799,
          )));
          updateMarkerAndCircle(newLocalData, imageData);
          emit(PickupDetailsGetCurrentLocationSuccessState());
        }
      });

      emit(PickupDetailsGetCurrentLocationSuccessState());
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION DENIED') {
        debugPrint('Permission denied');
      }
    }
  }

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/images/car.png');
    emit(PickupDetailsGetMarkerSuccessState());
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocation, Uint8List imageData) {
    LatLng latLng =
        LatLng(newLocation.latitude ?? 0, newLocation.longitude ?? 0);

    marker = Marker(
        markerId: const MarkerId('home'),
        position: latLng,
        rotation: newLocation.heading ?? 0,
        draggable: true,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    circle = Circle(
        circleId: const CircleId('car'),
        radius: newLocation.accuracy!,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latLng,
        fillColor: Colors.blue.withAlpha(70));
    emit(PickupDetailsUpdateMarkerAndCircleSuccessState());
  }

  LinkedHashMap? sortedMap;
  void calculateDistanceOfOrderes() {
    // double distenceInMeters = geolocator.Geolocator.distanceBetween(
    //     startLat, startLong, endLat, endLong);
    // return distenceInMeters;
    sortedMap = null;
    for (var order in ordersPerTimeSlots!) {
      double newDistance = geolocator.Geolocator.distanceBetween(
          location?.latitude ?? 0,
          location?.longitude ?? 0,
          order.address.lat,
          order.address.long);
      ordersWithDistance![order] = newDistance;
      emit(PickupDetailsCalculateDistanceOfOrderesSuccessState());
    }
    print("$ordersWithDistance this is orders with distance");

    var sortedKeys = ordersWithDistance?.keys.toList(growable: false)
      ?..sort((k1, k2) =>
          ordersWithDistance![k1]!.compareTo(ordersWithDistance![k2]!));
    sortedMap = LinkedHashMap.fromIterable(sortedKeys!,
        key: (k) => k, value: (k) => ordersWithDistance![k]);
    print("$sortedMap this is sorted map");
  }

  final CameraPosition initialLocation = CameraPosition(
      target: target ?? const LatLng(30.055103, 30.989166), zoom: 13);

  Future<geolocator.Position> allowAccessLocation() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();

    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission != geolocator.LocationPermission.whileInUse &&
          permission != geolocator.LocationPermission.always) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await geolocator.Geolocator.openAppSettings();
        await geolocator.Geolocator.openLocationSettings();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );

    // set state hete
    target = LatLng(position.latitude, position.longitude);
    googleMapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 18));

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await geolocator.Geolocator.getCurrentPosition();
  }

  void addOrdersMarkers() {
    for (var order in ordersPerTimeSlots!) {
      markers.add(Marker(
          markerId: MarkerId(order.id.toString()),
          position: LatLng(order.address.lat, order.address.long),
          icon: BitmapDescriptor.defaultMarker));
    }
    emit(PickupDetailsAddMarkerForOrdersSuccessState());
  }

  void goToNextStatus(
      {required int? orderId,
      int? itemCount,
      String? comment,
      required bool isDeliveryMan}) {
    emit(PickupDetailsNextStatusLoadingState());
    DioHelper.postData(
        url: isDeliveryMan
            ? "${EndPoints.POST_ORDERS_NEXT_STATUS}/$orderId/nextStatus"
            : "${EndPoints.POST_ORDERS_NEXT_STATUS_PROVIDER}/$orderId/nextStatus",
        token: token,
        data: {"item_count": itemCount, "comment": comment}).then((value) {
      emit(PickupDetailsNextStatusSuccessState());
    }).catchError((e) {
      print("$e error of next status");
      emit(PickupDetailsNextStatusFailedState());
    });
  }

  void collectOrder({
    required int? orderId,
    required String? collectMethod,
  }) {
    emit(PickupDetailsCollectOrderStatusLoadingState());
    DioHelper.postData(
        url: '${EndPoints.POST_COLLECT_ORDER}/$orderId/collect',
        token: token,
        data: {'collect_method': collectMethod}).then((value) {
      emit(PickupDetailsCollectOrderStatusSuccessState());
    }).catchError((e) {
      print('$e collect error');
      emit(PickupDetailsCollectOrderStatusFailedState());
    });
  }
}
