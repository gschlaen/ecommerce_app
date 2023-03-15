import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_text_button.dart';
import '../../../../common_widgets/responsive_two_column_layout.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/date_formatter.dart';
import '../../../orders/application/user_orders_provider.dart';
import '../../domain/product.dart';

/// Simple widget to show the product purchase date along with a button to
/// leave a review.
class LeaveReviewAction extends ConsumerWidget {
  const LeaveReviewAction({super.key, required this.productId});
  final ProductID productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(matchingUserOrdersProvider(productId)).value;
    if (orders != null && orders.isNotEmpty) {
      final dateFormatted = ref.watch(dateFormatterProvider).format(orders.first.orderDate);
      return Column(
        children: [
          const Divider(),
          gapH8,
          ResponsiveTwoColumnLayout(
            spacing: Sizes.p16,
            breakpoint: 300,
            startFlex: 3,
            endFlex: 2,
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            startContent: Text('Purchased on $dateFormatted'.hardcoded),
            endContent: Consumer(
              builder: (context, ref, child) {
                final reviewValue = ref.watch(userReviewStreamProvider(productId));
                return CustomTextButton(
                  text: (reviewValue.value != null ? 'Update review' : 'Leave a review'.hardcoded),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.green[700]),
                  onPressed: () => context.goNamed(
                    AppRoute.leaveReview.name,
                    params: {'id': productId},
                  ),
                );
              },
            ),
          ),
          gapH8,
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
