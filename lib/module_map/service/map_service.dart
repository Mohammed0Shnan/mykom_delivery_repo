import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom_delivery/module_map/bloc/map_bloc.dart';
import 'package:my_kom_delivery/module_map/models/directions_modle.dart';
import 'package:my_kom_delivery/module_map/screen/map_screen.dart';
import 'package:my_kom_delivery/module_persistence/sharedpref/shared_preferences_helper.dart';



class MapService {
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferencesHelper _preferencesHelper =SharedPreferencesHelper();

  Future<Directions?> getDirection({required LatLng origin , required LatLng destination})async{
    final response  = await Dio().get('https://maps.googleaps.com/maps/api/directions/json?',
    queryParameters: {
      'origin':'${origin.latitude},${origin.longitude}',
      'destination':'${destination.latitude},${destination.longitude}',
      kGoogleApiKey:'AIzaSyD2mHkT8_abpMD9LJl307Qhk7GHWuKqMJw'
    }
    );
    if(response.statusCode == 200){
      return Directions.fromJson(response.data);
    }
    else return null;
  }

  Future<MapData> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Future.error('Location services are disabled');
        throw('Location services are disabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Future.error('Location permissions are denied');
          throw('Location permissions are denied');

        }
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        throw( 'Location permissions are permanently denied, we cannot request permissions.');

      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);


      return MapData(name: "${'my location'} ${''}",
          longitude: position.longitude,
          latitude: position.latitude,
          isError: false,
          message: 'success'
      );

    }catch(e){
      return MapData.error(e.toString());
    }


  }


}
