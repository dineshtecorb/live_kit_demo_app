import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:http/http.dart' as http;

class LiveKitService {
  Room? _room;
  Room? get room => _room;

  final roomOptions = const RoomOptions(
    adaptiveStream: true,
    dynacast: true,
    defaultAudioCaptureOptions: AudioCaptureOptions(),
    defaultVideoPublishOptions: VideoPublishOptions(),
    // WebRTC configuration is handled internally by LiveKit
  );

  Future<void> connect(String url, String token) async {
    try {
      _room = Room();
      _room?.addListener(() {
        debugPrint('Room connection state: ${_room?.connectionState}');
      });

      await _room?.connect(url, token,
          roomOptions: roomOptions, connectOptions: const ConnectOptions());

      // Enable audio and video after successful connection
      try {
        // Enable microphone (audio)
        await _room?.localParticipant?.setMicrophoneEnabled(true);
        if (kDebugMode) {
          print('Microphone enabled successfully');
        }

        // Enable camera (video) - will fail on iOS simulator
        await _room?.localParticipant?.setCameraEnabled(true);
        if (kDebugMode) {
          print('Camera enabled successfully');
        }
      } catch (error) {
        if (kDebugMode) {
          print('Could not enable camera/video, error: $error');
          print(
              'This is normal on iOS simulator or if camera is not available');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to LiveKit room: $e');
      }
    }
  }

  Future<void> disconnect() async {
    try {
      if (_room != null) {
        if (kDebugMode) {
          print('Starting LiveKit room disconnect...');
        }

        // Disable local tracks before disconnecting
        final localParticipant = _room!.localParticipant;
        if (localParticipant != null) {
          try {
            if (kDebugMode) {
              print('Disabling local tracks...');
            }
            await localParticipant.setCameraEnabled(false);
            await localParticipant.setMicrophoneEnabled(false);
            if (kDebugMode) {
              print('Local tracks disabled successfully');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error disabling local tracks: $e');
            }
          }
        }

        // Disconnect the room
        if (kDebugMode) {
          print('Disconnecting from LiveKit room...');
        }
        await _room!.disconnect();
        _room = null;

        if (kDebugMode) {
          print('Successfully disconnected from LiveKit room');
        }
      } else {
        if (kDebugMode) {
          print('No room to disconnect from');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during disconnect: $e');
      }
      // Ensure room is null even if disconnect fails
      _room = null;
    }
  }

  // Add method to get audio debugging info
  void printAudioDebugInfo() {
    if (kDebugMode) {
      print('=== Audio Debug Info ===');
      print('Room connected: ${_room != null}');
      if (_room != null) {
        print('Local participant: ${_room!.localParticipant != null}');
        if (_room!.localParticipant != null) {
          print(
              'Published tracks: ${_room!.localParticipant!.trackPublications.length}');
        }
      }
      print('=======================');
    }
  }

  // Add more methods for publishing, subscribing, muting, etc. as needed
  /*Future<dynamic> generateTokenAndUrlWith(
      String paticipantName, String roomName) async {
    Map<String, String> jsonObject = {
      'roomName': roomName,
      'participantName': paticipantName,
    };
    try {
      final response = await http.post(
        Uri.parse(
            'https://cloud-api.livekit.io/api/sandbox/connection-details'),
        headers: {
          //'content-type': 'application/json', //'viveklivekit-1rg10o' //
          'X-Sandbox-ID': 'viveklivekit-1rg10o',
        },
        body: jsonEncode(jsonObject),
      );
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print('Error generating token and url: $e');
      }
    }
  }*/

  Future<dynamic> generateTokenAndUrlWith(
    String participantName,
    String roomName,
  ) async {
    final Map<String, String> requestBody = {
      'roomName': roomName,
      'participantName': participantName,
    };
    final Map<String, String> header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'X-Sandbox-ID': 'viveklivekit-1rg10o',
    };
    try {
      final response = await http.post(
        Uri.parse(
            'https://cloud-api.livekit.io/api/sandbox/connection-details'),
        headers: header,
        body: requestBody,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (kDebugMode) {
          print("Token generated: $json");
        }

        // Override the random participant name with the one user provided
        // json['participantName'] = participantName;
        // json['roomName'] = roomName;

        return json;
      } else {
        throw Exception(
            'Failed to generate token: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating token and URL: $e');
      }
      rethrow;
    }
  }

  Future<bool> isRoomActive(String roomName) async {
    final response = await http.get(
      Uri.parse('https://cloud-api.livekit.io/rooms'),
      headers: {
        'X-Sandbox-ID': 'tecorblivekitserver-1xky67', // Needs admin token
      },
    );
    if (response.statusCode == 200) {
      final rooms = jsonDecode(response.body)['rooms'] as List;
      return rooms.any((room) => room['name'] == roomName);
    }
    return false;
  }
}
