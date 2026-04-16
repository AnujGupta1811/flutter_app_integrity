package com.anuj.flutter_app_integrity

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class FlutterAppIntegrityPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(
            binding.binaryMessenger,
            "com.anuj/flutter_app_integrity"
        )
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "checkIntegrity" -> result.success(
                mapOf(
                    "isRooted" to checkRooted(),
                    "isEmulator" to checkEmulator(),
                    "isDebuggerAttached" to checkDebugger(),
                    "isAppTampered" to checkAppTampered(),
                    "isDeveloperOptionsEnabled" to checkDeveloperOptions()
                )
            )
            "isRooted" -> result.success(checkRooted())
            "isEmulator" -> result.success(checkEmulator())
            "isDebuggerAttached" -> result.success(checkDebugger())
            "isAppTampered" -> result.success(checkAppTampered())
            "isDeveloperOptionsEnabled" -> result.success(checkDeveloperOptions())
            else -> result.notImplemented()
        }
    }

    // ─── Root Detection ────────────────────────────────────────────────────

    private fun checkRooted(): Boolean {
        return checkSuBinary() || checkRootPaths() || checkBuildTags()
    }

    private fun checkSuBinary(): Boolean {
        val paths = arrayOf(
            "/sbin/su", "/system/bin/su", "/system/xbin/su",
            "/data/local/xbin/su", "/data/local/bin/su",
            "/system/sd/xbin/su", "/system/bin/failsafe/su",
            "/data/local/su"
        )
        return paths.any { File(it).exists() }
    }

    private fun checkRootPaths(): Boolean {
        val dangerousPaths = arrayOf(
            "/system/app/Superuser.apk",
            "/system/etc/init.d/99SuperSUDaemon",
            "/dev/com.koushikdutta.superuser.daemon/",
            "/system/xbin/daemonsu"
        )
        return dangerousPaths.any { File(it).exists() }
    }

    private fun checkBuildTags(): Boolean {
        val buildTags = Build.TAGS
        return buildTags != null && buildTags.contains("test-keys")
    }

    // ─── Emulator Detection ────────────────────────────────────────────────

    private fun checkEmulator(): Boolean {
        return (Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.BRAND.startsWith("generic")
                || Build.DEVICE.startsWith("generic")
                || Build.PRODUCT == "google_sdk"
                || Build.HARDWARE == "goldfish"
                || Build.HARDWARE == "ranchu"
                || Build.BOARD == "QC_Reference_Phone"
                || Build.HOST.startsWith("Build"))
    }

    // ─── Debugger Detection ────────────────────────────────────────────────

    private fun checkDebugger(): Boolean {
        return android.os.Debug.isDebuggerConnected()
    }

    // ─── App Tamper Detection ──────────────────────────────────────────────

    private fun checkAppTampered(): Boolean {
        return try {
            val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                context.packageManager.getPackageInfo(
                    context.packageName,
                    PackageManager.GET_SIGNING_CERTIFICATES
                )
            } else {
                @Suppress("DEPRECATION")
                context.packageManager.getPackageInfo(
                    context.packageName,
                    PackageManager.GET_SIGNATURES
                )
            }

            // In a real app, compare the signature hash against a known-good value
            // stored securely. Here we just check if signatures exist.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.signingInfo?.apkContentsSigners?.isEmpty() ?: true
            } else {
                @Suppress("DEPRECATION")
                packageInfo.signatures?.isEmpty() ?: true
            }
        } catch (e: Exception) {
            true // If we can't read signatures, consider it tampered
        }
    }

    // ─── Developer Options Detection ──────────────────────────────────────

    private fun checkDeveloperOptions(): Boolean {
        return Settings.Global.getInt(
            context.contentResolver,
            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
            0
        ) != 0
    }
}