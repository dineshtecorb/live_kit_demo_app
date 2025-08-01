import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_start_screen.dart';
import 'package:provider/provider.dart';
import 'livekit_provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

Future<void> _initializeAndroidAudioSettings() async {
  await webrtc.WebRTC.initialize(options: {
    'androidAudioConfiguration': webrtc.AndroidAudioConfiguration.media.toMap()
  });
  webrtc.Helper.setAndroidAudioConfiguration(
      webrtc.AndroidAudioConfiguration.media);
}

void main() async {
  if (Platform.isAndroid) {
    // await _initializeAndroidAudioSettings();
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => LiveKitProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Kit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LiveKitStartScreen(),
    );
  }
}
