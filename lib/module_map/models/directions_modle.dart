import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions{
 late bool isNull;
 late final LatLngBounds bounds;
 late final List<PointLatLng> polyLine;
 Directions({required this.bounds , required this.polyLine, required this.isNull});
 factory Directions.fromJson(Map<String , dynamic> map){

 final  data = Map<String ,dynamic>.from(map['routes'][0]);
 final northeast  = data ['bounds']['northeast'];
 final southwest =   data ['bounds']['southwest'];
 final bounds = LatLngBounds(northeast: LatLng(northeast['lat'],northeast['lng']), southwest: LatLng(southwest['lat'],southwest['lng']));
 return Directions(bounds: bounds,polyLine: PolylinePoints().decodePolyline(data['overview_polyline']['points']),isNull: false);

 }


}

class LocationInformation{
  late String? title;
  late String? subTitle;
  LocationInformation();
}