import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/primary_button.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../utils/async_value_ui.dart';
import 'payment_button_controller.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends ConsumerWidget {
  const PaymentButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      paymentButtonControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(paymentButtonControllerProvider);

    return PrimaryButton(
      text: 'Pay'.hardcoded,
      isLoading: state.isLoading,
      onPressed: state.isLoading ? null : () => ref.read(paymentButtonControllerProvider.notifier).pay(),
    );
  }
}
