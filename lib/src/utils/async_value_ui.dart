import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_widgets/alert_dialogs.dart';
import '../localization/string_hardcoded.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: error,
      );
    }
  }
}
