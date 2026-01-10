import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a testable widget wrapped with necessary providers
Widget createTestableWidget(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Creates a testable widget with custom provider overrides
Widget createTestableWidgetWithOverrides(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Mock location data for testing
class MockLocationData {
  static const double testLatitude = 51.5074;
  static const double testLongitude = -0.1278;
  static const double testAccuracy = 10.0;
}

/// Mock shift data for testing
class MockShiftData {
  static const String testShiftId = 'test-shift-001';
  static const String testEmployeeId = 'emp-001';
  static const String testTenantId = 'tenant-001';
  static const String testSiteId = 'site-001';
  static const String testSiteName = 'Test Security Site';
  static const String testClientName = 'Test Client';
  static const String testSiteAddress = '123 Test Street, London';
}

/// Extension for common test operations
extension WidgetTesterExtensions on WidgetTester {
  /// Pump and settle with a timeout
  Future<void> pumpAndSettleWithTimeout({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }

  /// Find widget by key and tap
  Future<void> tapByKey(Key key) async {
    await tap(find.byKey(key));
    await pump();
  }

  /// Enter text in a text field by key
  Future<void> enterTextByKey(Key key, String text) async {
    await enterText(find.byKey(key), text);
    await pump();
  }
}
