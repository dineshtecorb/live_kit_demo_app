/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livekit_client/livekit_client.dart' hide ConnectionState;
import 'package:live_kit_demo/firebase_service.dart';
import 'package:live_kit_demo/livekit_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  List<Participant> _remoteParticipants = [];

  @override
  void initState() {
    super.initState();
    _joinRoom();
  }

  Future<void> _joinRoom() async {
    try {
      final user = _firebaseService.currentUser;
      if (user != null) {
        await _firebaseService.joinChatRoom(widget.roomId, user.uid);
        await _firebaseService.updateUserLastSeen(user.uid);
      }
    } catch (e) {
      print('Error joining room: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final user = _firebaseService.currentUser;
      if (user != null) {
        await _firebaseService.sendMessage(
          widget.roomId,
          user.uid,
          _messageController.text.trim(),
          senderName: user.displayName ?? 'Anonymous',
        );
        _messageController.clear();
        _scrollToBottom();
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LiveKitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Navigate to video chat
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Video preview area
          if (provider.connected)
            Container(
              height: 200,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
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
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Live Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Chat messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMessages(widget.roomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isCurrentUser = message['senderId'] ==
                        _firebaseService.currentUser?.uid;

                    return _buildMessageBubble(message, isCurrentUser);
                  },
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: provider.connected
          ? FloatingActionButton.extended(
              onPressed: () {
                // Toggle video/audio controls
                _showVideoControls(provider);
              },
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.videocam),
              label: const Text('Video Controls'),
            )
          : null,
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple,
              child: Text(
                (message['senderName'] as String?)
                        ?.substring(0, 1)
                        .toUpperCase() ??
                    'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.deepPurple : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    Text(
                      message['senderName'] ?? 'Anonymous',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isCurrentUser ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  Text(
                    message['message'] ?? '',
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _showVideoControls(LiveKitProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Video Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
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
                      await provider.room!.localParticipant!
                          .setMicrophoneEnabled(!_isAudioEnabled);
                      setState(() {
                        _isAudioEnabled = !_isAudioEnabled;
                      });
                    }
                  },
                  icon: Icon(_isAudioEnabled ? Icons.mic : Icons.mic_off),
                  label: Text(_isAudioEnabled ? 'Mute' : 'Unmute'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                provider.disconnect();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.call_end),
              label: const Text('End Call'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}*/
