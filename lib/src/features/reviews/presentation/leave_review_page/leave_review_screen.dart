import 'package:flutter/material.dart';

import '../../../../common_widgets/alert_dialogs.dart';
import '../../../../common_widgets/primary_button.dart';
import '../../../../common_widgets/responsive_center.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/breakpoints.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../domain/review.dart';
import '../product_reviews/product_rating_bar.dart';

class LeaveReviewScreen extends StatelessWidget {
  const LeaveReviewScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    // TODO: Read from data source
    const review = null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a review'.hardcoded),
      ),
      body: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(Sizes.p16),
        child: LeaveReviewForm(productId: productId, review: review),
      ),
    );
  }
}

class LeaveReviewForm extends StatefulWidget {
  const LeaveReviewForm({super.key, required this.productId, this.review});
  final String productId;
  final Review? review;

  static const reviewCommentKey = Key('reviewComment');

  @override
  State<LeaveReviewForm> createState() => _LeaveReviewFormState();
}

class _LeaveReviewFormState extends State<LeaveReviewForm> {
  final _controller = TextEditingController();

  double _rating = 0;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _controller.text = widget.review!.comment;
      _rating = widget.review!.score;
    }
  }

  Future<void> _submitReview() async {
    // only submit if new rating or different from before
    final previousReview = widget.review;
    if (previousReview == null || _rating != previousReview.score || _controller.text != previousReview.comment) {
      // TODO: Submit review
      showNotImplementedAlertDialog(context: context);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.review != null) ...[
          Text(
            'You reviewed this product before. You can edit your review.'.hardcoded,
            textAlign: TextAlign.center,
          ),
          gapH24,
        ],
        Center(
          child: ProductRatingBar(
            initialRating: _rating,
            onRatingUpdate: (rating) => setState(() => _rating = rating),
          ),
        ),
        gapH32,
        TextField(
          key: LeaveReviewForm.reviewCommentKey,
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Your review (optional)'.hardcoded,
            border: const OutlineInputBorder(),
          ),
        ),
        gapH32,
        PrimaryButton(
          text: 'Submit'.hardcoded,
          // TODO: Loading state
          isLoading: false,
          onPressed: _rating == 0 ? null : _submitReview,
        )
      ],
    );
  }
}
