# flutter_app_integrity

A Flutter plugin for **Android** and **iOS** that detects security threats to your app environment — including rooted/jailbroken devices, emulators, debuggers, app tampering, and developer options.

---

## Features

| Check | Android | iOS |
|---|:---:|:---:|
| Rooted / Jailbroken device | ✅ | ✅ |
| Emulator / Simulator | ✅ | ✅ |
| Debugger attached | ✅ | ✅ |
| App signature tampered | ✅ | — |
| Developer options enabled | ✅ | — |

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_app_integrity: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## Usage

### Full Integrity Check (recommended)

```dart
import 'package:flutter_app_integrity/flutter_app_integrity.dart';

final result = await FlutterAppIntegrity.checkIntegrity();

if (result.isThreatDetected) {
  // Block the user or show a warning
  print('Security threat detected!');
} else {
  print('Device is clean.');
}

print(result.isRooted);               // true/false
print(result.isEmulator);             // true/false
print(result.isDebuggerAttached);     // true/false
print(result.isAppTampered);          // true/false (Android only)
print(result.isDeveloperOptionsEnabled); // true/false (Android only)
```

### Individual Checks

```dart
final rooted = await FlutterAppIntegrity.isRooted();
final emulator = await FlutterAppIntegrity.isEmulator();
final debugger = await FlutterAppIntegrity.isDebuggerAttached();
final tampered = await FlutterAppIntegrity.isAppTampered();
final devOptions = await FlutterAppIntegrity.isDeveloperOptionsEnabled();
```

---

## Android Setup

No additional setup required. The plugin uses only standard Android APIs.

Minimum SDK: **21 (Android 5.0)**

---

## iOS Setup

No additional setup required.

Minimum deployment target: **iOS 12.0**

---

## AppIntegrityResult

| Property | Type | Description |
|---|---|---|
| `isRooted` | `bool` | Device is rooted (Android) or jailbroken (iOS) |
| `isEmulator` | `bool` | Running on emulator or simulator |
| `isDebuggerAttached` | `bool` | A debugger is connected to the process |
| `isAppTampered` | `bool` | APK signature mismatch (Android only) |
| `isDeveloperOptionsEnabled` | `bool` | Developer options enabled (Android only) |
| `isThreatDetected` | `bool` | `true` if **any** check above is `true` |

---

## Notes

- Results on **emulators/simulators** during development will naturally trigger some checks. Use conditional logic for debug builds if needed.
- For production apps, consider calling `checkIntegrity()` at app startup and on sensitive screens (e.g., payment, login).
- This plugin does **not** use any paid third-party SDKs.

---

## Contributing

Pull requests are welcome! Please open an issue first to discuss major changes.

---

## License

MIT

## Test

addding this line to check the workflow of pr review 
second PR to test
