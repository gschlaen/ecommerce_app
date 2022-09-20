import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/in_memory_store.dart';
import '../domain/app_user.dart';

class FakeAuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWhithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Connection failed');
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Connection failed');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
