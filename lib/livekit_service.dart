import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? _room;
  Room? get room => _room;

  final roomOptions = const RoomOptions(
    adaptiveStream: true,
    dynacast: true,
    // ... your room options
  );

  Future<void> connect(String url, String token) async {
    _room = Room();
    await _room?.connect(url, token, roomOptions: roomOptions);
    try {
      // video will fail when running in ios simulator
      await _room?.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      if (kDebugMode) {
        print('Could not publish video, error: $error');
      }
    }

    await _room?.localParticipant?.setMicrophoneEnabled(true);
  }

  void disconnect() {
    _room?.disconnect();
    _room = null;
  }

  // Add more methods for publishing, subscribing, muting, etc. as needed
}
