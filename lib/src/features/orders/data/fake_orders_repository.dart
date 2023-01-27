import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/delay.dart';
import '../../../utils/in_memory_store.dart';
import '../domain/order.dart';

class FakeOrdersRepository {
  FakeOrdersRepository({this.addDelay = true});
  final bool addDelay;

  /// A map of all the orders placed by each user, where:
  /// - key: user ID
  /// - value: list of orders for that user
  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  // A stream that returns all the orders for a given user, ordered by date
  Stream<List<Order>> watchUserOrders(String uid) {
    return _orders.stream.map((ordersData) {
      final ordersList = ordersData[uid] ?? [];
      ordersList.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return ordersList;
    });
  }

  // A method to add a new order to the list for a given user
  Future<void> addOrder(String uid, Order order) async {
    await delay(addDelay);
    final value = _orders.value;
    final userOrders = value[uid] ?? [];
    userOrders.add(order);
    value[uid] = userOrders;
    _orders.value = value;
  }
}

final ordersRepositoryProvider = Provider<FakeOrdersRepository>((ref) {
  return FakeOrdersRepository();
});