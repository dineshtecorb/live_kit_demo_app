import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'livekit_service.dart';

class LiveKitProvider extends ChangeNotifier {
  final LiveKitService _service = LiveKitService();
  bool _connected = false;
  bool get connected => _connected;
  Room? get room => _service.room;

  Future<void> connect(String url, String token) async {
    await _service.connect(url, token);
    _connected = true;
    notifyListeners();
  }

  void disconnect() {
    _service.disconnect();
    _connected = false;
    notifyListeners();
  }
}
