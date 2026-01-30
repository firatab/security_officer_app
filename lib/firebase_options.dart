import 'package:firebase_core/firebase_core.dart';

const String _webApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
const String _webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
const String _webMessagingSenderId = String.fromEnvironment(
  'FIREBASE_WEB_MESSAGING_SENDER_ID',
);
const String _webProjectId = String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
const String _webAuthDomain = String.fromEnvironment(
  'FIREBASE_WEB_AUTH_DOMAIN',
);
const String _webStorageBucket = String.fromEnvironment(
  'FIREBASE_WEB_STORAGE_BUCKET',
);
const String _webMeasurementId = String.fromEnvironment(
  'FIREBASE_WEB_MEASUREMENT_ID',
);

class DefaultFirebaseOptions {
  // Cannot use const here because String.fromEnvironment values
  // cannot be checked with .isNotEmpty in const context
  static bool get hasWebConfig =>
      _webApiKey.isNotEmpty &&
      _webAppId.isNotEmpty &&
      _webMessagingSenderId.isNotEmpty &&
      _webProjectId.isNotEmpty;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _webApiKey,
    appId: _webAppId,
    messagingSenderId: _webMessagingSenderId,
    projectId: _webProjectId,
    authDomain: _webAuthDomain,
    storageBucket: _webStorageBucket,
    measurementId: _webMeasurementId,
  );

  // Default options for mobile platforms when environment variables are not set
  // These should be replaced with actual Firebase project values in production
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_ANDROID_API_KEY',
      defaultValue: 'demo-api-key',
    ),
    appId: String.fromEnvironment(
      'FIREBASE_ANDROID_APP_ID',
      defaultValue: 'demo-app-id',
    ),
    messagingSenderId: String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: 'demo-sender-id',
    ),
    projectId: String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'demo-project-id',
    ),
    storageBucket: String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'demo-bucket',
    ),
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_IOS_API_KEY',
      defaultValue: 'demo-api-key',
    ),
    appId: String.fromEnvironment(
      'FIREBASE_IOS_APP_ID',
      defaultValue: 'demo-app-id',
    ),
    messagingSenderId: String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: 'demo-sender-id',
    ),
    projectId: String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'demo-project-id',
    ),
    storageBucket: String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'demo-bucket',
    ),
    iosBundleId: String.fromEnvironment(
      'FIREBASE_IOS_BUNDLE_ID',
      defaultValue: 'com.example.securityOfficerApp',
    ),
  );

  // Get current platform options
  static FirebaseOptions get currentPlatform {
    // Firebase initialization will handle platform detection
    // This provides fallback values when environment variables are not set
    return const FirebaseOptions(
      apiKey: String.fromEnvironment(
        'FIREBASE_API_KEY',
        defaultValue: 'demo-api-key',
      ),
      appId: String.fromEnvironment(
        'FIREBASE_APP_ID',
        defaultValue: 'demo-app-id',
      ),
      messagingSenderId: String.fromEnvironment(
        'FIREBASE_MESSAGING_SENDER_ID',
        defaultValue: 'demo-sender-id',
      ),
      projectId: String.fromEnvironment(
        'FIREBASE_PROJECT_ID',
        defaultValue: 'demo-project-id',
      ),
      storageBucket: String.fromEnvironment(
        'FIREBASE_STORAGE_BUCKET',
        defaultValue: 'demo-bucket',
      ),
    );
  }
}
