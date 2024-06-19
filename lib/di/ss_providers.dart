import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_test/data/database/orders_db.dart';
import 'package:pos_test/data/enums.dart';
import 'package:pos_test/data/repository/order_repository.dart';
import 'package:pos_test/presenter/viewmodels/scan_order_viewmodel.dart';

final scanStateOrderProvider = StateProvider<ScanState>((ref) {
  return ScanState.ORDER;
});

final orderDBProvider = Provider((ref) {
  return OrdersDb();
});

final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  final orderDb = ref.watch(orderDBProvider);
  return OrderRepository(orderDb);
});

final scanOrderViewModelProvider = ChangeNotifierProvider((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return ScanOrderViewmodel(orderRepository);
});
