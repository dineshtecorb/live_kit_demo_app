import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveKitStartScreen extends StatefulWidget {
  const LiveKitStartScreen({super.key});

  @override
  State<LiveKitStartScreen> createState() => _LiveKitStartScreenState();
}

class _LiveKitStartScreenState extends State<LiveKitStartScreen> {
  final _participantNameController = TextEditingController();
  final _roomNameController = TextEditingController();

  Future<void> _checkPermissions() async {
    // Check microphone permission (required for audio)
    var micStatus = await Permission.microphone.request();
    if (micStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for audio calls'),
          backgroundColor: Colors.red,
        ),
      );
      print('Microphone permission denied');
    }

    // Check camera permission (optional for video)
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required for video calls'),
          backgroundColor: Colors.orange,
        ),
      );
      print('Camera permission denied');
    }

    // Check bluetooth permissions (optional)
    var bluetoothStatus = await Permission.bluetooth.request();
    if (bluetoothStatus.isPermanentlyDenied) {
      print('Bluetooth permission denied');
    }

    var bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    if (bluetoothConnectStatus.isPermanentlyDenied) {
      print('Bluetooth connect permission denied');
    }
  }

  @override
  void initState() {
    super.initState();
    // _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LiveKitProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('LiveKit Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instructions for testing
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                children: [
                  Text(
                    'To test with two devices:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Use the SAME room name on both devices\n'
                    '• Use DIFFERENT participant names\n'
                    '• Click "Join Room" on both devices',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _participantNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name (e.g., John, Alice)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                labelText: 'Room Name',
                hintText: 'Enter room name (e.g., meeting-123)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_participantNameController.text.isEmpty ||
                    _roomNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Please enter both your name and room name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text('Joining room: ${_roomNameController.text}'),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );

                provider.generateTokenAndUrlWith(
                  context,
                  _participantNameController.text,
                  _roomNameController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
