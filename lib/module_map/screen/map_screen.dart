import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/consts/order_status.dart';
import 'package:my_kom_delivery/module_authorization/authorization_routes.dart';
import 'package:my_kom_delivery/module_map/bloc/map_bloc.dart';
import 'package:my_kom_delivery/module_map/models/directions_modle.dart';
import 'package:my_kom_delivery/module_orders/model/order_model.dart';
import 'package:my_kom_delivery/module_orders/orders_routes.dart';
import 'package:my_kom_delivery/utils/size_configration/size_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final List<OrderModel> orders;
   MapWidget({ required this.orders, Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

const kGoogleApiKey = 'AIzaSyD2mHkT8_abpMD9LJl307Qhk7GHWuKqMJw';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _MapWidgetState extends State<MapWidget> {
  late final MapBloc mapBloc ;
   late GoogleMapController _controller ;

  final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(25.21531756196482, 56.31557364016771), zoom: 11);
  late final TextEditingController _searchController;

  Marker? _origin = null;

  @override
  void initState() {
   _origin = Marker(markerId: MarkerId('Origin'),infoWindow: InfoWindow(title:'My location'),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen,
       ),
       position: LatLng(25.21531756196482, 56.31557364016771)
   );
   _markers.add(_origin!);
    mapBloc = MapBloc();
    widget.orders.forEach((element) {
      LatLng latLng = LatLng( element.destination.lat,  element.destination.lon);
    Marker _m =  Marker(markerId: MarkerId(element.customerOrderID.toString()),infoWindow: InfoWindow(title:'Order Number : '+element.customerOrderID.toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(element.vip_order?BitmapDescriptor.hueYellow: BitmapDescriptor.hueRed,
          ),
          onTap: (){

            _alertWidget(context,element.id,element.customerOrderID.toString(),element.vip_order);
          },
          position: latLng
      );
      ////
      _markers.add(_m);
    });
    setState((){});
    super.initState();
    _searchController = TextEditingController(text: '');
   // mapBloc.getCurrentPosition();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  final Set<Marker> _markers = Set<Marker>();
 // late GoogleMapController googleMapController;
  Map<String, dynamic>? location_from_search = null;
  final Mode _mode = Mode.overlay;
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   register = ModalRoute.of(context)!.settings.arguments as bool;
    //   setState((){});
    // });
    return BlocConsumer<MapBloc, MapStates>(
      bloc: mapBloc,
      listener: (context, state) async {
        if (state is MapSuccessState) {
          setState((){});
          LatLng latLng = LatLng(state.data.latitude, state.data.longitude);
          _move(latLng);

        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  height:MediaQuery.of(context).size.height,
                  width: SizeConfig.screenWidth,
                  child: GoogleMap(
                    onTap: (v) {
                      print(v);
                      LatLng latLng = LatLng(v.latitude, v.longitude);
                      print(latLng);
                    },

                    markers: _markers,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    zoomControlsEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller =controller;
                    },

                  ),
                ),
                // if (state is MapLoadingState)
                //   Positioned.fill(
                //     child: Container(
                //       child: Center(
                //         child: CircularProgressIndicator(
                //           color: ColorsConst.mainColor,
                //         ),
                //       ),
                //     ),
                //   ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),

                    decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(10)),
                    child:    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Container(
                              margin: EdgeInsets.only(right: 8),
                              height: 20,width: 20,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green),),Text('My Location',style: TextStyle(fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                        SizedBox(width: 8,),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [ Container(height: 20,width: 20,margin: EdgeInsets.only(right: 8),decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red),),
                              Text('Orders',style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        SizedBox(width: 8,),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [ Container(height: 20,width: 20,margin: EdgeInsets.only(right: 8),decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.yellow),),
                              Text('Quick',style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child:   GestureDetector(
                      onTap: (){
                        mapBloc.getCurrentPosition();

                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle
                        ),
                        child: Icon(Icons.my_location, color: Colors.white,)
                      ),
                    ),),

              ],
            ),
          ),
        );
      },
    );
  }

  getDetailFromLocation(LatLng latLng) async {

    Marker marker = Marker(
        markerId: MarkerId('_current_position'),
        infoWindow: InfoWindow(
          title: '1',
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: latLng);
    _searchController.text = "${''}";
    _setMarker(marker);
  }

  Future<void> _move(LatLng latLng) async {
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 11.0);
    final GoogleMapController controller = _controller; // await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    
    _setMarker(Marker(markerId: MarkerId('origin'),infoWindow: InfoWindow(title:'my location'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen,

    ),
      position: latLng
    ));
  }

  _setMarker(Marker marker) {

    _markers.add(marker);
    setState(() {});
  }

Future<Directions?> _getDirection(Marker origin , Marker destination)async{
  Directions? direction = await mapBloc.service.getDirection(origin: origin.position, destination: destination.position);
    return direction;
  }

  _alertWidget(context,String orderId,String customerNum , bool vip){
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      content: Container(
        height: 200,
        width:100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30 ,
              height: 30 ,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100
              ),
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.clear,color: Colors.black,)),
            ),
            SizedBox(height: 20,),
            if(vip)
            Center(child: Text('Express MyKom Order :' + customerNum , style: TextStyle(fontWeight: FontWeight.w600, color: ColorsConst.mainColor),),),
            if(!vip)
            SizedBox(height: 8,),
            if(!vip)
            Center(child: Text('Order Number :' + customerNum , style: TextStyle(fontWeight: FontWeight.w600, color: ColorsConst.mainColor),),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,

              child: Text('Click on the button to go to the order processing page',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black54),)
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 20),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: ColorsConst.mainColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamed(context, OrdersRoutes.ORDER_DETAIL_SCREEN, arguments:orderId);

                },
                child:Text('GO',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),

              ),
            ),
          ],
        ),
      ),

    );

// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
