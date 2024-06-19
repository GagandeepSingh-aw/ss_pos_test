import 'package:pos_test/data/database/orders_db.dart';

import '../models/order_model.dart';

abstract interface class IOrderRepository {
  List<Order> fetchAllOrders();

  Order? fetchOrderById(String orderId);
}

class OrderRepository implements IOrderRepository {
  final IOrdersDb _ordersDb;
  OrderRepository(this._ordersDb);

  @override
  List<Order> fetchAllOrders() {
    return _ordersDb.allOrders();
  }

  @override
  Order? fetchOrderById(String orderId) {
    return _ordersDb.orderById(orderId);
  }
}