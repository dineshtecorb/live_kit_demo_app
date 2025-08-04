import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_provider.dart';
import 'package:live_kit_demo/livekit_screen.dart';
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
    _checkPermissions();
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
            TextField(
              controller: _participantNameController,
              decoration: const InputDecoration(labelText: 'Participant Name'),
            ),
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
            ),
            ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LiveKitHomePage()));*/
                if (_participantNameController.text.isEmpty ||
                    _roomNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Please enter a participant name and room name'),
                    ),
                  );
                  return;
                }
                provider.generateTokenAndUrlWith(context,
                    _participantNameController.text, _roomNameController.text);
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
