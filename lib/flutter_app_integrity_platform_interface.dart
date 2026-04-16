import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:flutter_app_integrity/flutter_app_integrity_method_channel.dart';

abstract class FlutterAppIntegrityPlatform extends PlatformInterface {
  /// Constructs a FlutterAppIntegrityPlatform.
  FlutterAppIntegrityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAppIntegrityPlatform _instance =
      MethodChannelFlutterAppIntegrity();

  /// The default instance of [FlutterAppIntegrityPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAppIntegrity].
  static FlutterAppIntegrityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAppIntegrityPlatform] when
  /// they register themselves.
  static set instance(FlutterAppIntegrityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
