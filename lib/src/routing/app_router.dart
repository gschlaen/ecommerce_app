import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/data/fake_auth_repository.dart';
import '../features/authentication/presentation/account/account_screen.dart';
import '../features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import '../features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import '../features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import '../features/checkout/presentation/checkout_screen/checkout_screen.dart';
import '../features/orders/presentation/orders_list/orders_list_screen.dart';
import '../features/products/presentation/product_screen/product_screen.dart';
import '../features/products/presentation/products_list/products_list_screen.dart';
import '../features/reviews/presentation/leave_review_page/leave_review_screen.dart';
import 'not_found_screen.dart';

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

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
        if (state.location == '/account' || state.location == '/orders') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
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
                    // Al agregar el refreshListenable, GoRouter redibuja otra
                    // vez la pantalla si cambia el key, como ocurre con state.pageKey
                    // por eso se usa ValueKey(state.location) que es siempre igual
                    key: ValueKey(state.location),
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
});
