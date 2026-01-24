import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/logger.dart';

/// Service to prevent duplicate notifications from being shown
/// Tracks which notifications have been shown using SharedPreferences
class NotificationDedupService {
  static const String _keyPrefix = 'notif_shown_';
  static const Duration _ttl = Duration(days: 7); // Keep for 7 days
  
  static final NotificationDedupService _instance = NotificationDedupService._internal();
  factory NotificationDedupService() => _instance;
  NotificationDedupService._internal();

  /// Check if a notification has already been shown
  /// Returns true if notification should be shown (not a duplicate)
  /// Returns false if notification has already been shown (is duplicate)
  Future<bool> shouldShowNotification(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$notificationId';
      
      // Check if we've shown this notification before
      final shownTimestamp = prefs.getInt(key);
      
      if (shownTimestamp != null) {
        final shownAt = DateTime.fromMillisecondsSinceEpoch(shownTimestamp);
        final age = DateTime.now().difference(shownAt);
        
        if (age < _ttl) {
          // Notification was shown recently, skip it
          AppLogger.debug('Skipping duplicate notification: $notificationId (shown ${age.inMinutes} minutes ago)');
          return false;
        } else {
          // TTL expired, allow showing again and clean up old entry
          await prefs.remove(key);
        }
      }
      
      // New notification, mark it as shown
      await _markAsShown(notificationId);
      return true;
    } catch (e) {
      AppLogger.error('Error checking notification dedup', e);
      // On error, allow notification to be shown (fail open)
      return true;
    }
  }

  /// Mark a notification as shown
  Future<void> _markAsShown(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$notificationId';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(key, timestamp);
      AppLogger.debug('Marked notification as shown: $notificationId');
    } catch (e) {
      AppLogger.error('Error marking notification as shown', e);
    }
  }

  /// Clean up old notification tracking data (call periodically)
  Future<void> cleanupOldEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
      final now = DateTime.now().millisecondsSinceEpoch;
      
      int cleaned = 0;
      for (final key in keys) {
        final timestamp = prefs.getInt(key);
        if (timestamp != null) {
          final age = now - timestamp;
          if (age > _ttl.inMilliseconds) {
            await prefs.remove(key);
            cleaned++;
          }
        }
      }
      
      if (cleaned > 0) {
        AppLogger.info('Cleaned up $cleaned old notification entries');
      }
    } catch (e) {
      AppLogger.error('Error cleaning up notification entries', e);
    }
  }

  /// Get unique notification ID from various sources
  static String getNotificationId(Map<String, dynamic> data) {
    // Try to extract ID from common fields
    if (data.containsKey('id')) {
      return data['id'].toString();
    }
    if (data.containsKey('notificationId')) {
      return data['notificationId'].toString();
    }
    if (data.containsKey('shiftId')) {
      return 'shift_${data['shiftId']}';
    }
    if (data.containsKey('checkCallId')) {
      return 'check_call_${data['checkCallId']}';
    }
    
    // Fallback: create hash from title + body + type
    final title = data['title'] ?? '';
    final body = data['body'] ?? '';
    final type = data['type'] ?? '';
    return '$type:$title:$body'.hashCode.abs().toString();
  }
}
