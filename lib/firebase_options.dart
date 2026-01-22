import 'package:firebase_core/firebase_core.dart';

const String _webApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
const String _webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
const String _webMessagingSenderId =
    String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID');
const String _webProjectId = String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
const String _webAuthDomain = String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
const String _webStorageBucket =
    String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET');
const String _webMeasurementId =
    String.fromEnvironment('FIREBASE_WEB_MEASUREMENT_ID');

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
}
