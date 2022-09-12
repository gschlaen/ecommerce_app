import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/account/account_screen.dart';
import '../features/checkout/checkout_screen.dart';
import '../features/leave_review_page/leave_review_screen.dart';
import '../features/not_found/not_found_screen.dart';
import '../features/orders_list/orders_list_screen.dart';
import '../features/product_page/product_screen.dart';
import '../features/products_list/products_list_screen.dart';
import '../features/shopping_cart/shopping_cart_screen.dart';
import '../features/sign_in/email_password_sign_in_screen.dart';
import '../features/sign_in/email_password_sign_in_state.dart';

enum AppRout {
  home,
  product,
  leaveReview,
  cart,
  checkout,
  orders,
  account,
  signIn,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRout.home.name,
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
            path: 'product/:id',
            name: AppRout.product.name,
            builder: (context, state) {
              final productId = state.params['id']!;
              return ProductScreen(productId: productId);
            },
            routes: [
              GoRoute(
                  path: 'review',
                  name: AppRout.leaveReview.name,
                  pageBuilder: (context, state) {
                    final productId = state.params['id']!;
                    return MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: LeaveReviewScreen(productId: productId),
                    );
                  }),
            ]),
        GoRoute(
            path: 'cart',
            name: AppRout.cart.name,
            pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const ShoppingCartScreen(),
                ),
            routes: [
              GoRoute(
                path: 'checkout',
                name: AppRout.checkout.name,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const CheckoutScreen(),
                ),
              ),
            ]),
        GoRoute(
          path: 'orders',
          name: AppRout.orders.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const OrdersListScreen(),
          ),
        ),
        GoRoute(
          path: 'account',
          name: AppRout.account.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const AccountScreen(),
          ),
        ),
        GoRoute(
          path: 'signIn',
          name: AppRout.signIn.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
