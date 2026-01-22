# Security Officer Mobile App

A Flutter mobile application for security officers to manage shifts, track attendance, respond to check calls, and navigate to work sites with offline support and GPS tracking.

## Features

- **Authentication**: Secure login with JWT token authentication
- **Shift Management**: View assigned shifts with client and site details
- **Book On/Off**: Clock in/out with geolocation verification
- **Google Maps Integration**: Navigate to work sites
- **Check Calls**: Automated check call notifications with background service
- **GPS Tracking**: Location tracking every 15 seconds during shifts
- **Offline Support**: Full offline capability after initial login
- **Real-time Updates**: WebSocket integration for live data sync
- **Background Services**: Continue tracking even when app is closed

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode
- Google Maps API Key

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd security_officer_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

Run build_runner to generate database and model code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Configure API Endpoints

Update the base URL in `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'https://your-api-domain.com';
static const String wsUrl = 'wss://your-api-domain.com';
```

### 5. Configure Google Maps API Key

#### Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_GOOGLE_MAPS_API_KEY_HERE" />
```

#### iOS

Edit `ios/Runner/Info.plist`:

```xml
<key>GMSApiKey</key>
<string>YOUR_ACTUAL_GOOGLE_MAPS_API_KEY_HERE</string>
```

Get your API key from: https://console.cloud.google.com/google/maps-apis/

## Platform-Specific Setup

### Android Setup

1. **Minimum SDK**: The app requires Android API level 23 (Android 6.0) or higher
2. **Permissions**: All required permissions are configured in `AndroidManifest.xml`
3. **Google Play Services**: Required for location and maps

### iOS Setup

1. **Minimum iOS Version**: iOS 12.0+
2. **Background Modes**: Location, fetch, and remote notifications are enabled
3. **Privacy Descriptions**: Location permission descriptions are in `Info.plist`

## Running the App

### Development

```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor/mode
flutter run --debug
flutter run --release
```

### Build for Production

#### Android APK

```bash
flutter build apk --release
```

#### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

#### iOS

```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # Constants and API endpoints
│   ├── errors/          # Custom exceptions
│   ├── network/         # Dio client and network setup
│   └── utils/           # Utility functions and logger
├── data/
│   ├── database/        # Drift database (offline storage)
│   ├── models/          # Data models with JSON serialization
│   └── repositories/    # Data repositories
├── domain/
│   ├── entities/        # Business entities
│   └── repositories/    # Repository interfaces
├── presentation/
│   ├── screens/         # UI screens
│   │   ├── auth/        # Login screen
│   │   ├── home/        # Home dashboard
│   │   ├── shifts/      # Shift management
│   │   ├── map/         # Google Maps navigation
│   │   └── check_calls/ # Check call responses
│   └── widgets/         # Reusable widgets
├── services/            # Background services, auth, location, etc.
└── main.dart            # App entry point
```

## Key Technologies

- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **HTTP Client**: Dio
- **WebSocket**: web_socket_channel
- **Location**: Geolocator
- **Maps**: Google Maps Flutter
- **Background Work**: WorkManager, flutter_background_service
- **Notifications**: flutter_local_notifications

## Database Schema

The app uses Drift for local SQLite database with these tables:

- **Shifts**: Offline shift data with site and client info
- **Attendances**: Book on/off records with sync status
- **LocationLogs**: GPS tracking data (every 15 seconds)
- **CheckCalls**: Check call responses and history
- **SyncQueue**: Pending operations for offline sync

## Configuration

### Environment Variables

The app uses the following secure storage keys (handled automatically):

- `access_token`: JWT access token
- `refresh_token`: JWT refresh token
- `user_id`: Current user ID
- `employee_id`: Current employee ID
- `tenant_id`: Current tenant ID

### App Constants

Edit `lib/core/constants/app_constants.dart` to configure:

- API base URL and WebSocket URL
- Location update interval (default: 15 seconds)
- Geofence radius (default: 100 meters)
- Sync retry settings
- Notification channel IDs

## Features Implementation Status

### Phase 1: Foundation ✅ COMPLETED
- [x] Project setup and configuration
- [x] Dependencies installation
- [x] Folder structure
- [x] Drift database setup
- [x] Riverpod providers configuration
- [x] Authentication service
- [x] Login screen
- [x] Android/iOS permissions

### Phase 2: Shifts & Attendance (Next Steps)
- [ ] Shifts API integration
- [ ] Shift list screen
- [ ] Shift detail screen
- [ ] Book on/off functionality
- [ ] Geolocation verification

### Phase 3: Google Maps
- [ ] Maps integration
- [ ] Site location display
- [ ] Navigation to site

### Phase 4: Background Services
- [ ] GPS tracking service (15s interval)
- [ ] Location data sync
- [ ] Background task scheduling

### Phase 5: Check Calls
- [ ] Check call scheduling
- [ ] Full-screen notification
- [ ] Check call response logging

### Phase 6: Offline Sync
- [ ] Sync queue implementation
- [ ] Conflict resolution
- [ ] Retry mechanism

### Phase 7: Testing & Polish
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] Performance optimization

## Troubleshooting

### Build Errors

If you encounter build errors:

1. Clean the project:
   ```bash
   flutter clean
   flutter pub get
   ```

2. Regenerate code:
   ```bash
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Check Flutter and Dart versions:
   ```bash
   flutter doctor -v
   ```

### Location Permissions

If location permissions aren't working:

- **Android**: Ensure all permissions in `AndroidManifest.xml` are present
- **iOS**: Check privacy descriptions in `Info.plist`
- **Both**: Test on a real device (emulators have limited location support)

### Background Services Not Running

- **Android**: Check battery optimization settings
- **iOS**: Verify background modes are enabled in Xcode

## API Requirements

The mobile app expects these API endpoints to be available:

- `POST /api/auth/login` - User authentication
- `POST /api/auth/logout` - Logout
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/employees/me/shifts` - Get employee shifts
- `POST /api/attendance/book-on` - Clock in
- `POST /api/attendance/book-off` - Clock out
- `POST /api/location/bulk` - Upload GPS locations (bulk)
- `POST /api/check-calls` - Record check call response
- `GET /api/mobile/notifications` - Get mobile notifications (background polling)

## Security Considerations

- **Tokens**: Stored securely using flutter_secure_storage
- **HTTPS**: Always use HTTPS in production (update NSAppTransportSecurity for iOS)
- **API Keys**: Never commit Google Maps API keys to version control
- **Permissions**: Request only necessary permissions
- **Data**: Sensitive data is encrypted at rest

## License

[Your License Here]

## Support

For issues or questions, contact: [Your Support Email]
