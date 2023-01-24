import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/async_value_widget.dart';
import '../../../cart/application/cart_service.dart';
import '../../../cart/domain/cart.dart';
import '../../../cart/presentation/shopping_cart/shopping_cart_item.dart';
import '../../../cart/presentation/shopping_cart/shopping_cart_items_builder.dart';
import 'payment_button.dart';

/// Payment screen showing the items in the cart (with read-only quantities) and
/// a button to checkout.
class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<double>(cartTotalProvider, (_, cartTotal) {
      // If the cart total becames 0, it means that the order has been fulfilled
      // because all the items have been removed from the cart.
      // So we should go to the orders page.
      if (cartTotal == 0.0) {
        context.goNamed(AppRoute.orders.name);
      }
    });
    final cartValue = ref.watch(cartProvider);
    return AsyncValueWidget<Cart>(
      value: cartValue,
      data: (cart) {
        return ShoppingCartItemsBuilder(
          items: cart.toItemsList(),
          itemBuilder: (_, item, index) => ShoppingCartItem(
            item: item,
            itemIndex: index,
            isEditable: false,
          ),
          ctaBuilder: (_) => const PaymentButton(),
        );
      },
    );
  }
}
