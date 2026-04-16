import Flutter
import UIKit

public class FlutterAppIntegrityPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.anuj/flutter_app_integrity",
            binaryMessenger: registrar.messenger()
        )
        let instance = FlutterAppIntegrityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkIntegrity":
            result([
                "isRooted": checkJailbreak(),
                "isEmulator": checkSimulator(),
                "isDebuggerAttached": checkDebugger(),
                "isAppTampered": false,          // Not applicable on iOS
                "isDeveloperOptionsEnabled": false // Not applicable on iOS
            ])
        case "isRooted":
            result(checkJailbreak())
        case "isEmulator":
            result(checkSimulator())
        case "isDebuggerAttached":
            result(checkDebugger())
        case "isAppTampered":
            result(false)
        case "isDeveloperOptionsEnabled":
            result(false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // ─── Jailbreak Detection ───────────────────────────────────────────────

    private func checkJailbreak() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        // Check for common jailbreak files
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/stash",
            "/usr/bin/ssh",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/SBSettings.app"
        ]

        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        // Check if we can write outside sandbox
        let testPath = "/private/jailbreak_test_\(UUID().uuidString)"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true // Wrote outside sandbox — jailbroken
        } catch {
            // Expected on non-jailbroken devices
        }

        // Check if Cydia URL scheme is accessible
        if let url = URL(string: "cydia://package/com.example.package"),
           UIApplication.shared.canOpenURL(url) {
            return true
        }

        return false
        #endif
    }

    // ─── Simulator Detection ───────────────────────────────────────────────

    private func checkSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    // ─── Debugger Detection ────────────────────────────────────────────────

    private func checkDebugger() -> Bool {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride

        let result = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        if result != 0 { return false }

        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}