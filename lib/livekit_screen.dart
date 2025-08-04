import 'package:flutter/material.dart';
import 'package:live_kit_demo/livekit_provider.dart';
import 'package:provider/provider.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitHomePage extends StatefulWidget {
  const LiveKitHomePage({super.key});

  @override
  State<LiveKitHomePage> createState() => _LiveKitHomePageState();
}

class _LiveKitHomePageState extends State<LiveKitHomePage> {
  final _urlController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  List<Participant> _remoteParticipants = [];

  @override
  void initState() {
    super.initState();
    // Audio state will be managed through the UI controls
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    // Ensure cleanup when widget is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LiveKitProvider>(context, listen: false);
      if (provider.connected) {
        provider.disconnect().catchError((e) {
          // Log error but don't show UI since widget is being disposed
          print('Error during dispose cleanup: $e');
        });
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LiveKitProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('LiveKit Demo')),
      body: provider.connected
          ? _buildVideoChatInterface(provider)
          : _buildConnectionInterface(provider),
    );
  }

  Widget _buildConnectionInterface(LiveKitProvider provider) {
    return Padding(
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
          ElevatedButton(
            onPressed: () async {
              await provider.connect(
                provider.url ?? '',
                provider.token ?? '',
              );
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoChatInterface(LiveKitProvider provider) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Live Video Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your video is being published',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    if (provider.room?.localParticipant != null) {
                      await provider.room!.localParticipant!
                          .setCameraEnabled(!_isVideoEnabled);
                      setState(() {
                        _isVideoEnabled = !_isVideoEnabled;
                      });
                    }
                  },
                  icon: Icon(
                      _isVideoEnabled ? Icons.videocam : Icons.videocam_off),
                  label: Text(_isVideoEnabled ? 'Stop Video' : 'Start Video'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (provider.room?.localParticipant != null) {
                      try {
                        await provider.room!.localParticipant!
                            .setMicrophoneEnabled(!_isAudioEnabled);
                        setState(() {
                          _isAudioEnabled = !_isAudioEnabled;
                        });

                        // Show feedback to user
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isAudioEnabled
                                  ? 'Microphone enabled'
                                  : 'Microphone disabled'),
                              backgroundColor: _isAudioEnabled
                                  ? Colors.green
                                  : Colors.orange,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error toggling microphone: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Not connected to room'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(_isAudioEnabled ? Icons.mic : Icons.mic_off),
                  label: Text(_isAudioEnabled ? 'Mute' : 'Unmute'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await provider.disconnect();
                      // Optionally navigate back or show success message
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully disconnected'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error disconnecting: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Print debug info
                    provider.printDebugInfo();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Debug info printed to console'),
                          backgroundColor: Colors.blue,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Debug'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
