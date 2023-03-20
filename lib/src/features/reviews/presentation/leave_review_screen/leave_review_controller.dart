import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/current_date_provider.dart';
import '../../../products/domain/product.dart';
import '../../application/reviews_service.dart';
import '../../domain/review.dart';

part 'leave_review_controller.g.dart';

@riverpod
class LeaveReviewController extends _$LeaveReviewController {
  bool mounted = true;
  @override
  FutureOr build() {
    ref.onDispose(() => mounted = false);
  }

  Future<void> submitReview({
    Review? previousReview,
    required ProductID productId,
    required double rating,
    required String comment,
    required void Function() onSuccess,
  }) async {
    // * only submit if the review is new or it has changed
    if (previousReview == null || rating != previousReview.rating || comment != previousReview.comment) {
      final currentDateBuilder = ref.read(currentDateBuilderProvider);
      final reviewsService = ref.read(reviewsServiceProvider);
      final review = Review(
        rating: rating,
        comment: comment,
        date: currentDateBuilder(),
      );

      state = const AsyncLoading();
      final newState = await AsyncValue.guard(() => reviewsService.submitReview(productId: productId, review: review));
      if (mounted) {
        // * only set the state if the controller hasn´t been disposed
        state = newState;
        if (state.hasError == false) {
          onSuccess();
        }
      }
    } else {
      onSuccess();
    }
  }
}
