/// GraphQL Operations for AppSync Real-Time
///
/// These match the schema defined in the Amplify backend.

class GraphQLOperations {
  GraphQLOperations._();

  // ============================================================================
  // SUBSCRIPTIONS
  // ============================================================================

  /// Subscribe to attendance events for a tenant
  static const String onAttendanceEvent = r'''
    subscription OnAttendanceEvent($tenantId: String!, $siteId: String, $employeeId: String) {
      onAttendanceEvent(tenantId: $tenantId, siteId: $siteId, employeeId: $employeeId) {
        id
        tenantId
        eventId
        eventType
        version
        createdAt
        correlationId
        attendanceId
        shiftId
        siteId
        employeeId
        employeeName
        siteName
        attendanceEventType
        status
        timestamp
        location {
          latitude
          longitude
          accuracy
        }
        bookOnMethod
        bookOffMethod
        isLate
        lateMinutes
        notes
        alertMessage
        alertSeverity
      }
    }
  ''';

  /// Subscribe to shift events
  static const String onShiftEvent = r'''
    subscription OnShiftEvent($tenantId: String!, $siteId: String, $employeeId: String) {
      onShiftEvent(tenantId: $tenantId, siteId: $siteId, employeeId: $employeeId) {
        id
        tenantId
        eventId
        eventType
        version
        createdAt
        correlationId
        shiftId
        siteId
        siteName
        employeeId
        employeeName
        shiftEventType
        shiftDate
        startTime
        endTime
        shiftType
        jobType
        status
        notes
        changes
      }
    }
  ''';

  /// Subscribe to incident events
  static const String onIncidentEvent = r'''
    subscription OnIncidentEvent($tenantId: String!, $siteId: String) {
      onIncidentEvent(tenantId: $tenantId, siteId: $siteId) {
        id
        tenantId
        eventId
        eventType
        version
        createdAt
        correlationId
        incidentId
        siteId
        siteName
        reportedBy
        reportedByName
        incidentEventType
        incidentType
        severity
        title
        description
        location
        status
        actionTaken
        policeNotified
        policeRef
      }
    }
  ''';

  /// Subscribe to panic/safety events - CRITICAL
  static const String onPanicEvent = r'''
    subscription OnPanicEvent($tenantId: String!) {
      onPanicEvent(tenantId: $tenantId) {
        id
        tenantId
        eventId
        eventType
        version
        createdAt
        correlationId
        employeeId
        employeeName
        siteId
        siteName
        shiftId
        panicEventType
        location {
          latitude
          longitude
          accuracy
        }
        message
        acknowledgedBy
        acknowledgedAt
        resolvedBy
        resolvedAt
        resolution
      }
    }
  ''';

  /// Subscribe to check call events
  static const String onCheckCallEvent = r'''
    subscription OnCheckCallEvent($tenantId: String!, $siteId: String, $employeeId: String) {
      onCheckCallEvent(tenantId: $tenantId, siteId: $siteId, employeeId: $employeeId) {
        id
        tenantId
        eventId
        eventType
        version
        createdAt
        correlationId
        checkCallId
        scheduleId
        shiftId
        siteId
        siteName
        employeeId
        employeeName
        checkCallEventType
        scheduledTime
        checkTime
        status
        escalationLevel
        location {
          latitude
          longitude
          accuracy
        }
        notes
      }
    }
  ''';

  // ============================================================================
  // MUTATIONS
  // ============================================================================

  /// Publish attendance event
  static const String publishAttendanceEvent = r'''
    mutation PublishAttendanceEvent($input: PublishAttendanceEventInput!) {
      publishAttendanceEvent(input: $input) {
        id
        eventId
        tenantId
        attendanceEventType
        status
      }
    }
  ''';

  /// Publish shift event
  static const String publishShiftEvent = r'''
    mutation PublishShiftEvent($input: PublishShiftEventInput!) {
      publishShiftEvent(input: $input) {
        id
        eventId
        tenantId
        shiftEventType
      }
    }
  ''';

  /// Publish incident event
  static const String publishIncidentEvent = r'''
    mutation PublishIncidentEvent($input: PublishIncidentEventInput!) {
      publishIncidentEvent(input: $input) {
        id
        eventId
        tenantId
        incidentEventType
      }
    }
  ''';

  /// Publish panic event
  static const String publishPanicEvent = r'''
    mutation PublishPanicEvent($input: PublishPanicEventInput!) {
      publishPanicEvent(input: $input) {
        id
        eventId
        tenantId
        panicEventType
      }
    }
  ''';

  /// Publish check call event
  static const String publishCheckCallEvent = r'''
    mutation PublishCheckCallEvent($input: PublishCheckCallEventInput!) {
      publishCheckCallEvent(input: $input) {
        id
        eventId
        tenantId
        checkCallEventType
      }
    }
  ''';

  // ============================================================================
  // QUERIES
  // ============================================================================

  /// Health check query
  static const String healthCheck = r'''
    query HealthCheck {
      healthCheck
    }
  ''';
}
