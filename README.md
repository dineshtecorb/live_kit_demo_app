# LiveKit Demo

A Flutter application demonstrating LiveKit integration for real-time video and audio communication.

## Features

- Connect to LiveKit rooms
- Video and audio streaming
- Camera and microphone controls
- Real-time participant management

## WebRTC NetworkMonitor Error

You may see log messages like this when disconnecting from a LiveKit room:

```
[android.net.ConnectivityManager.unregisterNetworkCallback(ConnectivityManager.java:5571)] 
[org.webrtc.NetworkMonitorAutoDetect$ConnectivityManagerDelegate.releaseCallback(NetworkMonitorAutoDetect.java:495)] 
[org.webrtc.NetworkMonitorAutoDetect.destroy(NetworkMonitorAutoDetect.java:742)] 
[org.webrtc.NetworkMonitor.stopMonitoring(NetworkMonitor.java:159)] 
[org.webrtc.NetworkMonitor.stopMonitoring(NetworkMonitor.java:168)]
```

**This is normal behavior** and indicates that WebRTC's NetworkMonitor is properly cleaning up network callbacks when the connection is closed. The application has been improved to handle this cleanup more gracefully:

### Improvements Made

1. **Proper Disconnect Sequence**: Local tracks are disabled before disconnecting the room
2. **Async Disconnect Handling**: All disconnect operations are now properly awaited
3. **Error Handling**: Comprehensive error handling for connection lifecycle
4. **Lifecycle Management**: Automatic cleanup when widgets are disposed
5. **Detailed Logging**: Better debugging information for connection states

### Connection Lifecycle

1. **Connect**: Room is created and connected with proper error handling
2. **Active**: Local tracks can be enabled/disabled during the session
3. **Disconnect**: 
   - Local tracks are disabled first
   - Room is disconnected
   - All resources are cleaned up
4. **Cleanup**: Widget dispose ensures proper cleanup even if disconnect fails

## Getting Started

1. Ensure you have Flutter installed
2. Run `flutter pub get` to install dependencies
3. Configure your LiveKit server details
4. Run the application

## Dependencies

- `livekit_client`: For LiveKit integration
- `provider`: For state management
- `permission_handler`: For device permissions
- `http`: For API calls
