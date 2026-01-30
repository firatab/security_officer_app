import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import 'websocket_service.dart';

/// Outbox Publishing Service
/// Publishes pending outbox events to WebSocket when connected
class OutboxPublishingService {
  final AppDatabase _database;
  final WebSocketController _webSocket;
  final _uuid = const Uuid();

  Timer? _publishTimer;
  bool _isPublishing = false;

  static const Duration publishInterval = Duration(seconds: 5);
  static const int maxRetries = 5;

  OutboxPublishingService(this._database, this._webSocket);

  /// Start the publishing service
  void start() {
    stop(); // Stop any existing timer

    // Publish immediately
    _publishPendingEvents();

    // Set up periodic publishing
    _publishTimer = Timer.periodic(publishInterval, (_) {
      _publishPendingEvents();
    });

    AppLogger.info('Outbox publishing service started');
  }

  /// Stop the publishing service
  void stop() {
    _publishTimer?.cancel();
    _publishTimer = null;
    AppLogger.info('Outbox publishing service stopped');
  }

  /// Publish pending events
  Future<void> _publishPendingEvents() async {
    if (_isPublishing) return;
    if (!_webSocket.isConnected) {
      // Try to process retry events even when not connected
      await _processRetryEvents();
      return;
    }

    _isPublishing = true;

    try {
      // Get pending events
      final pendingEvents = await _database.outboxDao.getPendingEvents(
        limit: 50,
      );

      for (final event in pendingEvents) {
        try {
          // Publish to WebSocket
          _webSocket.emit(event.type, jsonDecode(event.payloadJson));

          // Mark as published
          await _database.outboxDao.markAsPublished(event.eventId);
          AppLogger.debug('Published outbox event: ${event.type}');
        } catch (e) {
          // Mark as failed with retry
          await _database.outboxDao.markAsFailed(
            event.eventId,
            e.toString(),
            retryCount: event.retryCount,
          );
          AppLogger.error('Failed to publish outbox event: ${event.type}', e);
        }
      }

      // Process events ready for retry
      await _processRetryEvents();

      // Cleanup old published events (older than 7 days)
      await _database.outboxDao.deletePublishedOlderThan(
        const Duration(days: 7),
      );
    } catch (e) {
      AppLogger.error('Error publishing outbox events', e);
    } finally {
      _isPublishing = false;
    }
  }

  /// Process events that are ready for retry
  Future<void> _processRetryEvents() async {
    if (!_webSocket.isConnected) return;

    try {
      final retryEvents = await _database.outboxDao.getEventsReadyForRetry(
        limit: 20,
      );

      for (final event in retryEvents) {
        // Skip if max retries exceeded
        if (event.retryCount >= maxRetries) {
          AppLogger.warning('Max retries exceeded for event: ${event.eventId}');
          continue;
        }

        try {
          // Retry publishing
          _webSocket.emit(event.type, jsonDecode(event.payloadJson));

          // Mark as published
          await _database.outboxDao.markAsPublished(event.eventId);
          AppLogger.info('Retry successful for event: ${event.type}');
        } catch (e) {
          // Increment retry count
          await _database.outboxDao.markAsFailed(
            event.eventId,
            e.toString(),
            retryCount: event.retryCount,
          );
          AppLogger.error('Retry failed for event: ${event.type}', e);
        }
      }
    } catch (e) {
      AppLogger.error('Error processing retry events', e);
    }
  }

  /// Add an event to the outbox
  Future<void> addEvent({
    required String tenantId,
    required String type,
    String? entityType,
    String? entityId,
    required Map<String, dynamic> payload,
  }) async {
    final eventId = _uuid.v4();

    await _database.outboxDao.addEvent(
      eventId: eventId,
      tenantId: tenantId,
      type: type,
      entityType: entityType,
      entityId: entityId,
      payload: payload,
    );

    AppLogger.debug('Added event to outbox: $type');

    // Try to publish immediately if connected
    if (_webSocket.isConnected) {
      _publishPendingEvents();
    }
  }

  /// Get outbox status
  Future<OutboxStatus> getStatus() async {
    final pendingCount = await _database.outboxDao.getPendingCount();
    final failedCount = await _database.outboxDao.getFailedCount();

    return OutboxStatus(
      pendingCount: pendingCount,
      failedCount: failedCount,
      isConnected: _webSocket.isConnected,
      isPublishing: _isPublishing,
    );
  }

  void dispose() {
    stop();
  }
}

/// Outbox status
class OutboxStatus {
  final int pendingCount;
  final int failedCount;
  final bool isConnected;
  final bool isPublishing;

  OutboxStatus({
    required this.pendingCount,
    required this.failedCount,
    required this.isConnected,
    required this.isPublishing,
  });

  bool get hasPending => pendingCount > 0;
  bool get hasFailed => failedCount > 0;
  int get totalPending => pendingCount + failedCount;
}
