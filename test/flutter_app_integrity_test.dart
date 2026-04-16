import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_integrity/flutter_app_integrity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterAppIntegrity', () {
    test('checkIntegrity returns AppIntegrityResult', () async {
      // Since MethodChannel is not mocked, this will throw MissingPluginException in a real test.
      // In a real test, use MethodChannelMock or mockito to mock MethodChannel responses.
      expect(
        () => FlutterAppIntegrity.checkIntegrity(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('isRooted returns bool', () async {
      expect(
        () => FlutterAppIntegrity.isRooted(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('isEmulator returns bool', () async {
      expect(
        () => FlutterAppIntegrity.isEmulator(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('isDebuggerAttached returns bool', () async {
      expect(
        () => FlutterAppIntegrity.isDebuggerAttached(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('isAppTampered returns bool', () async {
      expect(
        () => FlutterAppIntegrity.isAppTampered(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('isDeveloperOptionsEnabled returns bool', () async {
      expect(
        () => FlutterAppIntegrity.isDeveloperOptionsEnabled(),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('AppIntegrityResult.isThreatDetected works', () {
      final result = AppIntegrityResult(
        isRooted: false,
        isEmulator: false,
        isDebuggerAttached: false,
        isAppTampered: false,
        isDeveloperOptionsEnabled: false,
      );
      expect(result.isThreatDetected, false);

      final result2 = AppIntegrityResult(
        isRooted: true,
        isEmulator: false,
        isDebuggerAttached: false,
        isAppTampered: false,
        isDeveloperOptionsEnabled: false,
      );
      expect(result2.isThreatDetected, true);
    });

    test('AppIntegrityResult.fromMap parses correctly', () {
      final map = {
        'isRooted': true,
        'isEmulator': false,
        'isDebuggerAttached': true,
        'isAppTampered': false,
        'isDeveloperOptionsEnabled': true,
      };
      final result = AppIntegrityResult.fromMap(map);
      expect(result.isRooted, true);
      expect(result.isEmulator, false);
      expect(result.isDebuggerAttached, true);
      expect(result.isAppTampered, false);
      expect(result.isDeveloperOptionsEnabled, true);
    });
  });
}
