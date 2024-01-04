import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pupmAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout succes', (tester) async {
    final r = AuthRobot(tester);
    await r.pupmAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectLogoutDialogNotFound();
    r.expectErrorAlertNotFound();
  });

  testWidgets('Confirm logout failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection Failure');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await r.pupmAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertFound();
  });

  testWidgets('Confirm logout, loading state', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    when(authRepository.signOut)
        .thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await tester.runAsync(() async {
      await r.pupmAccountScreen(authRepository: authRepository);
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
    });
    r.expectCircularProgressIndicator();
  });
}
