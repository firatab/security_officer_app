part of '../app_database.dart';

@DriftAccessor(tables: [InAppNotifications])
class InAppNotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$InAppNotificationsDaoMixin {
  InAppNotificationsDao(super.db);

  /// Get all notifications (ordered by newest first)
  Future<List<InAppNotification>> getAllNotifications() async {
    return (select(inAppNotifications)..orderBy([
          (t) =>
              OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  /// Watch all notifications as a stream
  Stream<List<InAppNotification>> watchAllNotifications() {
    return (select(inAppNotifications)..orderBy([
          (t) =>
              OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  /// Get notifications by type
  Future<List<InAppNotification>> getNotificationsByType(String type) async {
    return (select(inAppNotifications)
          ..where((t) => t.type.equals(type))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Watch notifications by type
  Stream<List<InAppNotification>> watchNotificationsByType(String type) {
    return (select(inAppNotifications)
          ..where((t) => t.type.equals(type))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final query = selectOnly(inAppNotifications)
      ..addColumns([inAppNotifications.id.count()])
      ..where(inAppNotifications.isRead.equals(false));

    final result = await query.getSingle();
    return result.read(inAppNotifications.id.count()) ?? 0;
  }

  /// Watch unread count as a stream
  Stream<int> watchUnreadCount() {
    final query = selectOnly(inAppNotifications)
      ..addColumns([inAppNotifications.id.count()])
      ..where(inAppNotifications.isRead.equals(false));

    return query
        .map((row) => row.read(inAppNotifications.id.count()) ?? 0)
        .watchSingle();
  }

  /// Mark notification as read
  Future<void> markAsRead(String id) async {
    await (update(inAppNotifications)..where((t) => t.id.equals(id))).write(
      InAppNotificationsCompanion(
        isRead: Value(true),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await update(inAppNotifications).write(
      InAppNotificationsCompanion(
        isRead: Value(true),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete notification
  Future<void> deleteNotification(String id) async {
    await (delete(inAppNotifications)..where((t) => t.id.equals(id))).go();
  }

  /// Clear all read notifications
  Future<void> clearReadNotifications() async {
    await (delete(
      inAppNotifications,
    )..where((t) => t.isRead.equals(true))).go();
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await delete(inAppNotifications).go();
  }

  /// Insert notification
  Future<void> insertNotification(
    InAppNotificationsCompanion notification,
  ) async {
    await into(
      inAppNotifications,
    ).insert(notification, mode: InsertMode.insertOrReplace);
  }

  /// Batch insert notifications
  Future<void> insertNotifications(
    List<InAppNotificationsCompanion> notifications,
  ) async {
    await batch((batch) {
      batch.insertAll(
        inAppNotifications,
        notifications,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Delete old notifications (older than specified days)
  Future<void> deleteOldNotifications({int daysToKeep = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    await (delete(
      inAppNotifications,
    )..where((t) => t.receivedAt.isSmallerThanValue(cutoffDate))).go();
  }

  /// Get notification by ID
  Future<InAppNotification?> getNotificationById(String id) async {
    return (select(
      inAppNotifications,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
