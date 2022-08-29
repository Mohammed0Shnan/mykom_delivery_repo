import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom_delivery/consts/order_status.dart';
import 'package:my_kom_delivery/module_dashbord/models/product_model.dart';
import 'package:my_kom_delivery/module_orders/model/order_model.dart';
import 'package:my_kom_delivery/module_orders/request/accept_order_request/accept_order_request.dart';
import 'package:rxdart/rxdart.dart';

class DashBoardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PublishSubject<List<ProductModel>?> productCompanyStoresPublishSubject =
  new PublishSubject();

  Future<OrderStatus?> updateOrder(String orderId, OrderModel order) async {
    OrderStatus state;
    switch (order.status) {
      case OrderStatus.GOT_CAPTAIN:
        {
          state = OrderStatus.GOT_CAPTAIN;
        }
        break;
      case OrderStatus.IN_STORE:
        {
          state = OrderStatus.IN_STORE;
        }
        break;
      case OrderStatus.DELIVERING:
        {
          state = OrderStatus.DELIVERING;
        }
        break;
      case OrderStatus.GOT_CASH:
        {
          state = OrderStatus.GOT_CASH;
        }
        break;
      case OrderStatus.FINISHED:
        {
          state = OrderStatus.FINISHED;
        }
        break;
      default:
        return null;
    }
    try {
      updateOrderRequest request = updateOrderRequest(
          orderID: orderId, state: state.name);
      await _firestore.collection('orders').doc(orderId).update(
          request.toJson());
      //await _firestore.collection('orders').doc(orderId).collection('').update(request.toJson());
      return state;
    } catch (e) {
      return null;
    }
  }
}
