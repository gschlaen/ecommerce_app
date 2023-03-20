import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/fake_auth_repository.dart';

part 'account_screen_controller.g.dart';

@riverpod
class AccountScreenController extends _$AccountScreenController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

// final accountScreenControllerProvider =
//     AutoDisposeAsyncNotifierProvider<AccountScreenController, void>(AccountScreenController.new);

// class AccountScreenController extends StateNotifier<AsyncValue<void>> {
//   AccountScreenController({required this.authRepository}) : super(const AsyncData(null));

//   final FakeAuthRepository authRepository;

//   Future<void> signOut() async {
//     // try {
//     //   state = const AsyncValue.loading();
//     //   await authRepository.signOut();
//     //   state = const AsyncValue.data(null);
//     //   return true;
//     // } catch (e, st) {
//     //   state = AsyncValue.error(e, st);
//     //   return false;
//     // }
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(() => authRepository.signOut());
//   }
// }

// final accountScreenControllerProvider = StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue<void>>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return AccountScreenController(authRepository: authRepository);
// });
