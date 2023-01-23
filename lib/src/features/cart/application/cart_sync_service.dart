import 'dart:math';

import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/data/fake_auth_repository.dart';
import '../../authentication/domain/app_user.dart';
import '../data/local/local_cart_repository.dart';
import '../data/remote/remote_cart_repository.dart';
import '../domain/cart.dart';
import '../domain/item.dart';
import '../domain/mutable_cart.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }
  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  /// moves all items from the local to the remote cart taking into account the
  /// available quantities
  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      // Get the local cart data
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();
      if (localCart.items.isNotEmpty) {
        // Get the remote cart data
        final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        final localItemsToAdd = await _getLocalItemsToAdd(localCart, remoteCart);
        // Add all the local items to the remote cart
        final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);
        // Write the updated remote cart data to the repositorie
        await remoteCartRepository.setCart(uid, updatedRemoteCart);
        // remove all items from the local cart
        await localCartRepository.setCart(const Cart());
      }
    } catch (e) {
      // TODO: Handle error and/or rethrow
    }
  }

  Future<List<Item>> _getLocalItemsToAdd(Cart localCart, Cart remoteCart) async {
    // Get the list of products (needed to read the available quantities)
    final productRepository = ref.read(productRepositoryProvider);
    final products = await productRepository.fetchProductsList();
    // Figure out which items need to be added
    final localItemsToAdd = <Item>[];
    for (final localItem in localCart.items.entries) {
      final productId = localItem.key;
      final localQuantity = localItem.value;
      // Get the quantity for the corresponding item in the remote cart
      final remoteQuantity = remoteCart.items[productId] ?? 0;
      // Get the corrresponding product to know de available quantity
      final product = products.firstWhere((product) => product.id == productId);
      // Cap the quantity of each item to the available quantity
      final cappedLocalQuantity = min(localQuantity, product.availableQuantity - remoteQuantity);
      // if the capped quantity is > 0, add to the list of items to add
      if (cappedLocalQuantity > 0) {
        localItemsToAdd.add(Item(productId: productId, quantity: cappedLocalQuantity));
      }
    }
    return localItemsToAdd;
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
