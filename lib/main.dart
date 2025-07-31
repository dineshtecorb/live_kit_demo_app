import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_screen.dart';
import 'package:provider/provider.dart';
import 'livekit_provider.dart';

void main() {
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
      home: const LiveKitHomePage(),
    );
  }
}
