import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/fake_checkout_service.dart';

class PaymentButtonController extends StateNotifier<AsyncValue<void>> {
  PaymentButtonController({required this.checkoutService}) : super(const AsyncData(null));
  final FakeCheckoutService checkoutService;

  Future<void> pay() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(checkoutService.placeOrder);
  }
}

final paymentButtonControllerProvider = StateNotifierProvider.autoDispose<PaymentButtonController, AsyncValue<void>>((ref) {
  return PaymentButtonController(checkoutService: ref.watch(checkoutServiceProvider));
});
