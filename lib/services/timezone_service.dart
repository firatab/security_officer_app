import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/timezone_utils.dart';

/// Service for managing timezone settings
class TimezoneService extends ChangeNotifier {
  static const String _tenantTimezoneKey = 'tenant_timezone';
  static const String _userTimezoneKey = 'user_timezone';
  static const String _siteTimezoneKey = 'current_site_timezone';

  String _tenantTimezone = 'Europe/London';
  String? _userTimezone;
  String? _siteTimezone;
  bool _initialized = false;

  /// Get the tenant's default timezone
  String get tenantTimezone => _tenantTimezone;

  /// Get the user's preferred timezone (may be null to use tenant default)
  String? get userTimezone => _userTimezone;

  /// Get the current site's timezone (may be null to use tenant default)
  String? get siteTimezone => _siteTimezone;

  /// Get the effective timezone for display
  /// Priority: site > user > tenant
  String get effectiveTimezone {
    return TimezoneUtils.getEffectiveTimezone(
      siteTimezone: _siteTimezone,
      resourceTimezone: _userTimezone,
      tenantTimezone: _tenantTimezone,
    );
  }

  /// Check if service is initialized
  bool get isInitialized => _initialized;

  /// Initialize the timezone service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      _tenantTimezone =
          prefs.getString(_tenantTimezoneKey) ?? 'Europe/London';
      _userTimezone = prefs.getString(_userTimezoneKey);
      _siteTimezone = prefs.getString(_siteTimezoneKey);

      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize timezone service: $e');
      _initialized = true;
    }
  }

  /// Set the tenant timezone
  Future<void> setTenantTimezone(String timezone) async {
    if (!TimezoneUtils.isValidTimezone(timezone)) {
      throw ArgumentError('Invalid timezone: $timezone');
    }

    _tenantTimezone = timezone;
    TimezoneUtils.defaultTimezone = timezone;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tenantTimezoneKey, timezone);
    } catch (e) {
      debugPrint('Failed to save tenant timezone: $e');
    }

    notifyListeners();
  }

  /// Set the user's preferred timezone
  Future<void> setUserTimezone(String? timezone) async {
    if (timezone != null && !TimezoneUtils.isValidTimezone(timezone)) {
      throw ArgumentError('Invalid timezone: $timezone');
    }

    _userTimezone = timezone;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (timezone != null) {
        await prefs.setString(_userTimezoneKey, timezone);
      } else {
        await prefs.remove(_userTimezoneKey);
      }
    } catch (e) {
      debugPrint('Failed to save user timezone: $e');
    }

    notifyListeners();
  }

  /// Set the current site timezone
  Future<void> setSiteTimezone(String? timezone) async {
    if (timezone != null && !TimezoneUtils.isValidTimezone(timezone)) {
      throw ArgumentError('Invalid timezone: $timezone');
    }

    _siteTimezone = timezone;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (timezone != null) {
        await prefs.setString(_siteTimezoneKey, timezone);
      } else {
        await prefs.remove(_siteTimezoneKey);
      }
    } catch (e) {
      debugPrint('Failed to save site timezone: $e');
    }

    notifyListeners();
  }

  /// Clear site timezone (when user changes site or logs out)
  Future<void> clearSiteTimezone() async {
    await setSiteTimezone(null);
  }

  /// Clear all timezone settings (for logout)
  Future<void> clearAll() async {
    _tenantTimezone = 'Europe/London';
    _userTimezone = null;
    _siteTimezone = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tenantTimezoneKey);
      await prefs.remove(_userTimezoneKey);
      await prefs.remove(_siteTimezoneKey);
    } catch (e) {
      debugPrint('Failed to clear timezone settings: $e');
    }

    notifyListeners();
  }

  /// Format a UTC datetime in the effective timezone
  String formatDateTime(
    DateTime utcDateTime, {
    String format = 'dd MMM yyyy HH:mm',
    bool showTimezone = false,
  }) {
    return TimezoneUtils.formatInTimezone(
      utcDateTime,
      effectiveTimezone,
      format: format,
      showTimezone: showTimezone,
    );
  }

  /// Format time only in the effective timezone
  String formatTime(
    DateTime utcDateTime, {
    bool use24Hour = true,
    bool showSeconds = false,
  }) {
    return TimezoneUtils.formatTimeInTimezone(
      utcDateTime,
      effectiveTimezone,
      use24Hour: use24Hour,
      showSeconds: showSeconds,
    );
  }

  /// Format date only in the effective timezone
  String formatDate(
    DateTime utcDateTime, {
    String format = 'dd MMM yyyy',
  }) {
    return TimezoneUtils.formatDateInTimezone(
      utcDateTime,
      effectiveTimezone,
      format: format,
    );
  }

  /// Convert UTC datetime to effective timezone
  DateTime toLocalTimezone(DateTime utcDateTime) {
    return TimezoneUtils.toTimezone(utcDateTime, effectiveTimezone);
  }

  /// Convert local timezone datetime to UTC
  DateTime toUtc(DateTime localDateTime) {
    return TimezoneUtils.toUtc(localDateTime, effectiveTimezone);
  }

  /// Get timezone info for the effective timezone
  TimezoneInfo? get effectiveTimezoneInfo {
    return TimezoneUtils.getTimezoneInfo(effectiveTimezone);
  }

  /// Get current time in effective timezone as formatted string
  String get currentTimeFormatted {
    return formatTime(DateTime.now().toUtc());
  }

  /// Get current date in effective timezone as formatted string
  String get currentDateFormatted {
    return formatDate(DateTime.now().toUtc());
  }

  /// Check if current time is within a time window in the effective timezone
  bool isWithinTimeWindow({
    required String startTime,
    required String endTime,
  }) {
    return TimezoneUtils.isWithinTimeWindow(
      startTime: startTime,
      endTime: endTime,
      timezoneId: effectiveTimezone,
    );
  }

  /// Get the UTC offset for the effective timezone
  Duration get currentUtcOffset {
    return TimezoneUtils.getTimezoneOffset(effectiveTimezone);
  }

  /// Get the UTC offset as a formatted string
  String get currentUtcOffsetString {
    return TimezoneUtils.formatUtcOffset(currentUtcOffset);
  }

  /// Update settings from server response
  Future<void> updateFromServer({
    String? tenantTimezone,
    String? userTimezone,
    String? siteTimezone,
  }) async {
    if (tenantTimezone != null &&
        TimezoneUtils.isValidTimezone(tenantTimezone)) {
      await setTenantTimezone(tenantTimezone);
    }

    if (userTimezone != null && TimezoneUtils.isValidTimezone(userTimezone)) {
      await setUserTimezone(userTimezone);
    } else if (userTimezone == null) {
      await setUserTimezone(null);
    }

    if (siteTimezone != null && TimezoneUtils.isValidTimezone(siteTimezone)) {
      await setSiteTimezone(siteTimezone);
    }
  }
}
