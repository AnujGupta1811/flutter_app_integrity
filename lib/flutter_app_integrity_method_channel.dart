import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_app_integrity_platform_interface.dart';

/// An implementation of [FlutterAppIntegrityPlatform] that uses method channels.
class MethodChannelFlutterAppIntegrity extends FlutterAppIntegrityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_app_integrity');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
