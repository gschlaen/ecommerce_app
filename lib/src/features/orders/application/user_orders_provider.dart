import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/data/fake_auth_repository.dart';
import '../../products/domain/product.dart';
import '../data/fake_orders_repository.dart';
import '../domain/order.dart';

part 'user_orders_provider.g.dart';

/// Watch the list of user orders
/// NOTE: Only watch this provider if the user is signed in.
@riverpod
Stream<List<Order>> userOrders(UserOrdersRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(ordersRepositoryProvider).watchUserOrders(user.uid);
  } else {
    // If the user is null, return an empty list (no orders)
    return Stream.value([]);
  }
}

/// Check if a product was previously purchased by the user
@riverpod
Stream<List<Order>> matchingUserOrders(
    MatchingUserOrdersRef ref, ProductID id) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(ordersRepositoryProvider)
        .watchUserOrders(user.uid, productId: id);
  } else {
    // If the user is null, return an empty list (no orders)
    return Stream.value([]);
  }
}
