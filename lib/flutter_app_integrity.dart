import 'package:flutter/services.dart';

/// Result of a full integrity check.
class AppIntegrityResult {
  const AppIntegrityResult({
    required this.isRooted,
    required this.isEmulator,
    required this.isDebuggerAttached,
    required this.isAppTampered,
    required this.isDeveloperOptionsEnabled,
  });

  factory AppIntegrityResult.fromMap(
    Map<dynamic, dynamic> map,
  ) =>
      AppIntegrityResult(
        isRooted: map['isRooted'] as bool? ?? false,
        isEmulator: map['isEmulator'] as bool? ?? false,
        isDebuggerAttached: map['isDebuggerAttached'] as bool? ?? false,
        isAppTampered: map['isAppTampered'] as bool? ?? false,
        isDeveloperOptionsEnabled:
            map['isDeveloperOptionsEnabled'] as bool? ?? false,
      );

  final bool isRooted;
  final bool isEmulator;
  final bool isDebuggerAttached;
  final bool isAppTampered;
  final bool isDeveloperOptionsEnabled;

  /// Returns true if ANY integrity check has failed.
  bool get isThreatDetected =>
      isRooted ||
      isEmulator ||
      isDebuggerAttached ||
      isAppTampered ||
      isDeveloperOptionsEnabled;

  @override
  String toString() => 'AppIntegrityResult('
      'isRooted: $isRooted, '
      'isEmulator: $isEmulator, '
      'isDebuggerAttached: $isDebuggerAttached, '
      'isAppTampered: $isAppTampered, '
      'isDeveloperOptionsEnabled: '
      '$isDeveloperOptionsEnabled)';
}

class FlutterAppIntegrity {
  static const MethodChannel _channel = MethodChannel(
    'com.anuj/flutter_app_integrity',
  );

  static Future<AppIntegrityResult> checkIntegrity() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'checkIntegrity',
    );
    return AppIntegrityResult.fromMap(result!);
  }

  static Future<bool> isRooted() async =>
      await _channel.invokeMethod<bool>(
        'isRooted',
      ) ??
      false;

  static Future<bool> isEmulator() async =>
      await _channel.invokeMethod<bool>(
        'isEmulator',
      ) ??
      false;

  static Future<bool> isDebuggerAttached() async =>
      await _channel.invokeMethod<bool>(
        'isDebuggerAttached',
      ) ??
      false;

  static Future<bool> isAppTampered() async =>
      await _channel.invokeMethod<bool>(
        'isAppTampered',
      ) ??
      false;

  static Future<bool> isDeveloperOptionsEnabled() async =>
      await _channel.invokeMethod<bool>(
        'isDeveloperOptionsEnabled',
      ) ??
      false;
}
