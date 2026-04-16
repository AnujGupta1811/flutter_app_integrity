// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_app_integrity/flutter_app_integrity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterAppIntegrity Integration Tests', () {
    testWidgets('checkIntegrity returns AppIntegrityResult', (
      WidgetTester tester,
    ) async {
      final result = await FlutterAppIntegrity.checkIntegrity();
      expect(result, isA<AppIntegrityResult>());
    });

    testWidgets('isRooted returns bool', (WidgetTester tester) async {
      final result = await FlutterAppIntegrity.isRooted();
      expect(result, isA<bool>());
    });

    testWidgets('isEmulator returns bool', (WidgetTester tester) async {
      final result = await FlutterAppIntegrity.isEmulator();
      expect(result, isA<bool>());
    });

    testWidgets('isDebuggerAttached returns bool', (WidgetTester tester) async {
      final result = await FlutterAppIntegrity.isDebuggerAttached();
      expect(result, isA<bool>());
    });

    testWidgets('isAppTampered returns bool', (WidgetTester tester) async {
      final result = await FlutterAppIntegrity.isAppTampered();
      expect(result, isA<bool>());
    });

    testWidgets('isDeveloperOptionsEnabled returns bool', (
      WidgetTester tester,
    ) async {
      final result = await FlutterAppIntegrity.isDeveloperOptionsEnabled();
      expect(result, isA<bool>());
    });
  });
}
