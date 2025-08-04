# LiveKit Chat Demo with Firebase Integration

A Flutter application that combines LiveKit for real-time audio/video communication with Firebase for authentication, chat functionality, and data persistence.

## Features

- **Firebase Authentication**: Email/password and anonymous authentication
- **Real-time Chat**: Text messaging using Firebase Firestore
- **LiveKit Integration**: Audio/video calling capabilities
- **Room Management**: Create and join chat rooms
- **User Profiles**: User management with display names
- **Push Notifications**: Firebase Cloud Messaging support

## Prerequisites

- Flutter SDK (3.5.4 or higher)
- Firebase project
- LiveKit server
- Android Studio / Xcode for platform-specific setup

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable the following services:
   - Authentication (Email/Password and Anonymous)
   - Firestore Database
   - Cloud Storage
   - Cloud Messaging

### 2. Configure Android

1. Add your Android app to Firebase project:
   - Package name: `com.example.live_kit_demo`
   - Download `google-services.json`
   - Replace the placeholder file in `android/app/google-services.json`

2. Update `android/app/build.gradle`:
   ```gradle
   plugins {
       id "com.android.application"
       id "kotlin-android"
       id "dev.flutter.flutter-gradle-plugin"
       id "com.google.gms.google-services"  // Already added
   }
   ```

### 3. Configure iOS

1. Add your iOS app to Firebase project:
   - Bundle ID: `com.example.liveKitDemo`
   - Download `GoogleService-Info.plist`
   - Replace the placeholder file in `ios/Runner/GoogleService-Info.plist`

2. Update `ios/Runner/Info.plist` to include camera and microphone permissions:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access for video calls</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>This app needs microphone access for audio calls</string>
   ```

### 4. Firestore Security Rules

Set up Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write chat rooms
    match /chat_rooms/{roomId} {
      allow read, write: if request.auth != null;
      
      // Allow users to read/write messages in rooms they're part of
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
    
    // Allow users to manage their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to manage LiveKit tokens
    match /livekit_tokens/{tokenId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## LiveKit Setup

1. Set up a LiveKit server (self-hosted or cloud)
2. Configure your LiveKit URL and API keys
3. Update the LiveKit configuration in your app

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd live_kit_demo
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Replace placeholder configuration files with your actual Firebase config
   - Update Firebase project settings

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── auth_screen.dart          # Authentication UI
├── room_list_screen.dart     # Chat room list
├── chat_screen.dart          # Chat interface with video integration
├── firebase_service.dart     # Firebase service layer
├── livekit_provider.dart     # LiveKit state management
├── livekit_screen.dart       # Video call interface
├── livekit_service.dart      # LiveKit service layer
└── livekit_start_screen.dart # Original LiveKit demo screen
```

## Key Components

### FirebaseService
Handles all Firebase operations:
- Authentication (sign in, sign up, anonymous)
- Firestore operations (chat rooms, messages)
- User management
- Push notifications

### ChatScreen
Combines text chat with video preview:
- Real-time messaging
- Video call controls
- Message history
- User presence

### RoomListScreen
Manages chat rooms:
- List active rooms
- Create new rooms
- Join existing rooms
- User authentication state

## Usage

1. **Authentication**: Users can sign up/sign in or continue as guest
2. **Room Management**: Create or join chat rooms
3. **Text Chat**: Send and receive real-time messages
4. **Video Calls**: Start video calls within chat rooms
5. **User Management**: Update profiles and manage settings

## Dependencies

- `firebase_core`: Firebase initialization
- `firebase_auth`: User authentication
- `cloud_firestore`: Real-time database
- `firebase_storage`: File storage
- `firebase_messaging`: Push notifications
- `livekit_client`: LiveKit SDK
- `provider`: State management
- `flutter_webrtc`: WebRTC support

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Ensure `google-services.json` and `GoogleService-Info.plist` are properly configured
2. **Permission errors**: Check camera and microphone permissions in platform-specific files
3. **Build errors**: Run `flutter clean` and `flutter pub get`
4. **LiveKit connection**: Verify LiveKit server URL and token generation

### Debug Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Firebase configuration
flutter doctor
```

## Security Considerations

- Use proper Firestore security rules
- Implement token-based authentication for LiveKit
- Validate user input on both client and server
- Use HTTPS for all API communications
- Implement proper error handling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
