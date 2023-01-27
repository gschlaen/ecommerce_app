import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'app_exception.dart';
import 'error_logger.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controllers in the app
class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final errorLogger = container.read(errorLoggerProvider);
    final error = _findError(newValue);
    if (error != null) {
      if (error.error is AppException) {
        // onnly prints the AppException data
        errorLogger.logAppException(error.error as AppException);
      } else {
        // prints everything including the stack trace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }
}

AsyncError<dynamic>? _findError(Object? value) {
  if (value is EmailPasswordSignInState && value.value is AsyncError) {
    return value.value as AsyncError;
  } else if (value is AsyncError) {
    return value;
  } else {
    return null;
  }
}
