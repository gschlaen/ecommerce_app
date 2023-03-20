import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/fake_auth_repository.dart';
import 'email_password_sign_in_form_type.dart';

part 'email_password_sign_in_controller.g.dart';

@riverpod
class EmailPasswordSignInController extends _$EmailPasswordSignInController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<bool> submit({required String email, required String password, required EmailPasswordSignInFormType formType}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authenticate(email, password, formType));
    return state.hasError == false;
  }

  Future<void> _authenticate(String email, String password, EmailPasswordSignInFormType formType) {
    final authRepository = ref.read(authRepositoryProvider);
    switch (formType) {
      case EmailPasswordSignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
    }
  }
}

// class EmailPasswordSignInController extends StateNotifier<AsyncValue<void>> {
//   EmailPasswordSignInController(this.ref) : super(const AsyncData<void>(null));
//   final Ref ref;

//   Future<bool> submit({required String email, required String password, required EmailPasswordSignInFormType formType}) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() => _authenticate(email, password, formType));
//     return state.hasError == false;
//   }

//   Future<void> _authenticate(String email, String password, EmailPasswordSignInFormType formType) {
//     final authRepository = ref.read(authRepositoryProvider);
//     switch (formType) {
//       case EmailPasswordSignInFormType.signIn:
//         return authRepository.signInWithEmailAndPassword(email, password);
//       case EmailPasswordSignInFormType.register:
//         return authRepository.createUserWithEmailAndPassword(email, password);
//     }
//   }
// }

// final emailPasswordSignInControllerProvider =
//     StateNotifierProvider.autoDispose<EmailPasswordSignInController, AsyncValue<void>>((ref) {
//   return EmailPasswordSignInController(ref);
// });
