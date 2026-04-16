import 'package:flutter/material.dart';
import 'package:flutter_app_integrity/flutter_app_integrity.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Integrity Demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const IntegrityPage(),
    );
  }
}

class IntegrityPage extends StatefulWidget {
  const IntegrityPage({super.key});

  @override
  State<IntegrityPage> createState() => _IntegrityPageState();
}

class _IntegrityPageState extends State<IntegrityPage> {
  AppIntegrityResult? _result;
  bool _loading = false;

  Future<void> _runCheck() async {
    setState(() => _loading = true);
    try {
      final result = await FlutterAppIntegrity.checkIntegrity();
      setState(() => _result = result);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Integrity Check')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _loading ? null : _runCheck,
              icon: const Icon(Icons.security),
              label: Text(_loading ? 'Checking...' : 'Run Integrity Check'),
            ),
            const SizedBox(height: 32),
            if (_result != null) ...[
              _StatusTile(
                label: 'Device Rooted / Jailbroken',
                value: _result!.isRooted,
              ),
              _StatusTile(
                label: 'Emulator / Simulator',
                value: _result!.isEmulator,
              ),
              _StatusTile(
                label: 'Debugger Attached',
                value: _result!.isDebuggerAttached,
              ),
              _StatusTile(
                label: 'App Tampered (Android)',
                value: _result!.isAppTampered,
              ),
              _StatusTile(
                label: 'Developer Options Enabled',
                value: _result!.isDeveloperOptionsEnabled,
              ),
              const Divider(height: 32),
              _StatusTile(
                label: 'Overall Threat Detected',
                value: _result!.isThreatDetected,
                isSummary: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final String label;
  final bool value;
  final bool isSummary;

  const _StatusTile({
    required this.label,
    required this.value,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        value ? Icons.warning_amber_rounded : Icons.check_circle_outline,
        color: value ? Colors.red : Colors.green,
        size: isSummary ? 32 : 24,
      ),
      title: Text(
        label,
        style: isSummary
            ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            : null,
      ),
      trailing: Text(
        value ? 'DETECTED' : 'SAFE',
        style: TextStyle(
          color: value ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
