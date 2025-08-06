# LiveKit Testing Guide - Two Device Connection

## How to Test with Two Devices

### Step 1: Prepare Two Devices
- Install your Flutter app on two devices (phone + phone, or phone + simulator)
- Make sure both devices have internet connection

### Step 2: Join the Same Room
**On Device 1:**
- Enter your name: `John`
- Enter room name: `meeting-123`
- Click "Join Room"

**On Device 2:**
- Enter your name: `Alice`
- Enter room name: `meeting-123` (SAME room name!)
- Click "Join Room"

### Step 3: Verify Connection
Both devices should:
- Connect to the same room
- See each other's video/audio
- Display the correct participant names (John and Alice)

## Troubleshooting

### If devices don't see each other:
1. **Check room name**: Must be exactly the same on both devices
2. **Check participant names**: Must be different on each device
3. **Check internet**: Both devices need internet connection
4. **Check permissions**: Allow camera and microphone permissions

### If you see random names instead of your names:
- This is normal with the sandbox API
- The important thing is that both devices connect to the same room
- You can still communicate even with random names

## Expected Behavior

✅ **Success:**
- Both devices connect to the same room
- You can see and hear each other
- Room name is the same on both devices
- Participant names are different on each device

❌ **Failure:**
- Devices don't see each other
- Connection errors
- Same participant name on both devices

## Testing Scenarios

### Scenario 1: Basic Connection
- Device 1: John + meeting-123
- Device 2: Alice + meeting-123
- Expected: Both connect and see each other

### Scenario 2: Different Rooms
- Device 1: John + room-a
- Device 2: Alice + room-b
- Expected: Devices don't see each other (different rooms)

### Scenario 3: Same Names
- Device 1: John + meeting-123
- Device 2: John + meeting-123
- Expected: May cause issues (same participant name)

## Notes

- The sandbox API may return random participant names, but the connection will still work
- Room names are case-sensitive
- Participant names should be unique within the same room
- The connection uses WebRTC, so both devices need good internet 