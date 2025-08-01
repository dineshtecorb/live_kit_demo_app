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
    var status = await Permission.bluetooth.request();
    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bluetooth Permission disabled'),
        ),
      );
      print('Bluetooth Permission disabled');
    }
    status = await Permission.bluetoothConnect.request();
    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bluetooth Connect Permission disabled'),
        ),
      );
      print('Bluetooth Connect Permission disabled');
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
