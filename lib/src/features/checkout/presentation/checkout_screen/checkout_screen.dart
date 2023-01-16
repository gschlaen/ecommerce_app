// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../../localization/string_hardcoded.dart';
import '../../../authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import '../../../authentication/presentation/sign_in/email_password_sign_in_state.dart';
import '../payment/payment_page.dart';

/// The two sub-routes that are presented as part of the checkout flow.
enum CheckoutSubRoute { register, payment }

/// This is the root widget of the checkout flow, which is composed of 2 pages:
/// 1. Register page
/// 2. Payment page
/// The correct page is displayed (and updated) based on whether the user is
/// signed in.
/// The logic for the entire flow is implemented in the
/// [CheckoutScreenController], while UI updates are handled by a
/// [PageController].
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _controller = PageController();

  var _subRoute = CheckoutSubRoute.register;

  void _onSignedIn() {
    setState(() => _subRoute = CheckoutSubRoute.payment);
    // perform a nice scroll animation to reveal the next page
    _controller.animateToPage(
      _subRoute.index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // map subRoute to address
    final title = _subRoute == CheckoutSubRoute.register ? 'Register'.hardcoded : 'Payment'.hardcoded;
    // * Return a Scaffold with a PageView containing the 2 pages.
    // * This allows for a nice scroll animation when switching between pages.
    // * Note: only the currently active page will be visible.
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PageView(
        // * disable swiping between pages
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          EmailPasswordSignInContents(
            formType: EmailPasswordSignInFormType.register,
            onSignedIn: _onSignedIn,
          ),
          const PaymentPage()
        ],
      ),
    );
  }
}
