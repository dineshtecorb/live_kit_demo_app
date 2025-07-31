import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_provider.dart';
import 'package:provider/provider.dart';

class LiveKitHomePage extends StatefulWidget {
  const LiveKitHomePage({super.key});

  @override
  State<LiveKitHomePage> createState() => _LiveKitHomePageState();
}

class _LiveKitHomePageState extends State<LiveKitHomePage> {
  final _urlController = TextEditingController();
  final _tokenController = TextEditingController();

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
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'LiveKit URL'),
            ),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(labelText: 'Token'),
            ),
            const SizedBox(height: 20),
            provider.connected
                ? Column(
                    children: [
                      const Text('Connected!'),
                      ElevatedButton(
                        onPressed: provider.disconnect,
                        child: const Text('Disconnect'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await provider.connect(
                        "wss://vshnu-b8m7yrna.livekit.cloud" /*_urlController.text*/,
                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTM5NjU2NTcsImlzcyI6IkFQSTdMaExVd2t6U2ZmciIsIm5iZiI6MTc1Mzk2NDc1Nywic3ViIjoicm9ib3RpYy1zb2NrZXQiLCJ2aWRlbyI6eyJjYW5VcGRhdGVPd25NZXRhZGF0YSI6dHJ1ZSwicm9vbSI6InNieC0xaWhoM3AtalhoSExSR1NuOFVSWEIzNW9MNUZUSiIsInJvb21Kb2luIjp0cnVlLCJyb29tTGlzdCI6dHJ1ZX19.4YerIzeqFj3TOqmMKXL836RIsH4HFEwi6Bu_Q4rXL7M" /*_tokenController.text*/,
                      );
                    },
                    child: const Text('Connect'),
                  ),
          ],
        ),
      ),
    );
  }
}
