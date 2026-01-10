/// API endpoint constants
class ApiEndpoints {
  // Authentication
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String refreshToken = '/api/auth/refresh';

  // Employee
  static const String employeeProfile = '/api/employees/me';
  static const String employeeShifts = '/api/employees/me/shifts';

  // Attendance
  static const String bookOn = '/api/attendance/book-on';
  static const String bookOff = '/api/attendance/book-off';

  // Location
  static const String bulkLocation = '/api/location/bulk';

  // Check Calls
  static const String checkCalls = '/api/check-calls';
  static String checkCallRespond(String id) => '/api/check-calls/$id/respond';
  static String checkCallMissed(String id) => '/api/check-calls/$id/missed';
  static String checkCallsForShift(String shiftId) => '/api/shifts/$shiftId/check-calls';

  // Incident Reports
  static const String incidentReports = '/api/incidents';

  // Emergency
  static const String panicAlert = '/api/emergency/panic';

  // Patrols (Legacy)
  static const String patrols = '/api/patrols';
  static String patrolCheckpoints(String patrolId) => '/api/patrols/$patrolId/checkpoints';
  static String logCheckpoint(String checkpointId) => '/api/patrols/checkpoints/$checkpointId/scan';

  // Patrol Tours
  static const String patrolTours = '/api/patrol/tours';
  static String patrolTourDetails(String id) => '/api/patrol/tours/$id';
  static String patrolTourPoints(String tourId) => '/api/patrol/tours/$tourId/points';

  // Patrol Schedules
  static const String patrolSchedules = '/api/patrol/schedules';
  static String patrolScheduleDetails(String id) => '/api/patrol/schedules/$id';

  // Patrol Instances
  static const String patrolInstances = '/api/patrol/instances';
  static String patrolInstanceDetails(String id) => '/api/patrol/instances/$id';
  static String completePatrolPoint(String instanceId, String pointId) =>
      '/api/patrol/instances/$instanceId/points/$pointId';


  // Notifications
  static const String notifications = '/api/notifications';
  static String markNotificationRead(String id) => '/api/notifications/$id/read';

  // Push Notifications / FCM Token
  static const String registerFcmToken = '/api/notifications/push-token';
  static const String unregisterFcmToken = '/api/notifications/push-token';

  // Sites
  static const String sites = '/api/sites';
  static String siteDetails(String id) => '/api/sites/$id';
  static String sitePatrols(String siteId) => '/api/sites/$siteId/patrols';
}
