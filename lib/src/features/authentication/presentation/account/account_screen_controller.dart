import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController({required this.authRepository}) : super(const AsyncValue.data(null));

  final FakeAuthRepository authRepository;

  Future<void> signOut() async {
    // try {
    //   state = const AsyncValue.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue.data(null);
    //   return true;
    // } catch (e) {
    //   state = AsyncValue.error(e);
    //   return false;
    // }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});
