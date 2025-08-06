import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_screen.dart';
import 'package:livekit_client/livekit_client.dart';
import 'livekit_service.dart';

class LiveKitProvider extends ChangeNotifier {
  final LiveKitService _service = LiveKitService();
  bool _connected = false;
  bool get connected => _connected;
  Room? get room => _service.room;

  String? _url;
  String? _token;
  String? get url => _url;
  String? get token => _token;

  String? _paticipantName;
  String? _roomName;
  String? get paticipantName => _paticipantName;
  String? get roomName => _roomName;

  Future<void> generateTokenAndUrlWith(
      BuildContext context, String paticipantName, String roomName) async {
    final response =
        await _service.generateTokenAndUrlWith(paticipantName, roomName);

    if (response != null &&
        response['serverUrl'] != null &&
        response['participantToken'] != null) {
      //if (await _service.isRoomActive(response['roomName'])) {}
      _url = response['serverUrl'];
      _token = response['participantToken'];
      _paticipantName = response['participantName'];
      _roomName = response['roomName'];
      print(
          "url is $_url and token is $_token also name $_roomName and $_paticipantName");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LiveKitHomePage()),
      );
      notifyListeners();
    }
    return response;
  }

  Future<void> connect(String url, String token) async {
    try {
      await _service.connect(url, token);
      _connected = true;
      notifyListeners();
    } catch (e) {
      _connected = false;
      notifyListeners();
      //rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _service.disconnect();
      _connected = false;
      notifyListeners();
    } catch (e) {
      // Even if disconnect fails, mark as disconnected
      _connected = false;
      notifyListeners();
      // rethrow;
    }
  }

  void printDebugInfo() {
    _service.printAudioDebugInfo();
  }
}
