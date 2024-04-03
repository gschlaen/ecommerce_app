// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../localization/string_hardcoded.dart';
import '../../../authentication/domain/app_user.dart';
import '../../../../routing/app_router.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({super.key, this.user});
  final AppUser? user;

  static const signInKey = Key('menuSignIn');
  static const ordersKey = Key('menuOrders');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: ordersKey,
                  child: Text('Orders'.hardcoded),
                  value: PopupMenuOption.orders,
                ),
                PopupMenuItem(
                  key: accountKey,
                  child: Text('Account'.hardcoded),
                  value: PopupMenuOption.account,
                ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: signInKey,
                  child: Text('Sign In'.hardcoded),
                  value: PopupMenuOption.signIn,
                ),
              ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.signIn:
            context.goNamed(AppRoute.signIn.name);
            break;
          case PopupMenuOption.orders:
            context.goNamed(AppRoute.orders.name);
            break;
          case PopupMenuOption.account:
            context.goNamed(AppRoute.account.name);
            break;
        }
      },
    );
  }
}
