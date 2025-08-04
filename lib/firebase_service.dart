/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Authentication methods
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error signing in with email: $e');
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Chat room methods
  Future<String> createChatRoom(String roomName, String createdBy) async {
    try {
      DocumentReference docRef = await _firestore.collection('chat_rooms').add({
        'name': roomName,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'participants': [createdBy],
        'isActive': true,
      });
      return docRef.id;
    } catch (e) {
      print('Error creating chat room: $e');
      rethrow;
    }
  }

  Future<void> joinChatRoom(String roomId, String userId) async {
    try {
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'participants': FieldValue.arrayUnion([userId]),
        'lastActivity': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error joining chat room: $e');
      rethrow;
    }
  }

  Future<void> leaveChatRoom(String roomId, String userId) async {
    try {
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'participants': FieldValue.arrayRemove([userId]),
        'lastActivity': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error leaving chat room: $e');
      rethrow;
    }
  }

  // Chat messages methods
  Future<void> sendMessage(String roomId, String senderId, String message,
      {String? senderName}) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'senderName': senderName ?? 'Anonymous',
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // LiveKit token management
  Future<void> saveLiveKitToken(
      String roomId, String userId, String token) async {
    try {
      await _firestore.collection('livekit_tokens').add({
        'roomId': roomId,
        'userId': userId,
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      print('Error saving LiveKit token: $e');
      rethrow;
    }
  }

  Future<String?> getLiveKitToken(String roomId, String userId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('livekit_tokens')
          .where('roomId', isEqualTo: roomId)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return (query.docs.first.data() as Map<String, dynamic>)['token']
            as String;
      }
      return null;
    } catch (e) {
      print('Error getting LiveKit token: $e');
      return null;
    }
  }

  // User management
  Future<void> createUserProfile(String userId, String displayName,
      {String? email}) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserLastSeen(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user last seen: $e');
      rethrow;
    }
  }

  // Push notifications
  Future<void> initializePushNotifications() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _messaging.getToken();
        if (token != null) {
          await saveFCMToken(token);
        }
      }
    } catch (e) {
      print('Error initializing push notifications: $e');
    }
  }

  Future<void> saveFCMToken(String token) async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'fcmToken': token,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  // Room management
  Stream<QuerySnapshot> getActiveChatRooms() {
    return _firestore
        .collection('chat_rooms')
        .where('isActive', isEqualTo: true)
        .orderBy('lastActivity', descending: true)
        .snapshots();
  }

  Future<void> updateRoomActivity(String roomId) async {
    try {
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'lastActivity': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating room activity: $e');
    }
  }
}*/
