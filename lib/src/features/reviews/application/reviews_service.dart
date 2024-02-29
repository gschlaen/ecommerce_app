import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../localization/string_hardcoded.dart';
import '../../authentication/data/fake_auth_repository.dart';
import '../../products/data/fake_products_repository.dart';
import '../../products/domain/product.dart';
import '../data/fake_reviews_repository.dart';
import '../domain/review.dart';

part 'reviews_service.g.dart';

class ReviewsService {
  ReviewsService(this.ref);
  final Ref ref;

  Future<void> submitReview({
    required ProductID productId,
    required Review review,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    // * we should only call this method when the user is signed in
    assert(user != null);
    if (user == null) {
      throw AssertionError(
          'Can\'t submit a review if the user is not signed in'.hardcoded);
    }
    await ref.read(reviewsRepositoryProvider).setReview(
          productId: productId,
          uid: user.uid,
          review: review,
        );
    // * Note: this should be done on the backend
    // * At this stage the review is already submitted
    // * and we don't need to await for the product rating to also be updated
    _updateProductRating(productId);
  }

  Future<void> _updateProductRating(ProductID productId) async {
    final reviews =
        await ref.read(reviewsRepositoryProvider).fetchReviews(productId);
    final avgRating = _avgReviewScore(reviews);
    await ref.read(productsRepositoryProvider).updateProductRating(
          productId: productId,
          avgRating: avgRating,
          numRatings: reviews.length,
        );
  }

  double _avgReviewScore(List<Review> reviews) {
    if (reviews.isNotEmpty) {
      var total = 0.0;
      for (var review in reviews) {
        total += review.rating;
      }
      return total / reviews.length;
    } else {
      return 0.0;
    }
  }
}

@Riverpod(keepAlive: true)
ReviewsService reviewsService(ReviewsServiceRef ref) {
  return ReviewsService(ref);
}

/// Check if a product was previously reviewed by the user
@riverpod
Future<Review?> userReviewFuture(UserReviewFutureRef ref, ProductID productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(reviewsRepositoryProvider)
        .fetchUserReview(productId, user.uid);
  } else {
    return Future.value(null);
  }
}

/// Check if a product was previously reviewed by the user
@riverpod
Stream<Review?> userReviewStream(UserReviewStreamRef ref, ProductID id) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(reviewsRepositoryProvider).watchUserReview(id, user.uid);
  } else {
    return Stream.value(null);
  }
}
