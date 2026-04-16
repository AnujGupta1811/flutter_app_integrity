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

  /// True if the device is rooted (Android) or jailbroken (iOS).
  final bool isRooted;

  /// True if the app is running on an emulator or simulator.
  final bool isEmulator;

  /// True if a debugger is currently attached to the process.
  final bool isDebuggerAttached;

  /// True if the app signature has been tampered (Android only).
  final bool isAppTampered;

  /// True if developer options are enabled (Android only).
  final bool isDeveloperOptionsEnabled;

  /// Returns true if ANY integrity check has failed.
  bool get isThreatDetected =>
      isRooted ||
      isEmulator ||
      isDebuggerAttached ||
      isAppTampered ||
      isDeveloperOptionsEnabled;

  factory AppIntegrityResult.fromMap(Map<dynamic, dynamic> map) {
    return AppIntegrityResult(
      isRooted: map['isRooted'] as bool? ?? false,
      isEmulator: map['isEmulator'] as bool? ?? false,
      isDebuggerAttached: map['isDebuggerAttached'] as bool? ?? false,
      isAppTampered: map['isAppTampered'] as bool? ?? false,
      isDeveloperOptionsEnabled:
          map['isDeveloperOptionsEnabled'] as bool? ?? false,
    );
  }

  @override
  String toString() => 'AppIntegrityResult('
      'isRooted: $isRooted, '
      'isEmulator: $isEmulator, '
      'isDebuggerAttached: $isDebuggerAttached, '
      'isAppTampered: $isAppTampered, '
      'isDeveloperOptionsEnabled: $isDeveloperOptionsEnabled)';
}

/// Flutter plugin to verify the integrity and security of the app environment.
class FlutterAppIntegrity {
  static const MethodChannel _channel = MethodChannel(
    'com.anuj/flutter_app_integrity',
  );

  /// Runs all integrity checks and returns a full [AppIntegrityResult].
  static Future<AppIntegrityResult> checkIntegrity() async {
    var result = await _channel.invokeMethod<Map<dynamic, dynamic>>('checkIntegrity');
    return AppIntegrityResult.fromMap(result!);
  }

  /// Returns true if the device is rooted (Android) or jailbroken (iOS).
  static Future<bool> isRooted() async {
    return await _channel.invokeMethod<bool>('isRooted') ?? false;
  }

  /// Returns true if the app is running on an emulator or simulator.
  static Future<bool> isEmulator() async {
    return await _channel.invokeMethod<bool>('isEmulator') ?? false;
  }

  /// Returns true if a debugger is attached to the process.
  static Future<bool> isDebuggerAttached() async {
    return await _channel.invokeMethod<bool>('isDebuggerAttached') ?? false;
  }

  /// Returns true if the APK signature has been tampered (Android only).
  /// Always returns false on iOS.
  static Future<bool> isAppTampered() async {
    return await _channel.invokeMethod<bool>('isAppTampered') ?? false;
  }

  /// Returns true if developer options are enabled (Android only).
  /// Always returns false on iOS.
  static Future<bool> isDeveloperOptionsEnabled() async {
    return await _channel.invokeMethod<bool>('isDeveloperOptionsEnabled') ??
        false;
  }
}
