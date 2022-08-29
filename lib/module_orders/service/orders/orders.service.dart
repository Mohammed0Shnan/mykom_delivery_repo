

import 'dart:ui';

import 'package:my_kom_delivery/consts/order_status.dart';
import 'package:my_kom_delivery/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom_delivery/module_orders/model/order_model.dart';
import 'package:my_kom_delivery/module_orders/repository/order_repository/order_repository.dart';
import 'package:my_kom_delivery/module_orders/response/order_details/order_details_response.dart';
import 'package:my_kom_delivery/module_orders/response/orders_zone_response.dart';
import 'package:rxdart/rxdart.dart';

class OrdersService {
  final  OrderRepository _orderRepository = OrderRepository();
  final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();

  final PublishSubject<Map<String,List<OrderModel>>?> orderPublishSubject =
  new PublishSubject();

  final PublishSubject<Map<String,List<OrderModel>>?> zoneOrderPublishSubject =
  new PublishSubject();







  Future<OrderModel?> getOrderDetails(String orderId) async {
    try{
    OrderDetailResponse? response =   await _orderRepository.getOrderDetails(orderId);

    if(response ==null)
      return null;
    OrderModel orderModel = OrderModel() ;
     orderModel.id = response.id;
    orderModel.products = response.products;
    orderModel.payment = response.payment;
    orderModel.orderValue = response.orderValue;
    orderModel.description = response.description;
    orderModel.addressName = response.addressName;
    orderModel.destination = response.destination;
    orderModel.phone = response.phone;
    orderModel.startDate = DateTime.parse(response.startDate) ;
    orderModel.numberOfMonth = response.numberOfMonth;
    orderModel.deliveryTime = response.deliveryTime;
    orderModel.cardId = response.cardId;
    orderModel.status = response.status;
    orderModel.customerOrderID = response.customerOrderID;
    orderModel.productIds = response.products_ides;
    orderModel.note = response.note;
    orderModel.vip_order = response.vip_order;
    return orderModel;
    }catch(e){
      return null;
    }
  }



  closeStream(){
    orderPublishSubject.close();
  }

  Future<bool> deleteOrder(String orderId)async{
      bool response = await  _orderRepository.deleteOrder(orderId);
      if(response){
        return true;
      }else{
        return false;
      }
  }

Future<void> getOwnerOrders() async {

    String? storeId = await _authPrefsHelper.getStoreId();
  _orderRepository.getOwnerOrders(storeId!).listen((event)async {
    final Map<String, List<OrderModel>> sortedOrdersList = <String, List<OrderModel>>{};
    event.docs.forEach((elementforsort) {
      Map <String ,dynamic> snapData = elementforsort.data() as Map<String , dynamic>;
      snapData['id'] = elementforsort.id;
      String key = snapData['order_source'];
      OrderModel orderModel = OrderModel.mainDetailsFromJson(snapData);
      if(!sortedOrdersList.containsKey(key)){
        sortedOrdersList[key] = [orderModel];
      }else {
        sortedOrdersList[key]?.add(orderModel);
      }

    });


    orderPublishSubject.add(sortedOrdersList);

  }).onError((e){
    orderPublishSubject.add(null);
  });

}

  Future<void> getZoneOrders(String zone) async {
    _orderRepository.getZoneOrders(zone).listen((event)async {
      final List<OrderModel> cur = [];
      final List<OrderModel> pre = [];
      event.docs.forEach((elementforsort) {
        Map <String ,dynamic> snapData = elementforsort.data() as Map<String , dynamic>;
        snapData['id'] = elementforsort.id;
        OrderModel orderModel = OrderModel.mainDetailsFromJson(snapData);
        if(orderModel.status == OrderStatus.FINISHED){
          pre.add(orderModel);
        }else {
          cur.add(orderModel);
        }

      });
      for(int i=0; i< cur.length;i++){
        OrderModel? res = await getOrderDetails(cur[i].id);
        cur[i].destination = res!.destination;
      }
      final Map<String, List<OrderModel>> sortedOrdersList = <String, List<OrderModel>>{};
      sortedOrdersList.addAll({'curr':cur});
      sortedOrdersList.addAll({'pre':pre});
      zoneOrderPublishSubject.add(sortedOrdersList);

    }).onError((e){
      orderPublishSubject.add(null);
    });

  }




}

