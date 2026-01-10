part of '../app_database.dart';

@DriftAccessor(tables: [PatrolTours, PatrolTourPoints, PatrolTasks])
class PatrolToursDao extends DatabaseAccessor<AppDatabase>
    with _$PatrolToursDaoMixin {
  PatrolToursDao(super.db);

  /// Get all active patrol tours for a site
  Future<List<PatrolTour>> getToursForSite(String siteId) {
    return (select(patrolTours)
          ..where((t) => t.siteId.equals(siteId) & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Get a single patrol tour by ID
  Future<PatrolTour?> getTourById(String id) {
    return (select(patrolTours)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get all points for a tour ordered by sequence
  Future<List<PatrolTourPoint>> getPointsForTour(String tourId) {
    return (select(patrolTourPoints)
          ..where((p) =>
              p.patrolTourId.equals(tourId) & p.isActive.equals(true))
          ..orderBy([(p) => OrderingTerm.asc(p.sequenceNumber)]))
        .get();
  }

  /// Get a single point by ID
  Future<PatrolTourPoint?> getPointById(String pointId) {
    return (select(patrolTourPoints)..where((p) => p.id.equals(pointId)))
        .getSingleOrNull();
  }

  /// Get all tasks for a patrol point ordered by sort order
  Future<List<PatrolTask>> getTasksForPoint(String pointId) {
    return (select(patrolTasks)
          ..where((t) =>
              t.patrolPointId.equals(pointId) & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Insert or update a patrol tour
  Future<int> upsertTour(PatrolToursCompanion tour) {
    return into(patrolTours).insertOnConflictUpdate(tour);
  }

  /// Insert or update a patrol point
  Future<int> upsertPoint(PatrolTourPointsCompanion point) {
    return into(patrolTourPoints).insertOnConflictUpdate(point);
  }

  /// Insert or update a patrol task
  Future<int> upsertTask(PatrolTasksCompanion task) {
    return into(patrolTasks).insertOnConflictUpdate(task);
  }

  /// Save a full patrol tour with all its points and tasks
  Future<void> saveTourWithPointsAndTasks({
    required PatrolToursCompanion tour,
    required List<PatrolTourPointsCompanion> points,
    required Map<String, List<PatrolTasksCompanion>> tasksByPointId,
  }) async {
    await transaction(() async {
      await into(patrolTours).insertOnConflictUpdate(tour);

      for (final point in points) {
        await into(patrolTourPoints).insertOnConflictUpdate(point);

        final pointTasks = tasksByPointId[point.id.value] ?? [];
        for (final task in pointTasks) {
          await into(patrolTasks).insertOnConflictUpdate(task);
        }
      }
    });
  }

  /// Delete all patrol data for a site (for refresh)
  Future<void> clearToursForSite(String siteId) async {
    await transaction(() async {
      // Get all tour IDs for the site
      final tours = await (select(patrolTours)
            ..where((t) => t.siteId.equals(siteId)))
          .get();

      final tourIds = tours.map((t) => t.id).toList();

      if (tourIds.isNotEmpty) {
        // Get all point IDs for these tours
        final points = await (select(patrolTourPoints)
              ..where((p) => p.patrolTourId.isIn(tourIds)))
            .get();

        final pointIds = points.map((p) => p.id).toList();

        // Delete tasks for these points
        if (pointIds.isNotEmpty) {
          await (delete(patrolTasks)
                ..where((t) => t.patrolPointId.isIn(pointIds)))
              .go();
        }

        // Delete points for these tours
        await (delete(patrolTourPoints)
              ..where((p) => p.patrolTourId.isIn(tourIds)))
            .go();

        // Delete tours
        await (delete(patrolTours)..where((t) => t.siteId.equals(siteId))).go();
      }
    });
  }

  /// Get tour with all related data
  Future<Map<String, dynamic>?> getTourWithPointsAndTasks(String tourId) async {
    final tour = await getTourById(tourId);
    if (tour == null) return null;

    final points = await getPointsForTour(tourId);

    final pointsWithTasks = <Map<String, dynamic>>[];
    for (final point in points) {
      final tasks = await getTasksForPoint(point.id);
      pointsWithTasks.add({
        'point': point,
        'tasks': tasks,
      });
    }

    return {
      'tour': tour,
      'points': pointsWithTasks,
    };
  }
}
