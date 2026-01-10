import 'package:intl/intl.dart';

/// Timezone utility class for handling timezone conversions and formatting
class TimezoneUtils {
  /// Common timezone definitions with IANA identifiers
  static const Map<String, TimezoneInfo> timezones = {
    // Europe
    'Europe/London': TimezoneInfo(
      id: 'Europe/London',
      name: 'London',
      region: 'Europe',
      standardOffset: Duration.zero,
      dstOffset: Duration(hours: 1),
    ),
    'Europe/Paris': TimezoneInfo(
      id: 'Europe/Paris',
      name: 'Paris',
      region: 'Europe',
      standardOffset: Duration(hours: 1),
      dstOffset: Duration(hours: 2),
    ),
    'Europe/Berlin': TimezoneInfo(
      id: 'Europe/Berlin',
      name: 'Berlin',
      region: 'Europe',
      standardOffset: Duration(hours: 1),
      dstOffset: Duration(hours: 2),
    ),
    // Americas
    'America/New_York': TimezoneInfo(
      id: 'America/New_York',
      name: 'New York',
      region: 'Americas',
      standardOffset: Duration(hours: -5),
      dstOffset: Duration(hours: -4),
    ),
    'America/Chicago': TimezoneInfo(
      id: 'America/Chicago',
      name: 'Chicago',
      region: 'Americas',
      standardOffset: Duration(hours: -6),
      dstOffset: Duration(hours: -5),
    ),
    'America/Denver': TimezoneInfo(
      id: 'America/Denver',
      name: 'Denver',
      region: 'Americas',
      standardOffset: Duration(hours: -7),
      dstOffset: Duration(hours: -6),
    ),
    'America/Los_Angeles': TimezoneInfo(
      id: 'America/Los_Angeles',
      name: 'Los Angeles',
      region: 'Americas',
      standardOffset: Duration(hours: -8),
      dstOffset: Duration(hours: -7),
    ),
    // Asia Pacific
    'Asia/Dubai': TimezoneInfo(
      id: 'Asia/Dubai',
      name: 'Dubai',
      region: 'Asia',
      standardOffset: Duration(hours: 4),
      dstOffset: Duration(hours: 4),
    ),
    'Asia/Kolkata': TimezoneInfo(
      id: 'Asia/Kolkata',
      name: 'Mumbai/Delhi',
      region: 'Asia',
      standardOffset: Duration(hours: 5, minutes: 30),
      dstOffset: Duration(hours: 5, minutes: 30),
    ),
    'Asia/Singapore': TimezoneInfo(
      id: 'Asia/Singapore',
      name: 'Singapore',
      region: 'Asia',
      standardOffset: Duration(hours: 8),
      dstOffset: Duration(hours: 8),
    ),
    'Asia/Tokyo': TimezoneInfo(
      id: 'Asia/Tokyo',
      name: 'Tokyo',
      region: 'Asia',
      standardOffset: Duration(hours: 9),
      dstOffset: Duration(hours: 9),
    ),
    'Australia/Sydney': TimezoneInfo(
      id: 'Australia/Sydney',
      name: 'Sydney',
      region: 'Australia',
      standardOffset: Duration(hours: 10),
      dstOffset: Duration(hours: 11),
    ),
  };

  /// Default timezone (configurable per tenant)
  static String defaultTimezone = 'Europe/London';

  /// Get timezone info by ID
  static TimezoneInfo? getTimezoneInfo(String timezoneId) {
    return timezones[timezoneId];
  }

  /// Get the current offset for a timezone (accounting for DST)
  static Duration getTimezoneOffset(String timezoneId, [DateTime? date]) {
    final info = timezones[timezoneId];
    if (info == null) return Duration.zero;

    final checkDate = date ?? DateTime.now();

    // Simple DST check for Northern Hemisphere (approximate)
    // In production, use a proper timezone library like timezone package
    if (info.region == 'Europe' || info.region == 'Americas') {
      // DST typically runs from late March to late October
      if (checkDate.month > 3 && checkDate.month < 11) {
        return info.dstOffset;
      } else if (checkDate.month == 3 && checkDate.day >= 25) {
        return info.dstOffset;
      } else if (checkDate.month == 10 && checkDate.day < 25) {
        return info.dstOffset;
      }
    }

    return info.standardOffset;
  }

  /// Convert UTC datetime to local timezone
  static DateTime toTimezone(DateTime utcDateTime, String timezoneId) {
    final offset = getTimezoneOffset(timezoneId, utcDateTime);
    return utcDateTime.add(offset);
  }

  /// Convert local timezone datetime to UTC
  static DateTime toUtc(DateTime localDateTime, String timezoneId) {
    final offset = getTimezoneOffset(timezoneId, localDateTime);
    return localDateTime.subtract(offset);
  }

  /// Format datetime in a specific timezone
  static String formatInTimezone(
    DateTime utcDateTime,
    String timezoneId, {
    String format = 'dd MMM yyyy HH:mm',
    bool showTimezone = false,
  }) {
    final localDateTime = toTimezone(utcDateTime, timezoneId);
    final formatter = DateFormat(format);
    String formatted = formatter.format(localDateTime);

    if (showTimezone) {
      final info = timezones[timezoneId];
      final abbr = info?.abbreviation ?? timezoneId;
      formatted = '$formatted $abbr';
    }

    return formatted;
  }

  /// Format time only in a specific timezone
  static String formatTimeInTimezone(
    DateTime utcDateTime,
    String timezoneId, {
    bool use24Hour = true,
    bool showSeconds = false,
  }) {
    final format = use24Hour
        ? (showSeconds ? 'HH:mm:ss' : 'HH:mm')
        : (showSeconds ? 'h:mm:ss a' : 'h:mm a');
    return formatInTimezone(utcDateTime, timezoneId, format: format);
  }

  /// Format date only in a specific timezone
  static String formatDateInTimezone(
    DateTime utcDateTime,
    String timezoneId, {
    String format = 'dd MMM yyyy',
  }) {
    return formatInTimezone(utcDateTime, timezoneId, format: format);
  }

  /// Get formatted UTC offset string (e.g., "+05:30", "-08:00")
  static String formatUtcOffset(Duration offset) {
    final sign = offset.isNegative ? '-' : '+';
    final absOffset = offset.abs();
    final hours = absOffset.inHours.toString().padLeft(2, '0');
    final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');
    return '$sign$hours:$minutes';
  }

  /// Get the effective timezone for a context
  /// Falls back through: resource timezone -> site timezone -> tenant timezone -> default
  static String getEffectiveTimezone({
    String? resourceTimezone,
    String? siteTimezone,
    String? tenantTimezone,
  }) {
    return resourceTimezone ??
        siteTimezone ??
        tenantTimezone ??
        defaultTimezone;
  }

  /// Check if a timezone ID is valid
  static bool isValidTimezone(String timezoneId) {
    return timezones.containsKey(timezoneId);
  }

  /// Get all timezones grouped by region
  static Map<String, List<TimezoneInfo>> getTimezonesByRegion() {
    final grouped = <String, List<TimezoneInfo>>{};
    for (final tz in timezones.values) {
      grouped.putIfAbsent(tz.region, () => []).add(tz);
    }
    return grouped;
  }

  /// Get all timezones as a flat list
  static List<TimezoneInfo> getAllTimezones() {
    return timezones.values.toList();
  }

  /// Check if current time is within a time window in a specific timezone
  static bool isWithinTimeWindow({
    required String startTime,
    required String endTime,
    required String timezoneId,
    DateTime? checkTime,
  }) {
    final now = checkTime ?? DateTime.now().toUtc();
    final localNow = toTimezone(now, timezoneId);

    final currentMinutes = localNow.hour * 60 + localNow.minute;

    final startParts = startTime.split(':');
    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);

    final endParts = endTime.split(':');
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    // Handle overnight windows (e.g., 22:00 to 06:00)
    if (startMinutes > endMinutes) {
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  /// Calculate the time difference between two timezones
  static Duration getTimezoneDifference(
    String timezone1,
    String timezone2, [
    DateTime? date,
  ]) {
    final offset1 = getTimezoneOffset(timezone1, date);
    final offset2 = getTimezoneOffset(timezone2, date);
    return offset2 - offset1;
  }

  /// Get a human-readable description of the time difference
  static String getTimezoneDifferenceDescription(
    String timezone1,
    String timezone2, [
    DateTime? date,
  ]) {
    final diff = getTimezoneDifference(timezone1, timezone2, date);
    final hours = diff.inHours.abs();
    final minutes = (diff.inMinutes.abs() % 60);

    if (diff == Duration.zero) {
      return 'Same time';
    }

    final timeStr = minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';

    if (diff.isNegative) {
      return '$timeStr behind';
    } else {
      return '$timeStr ahead';
    }
  }
}

/// Timezone information class
class TimezoneInfo {
  final String id;
  final String name;
  final String region;
  final Duration standardOffset;
  final Duration dstOffset;

  const TimezoneInfo({
    required this.id,
    required this.name,
    required this.region,
    required this.standardOffset,
    required this.dstOffset,
  });

  /// Get the timezone abbreviation
  String get abbreviation {
    switch (id) {
      case 'Europe/London':
        return 'GMT';
      case 'Europe/Paris':
      case 'Europe/Berlin':
        return 'CET';
      case 'America/New_York':
        return 'EST';
      case 'America/Chicago':
        return 'CST';
      case 'America/Denver':
        return 'MST';
      case 'America/Los_Angeles':
        return 'PST';
      case 'Asia/Dubai':
        return 'GST';
      case 'Asia/Kolkata':
        return 'IST';
      case 'Asia/Singapore':
        return 'SGT';
      case 'Asia/Tokyo':
        return 'JST';
      case 'Australia/Sydney':
        return 'AEST';
      default:
        return id.split('/').last;
    }
  }

  /// Get formatted offset string
  String get offsetString {
    return TimezoneUtils.formatUtcOffset(standardOffset);
  }

  /// Get display label
  String get displayLabel => '$name ($abbreviation)';

  @override
  String toString() => displayLabel;
}

/// Extension on DateTime for timezone operations
extension DateTimeTimezoneExtension on DateTime {
  /// Convert this UTC datetime to a specific timezone
  DateTime toTimezone(String timezoneId) {
    return TimezoneUtils.toTimezone(toUtc(), timezoneId);
  }

  /// Format this datetime in a specific timezone
  String formatInTimezone(
    String timezoneId, {
    String format = 'dd MMM yyyy HH:mm',
    bool showTimezone = false,
  }) {
    return TimezoneUtils.formatInTimezone(
      toUtc(),
      timezoneId,
      format: format,
      showTimezone: showTimezone,
    );
  }
}
