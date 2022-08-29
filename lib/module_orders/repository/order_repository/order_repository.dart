

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom_delivery/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom_delivery/module_orders/request/accept_order_request/accept_order_request.dart';
import 'package:my_kom_delivery/module_orders/request/order/order_request.dart';
import 'package:my_kom_delivery/module_orders/response/order_details/order_details_response.dart';
import 'package:my_kom_delivery/module_orders/response/order_status/order_status_response.dart';
import 'package:simple_animations/simple_animations.dart';

class OrderRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  // OrderRepository(
  //   this._apiClient,
  //   this._authService,
  // );


  Future<OrderDetailResponse?> getOrderDetails(String orderId) async {
    try{
      String status = '';
     status = await _firestore.collection('orders').doc(orderId).get().then((value) {
         Map<String, dynamic> r = value.data() as  Map<String, dynamic> ;
      return  r['status'];
      });
       return await _firestore.collection('orders').doc(orderId).collection('details').get().then((value) {
         Map <String ,dynamic> result = value.docs[0].data() ;
         result['id'] = orderId;
         result['status'] = status;
         OrderDetailResponse r =   OrderDetailResponse.fromJson(result) ;
         return r;
   });

    }catch(e){
      print(e);
      throw Exception('Error in get order detail  !');
    }
  }




  Stream<QuerySnapshot> getMyOrders(String uid)  {

    try{
      return   _firestore.collection('orders').where('userId',isEqualTo: uid).orderBy('customer_order_id').snapshots();
    }catch(e){
      print(e);
      throw Exception('Error in get my order !');
    }
  }

  Stream<QuerySnapshot> getNotifications(String uid)  {

    try{
      return   _firestore.collection('offers').snapshots();
    }catch(e){
      throw Exception('Error in get notifications !');
    }
  }
  
 Future<bool> deleteOrder(String orderId)async {
    print('delete order by order id: ${orderId}');
    try{
      await _firestore.collection('orders').doc(orderId).delete();
     //  await Future.wait([
     //    //_firestore.collection('orders').doc(orderId).collection('details').

 //  ]);
      return true;
    }catch(e){
      print('tag : repository , message : Error in deleted !!! ');
      return false;
    }
 }

  Future<OrderStatusResponse?> updateOrder(updateOrderRequest request) async{
    try{
       await _firestore.collection('orders').doc(request.orderID).update(request.toJson()).then((value) {
       });

  }catch(e){
  print(e);
  throw Exception('Error in update data !');
  }
  }

  // Future<int> getOrdersSize() async{
  //   try{
  //     int size = 0;
  //   var list = await  _firestore.collection('orders').snapshots().toList();
  //  return list.length;
  //
  //   }catch(e){
  //
  //     return 0;
  //   }
  // }

  Stream<QuerySnapshot> getOwnerOrders(String storeId) {
    try{
       return  _firestore.collection('orders').where('store_Id',isEqualTo: storeId).snapshots();

    }catch(e){
      throw Exception('Error in get data !');
    }
  }

  Stream<QuerySnapshot> getZoneOrders(String zoneName) {
    try{
      return  _firestore.collection('orders').where('order_source',isEqualTo: zoneName).orderBy('customer_order_id',descending: true).snapshots();

    }catch(e){
      throw Exception('Error in get data !');
    }
  }

 Future<int?> generateOrderID()async {
    try{

     Map<String , dynamic> map =  await _firestore.collection('utils').get().then((value) {
        return {'doc_id':value.docs[0].id,
        'order_id':value.docs[0].data()['customer_order_id']
        };
      });

       await _firestore.collection('utils').doc( map['doc_id']).update({
       'customer_order_id': map['order_id']+1
     });
       int id = map['order_id']+1;
       return id ;
    }catch(e){
      return null;
    }

 }

 Future getZoneNames(String zone_id)async {
   try{
     return  _firestore.collection('orders').doc(zone_id).get();

   }catch(e){
     throw Exception('Error in get data !');
   }
 }




  // Future<OrderDetailsResponse?> updateOrder(UpdateOrderRequest request) async {
  //   // var token = await _authService.getToken();
  //   // dynamic response = await _apiClient.put(
  //   //   '${Urls.CAPTAIN_ORDER_UPDATE_API}',
  //   //   request.toJson(),
  //   //   headers: {'Authorization': 'Bearer ' + token},
  //   // );
  //
  //   // if (response == null) return null;
  //
  //   // return OrderDetailsResponse.fromJson(response);
  //   return null;
  // }
}
