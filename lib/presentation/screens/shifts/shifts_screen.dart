import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/logger.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';
import '../../../services/websocket_service.dart';
import '../../widgets/offline_status_banner.dart';
import 'shift_detail_screen.dart';

// State providers for shifts screen
final shiftsProvider = StateNotifierProvider<ShiftsNotifier, ShiftsState>((ref) {
  final repository = ref.watch(shiftRepositoryProvider);
  return ShiftsNotifier(repository);
});

// Shifts state
class ShiftsState {
  final List<Shift> shifts;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final DateTime startDate;
  final DateTime endDate;

  ShiftsState({
    this.shifts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    DateTime? startDate,
    DateTime? endDate,
  })  : startDate = startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 30));

  ShiftsState copyWith({
    List<Shift>? shifts,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ShiftsState(
      shifts: shifts ?? this.shifts,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// Shifts notifier
class ShiftsNotifier extends StateNotifier<ShiftsState> {
  final dynamic _repository;

  ShiftsNotifier(this._repository) : super(ShiftsState()) {
    loadShifts();
  }

  Future<void> loadShifts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Try to sync from API first, fallback to cache
      final shifts = await _repository.syncShifts(
        startDate: state.startDate,
        endDate: state.endDate,
      );

      state = state.copyWith(
        shifts: shifts,
        isLoading: false,
      );

      AppLogger.info('Loaded ${shifts.length} shifts');
    } catch (e) {
      AppLogger.error('Error loading shifts', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshShifts() async {
    state = state.copyWith(isRefreshing: true);

    try {
      final shifts = await _repository.syncShifts(
        startDate: state.startDate,
        endDate: state.endDate,
      );

      state = state.copyWith(
        shifts: shifts,
        isRefreshing: false,
      );

      AppLogger.info('Refreshed ${shifts.length} shifts');
    } catch (e) {
      AppLogger.error('Error refreshing shifts', e);
      state = state.copyWith(
        isRefreshing: false,
      );
    }
  }

  void updateDateRange(DateTime startDate, DateTime endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
    loadShifts();
  }
}

class ShiftsScreen extends ConsumerStatefulWidget {
  const ShiftsScreen({super.key});

  @override
  ConsumerState<ShiftsScreen> createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends ConsumerState<ShiftsScreen> {
  StreamSubscription? _shiftUpdateSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToShiftUpdates();
    _setupPollingCallbacks();
  }

  @override
  void dispose() {
    _shiftUpdateSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToShiftUpdates() {
    // Listen to real-time shift updates via WebSocket
    final wsController = ref.read(webSocketProvider.notifier);
    _shiftUpdateSubscription = wsController.shiftUpdates.listen((data) {
      final eventType = data['_eventType'] as String?;
      AppLogger.info('ShiftsScreen received shift update: $eventType');

      // Refresh the shifts list when any shift event is received
      if (eventType == SocketEvent.shiftCreated ||
          eventType == SocketEvent.shiftUpdated ||
          eventType == SocketEvent.shiftDeleted ||
          eventType == SocketEvent.attendanceBookOn ||
          eventType == SocketEvent.attendanceBookOff) {
        ref.read(shiftsProvider.notifier).refreshShifts();
      }
    });
  }

  void _setupPollingCallbacks() {
    // Also set up callback for polling service (when WebSocket is disabled)
    final pollingService = ref.read(pollingServiceProvider.notifier);
    pollingService.onShiftsUpdated = () {
      AppLogger.info('ShiftsScreen: Polling detected shift updates');
      if (mounted) {
        ref.read(shiftsProvider.notifier).refreshShifts();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final shiftsState = ref.watch(shiftsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shifts'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDateRangePicker(context, ref),
            tooltip: 'Change Date Range',
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline status banner
          const OfflineStatusBanner(),

          // Main content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(shiftsProvider.notifier).refreshShifts();
              },
              child: shiftsState.isLoading && shiftsState.shifts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : shiftsState.error != null && shiftsState.shifts.isEmpty
                      ? _buildErrorView(context, ref, shiftsState.error!)
                      : shiftsState.shifts.isEmpty
                          ? _buildEmptyView(context)
                          : _buildShiftsList(context, ref, shiftsState.shifts),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftsList(BuildContext context, WidgetRef ref, List<Shift> shifts) {
    final now = DateTime.now();

    // Filter shifts for mobile app:
    // - Show today's and future shifts
    // - Show currently active shifts (on-duty)
    // - Hide old completed shifts
    final filteredShifts = shifts.where((shift) {
      // Always show if currently on duty
      if (shift.status == 'on-duty') return true;

      // Show if shift is today or in the future
      final shiftDateLocal = shift.shiftDate.toLocal();
      final todayStart = DateTime(now.year, now.month, now.day);

      // If shift date is today or later, show it
      if (shiftDateLocal.isAfter(todayStart) ||
          DateFormat('yyyy-MM-dd').format(shiftDateLocal) ==
              DateFormat('yyyy-MM-dd').format(now)) {
        return true;
      }

      return false;
    }).toList();

    if (filteredShifts.isEmpty) {
      return _buildEmptyView(context);
    }

    // Group shifts by date (use local date for grouping)
    final groupedShifts = <String, List<Shift>>{};
    for (final shift in filteredShifts) {
      final dateKey = DateFormat('yyyy-MM-dd').format(shift.shiftDate.toLocal());
      groupedShifts.putIfAbsent(dateKey, () => []);
      groupedShifts[dateKey]!.add(shift);
    }

    final sortedDates = groupedShifts.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final dateShifts = groupedShifts[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: Text(
                DateFormat('EEEE, MMMM d, y').format(date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            ...dateShifts.map((shift) => _buildShiftCard(context, ref, shift)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildShiftCard(BuildContext context, WidgetRef ref, Shift shift) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isToday = DateFormat('yyyy-MM-dd').format(shift.shiftDate.toLocal()) ==
        DateFormat('yyyy-MM-dd').format(now);
    final isActive = shift.status == 'on-duty';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShiftDetailScreen(shiftId: shift.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge and time
              Row(
                children: [
                  _buildStatusBadge(shift.status, isActive, theme),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('HH:mm').format(shift.startTime.toLocal())} - ${DateFormat('HH:mm').format(shift.endTime.toLocal())}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Site name
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shift.siteName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Client name
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shift.clientName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.place,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shift.siteAddress,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),

              // Today indicator
              if (isToday) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.today,
                        size: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Today\'s Shift',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isActive, ThemeData theme) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case 'on-duty':
        bgColor = Colors.green[100]!;
        textColor = Colors.green[900]!;
        label = 'On Duty';
        icon = Icons.check_circle;
        break;
      case 'completed':
        bgColor = Colors.blue[100]!;
        textColor = Colors.blue[900]!;
        label = 'Completed';
        icon = Icons.check;
        break;
      case 'pending':
        bgColor = Colors.orange[100]!;
        textColor = Colors.orange[900]!;
        label = 'Pending';
        icon = Icons.schedule;
        break;
      default:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
        label = status;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No shifts found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh or change date range',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading shifts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(shiftsProvider.notifier).loadShifts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final currentState = ref.read(shiftsProvider);
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: currentState.startDate,
        end: currentState.endDate,
      ),
    );

    if (result != null) {
      ref.read(shiftsProvider.notifier).updateDateRange(result.start, result.end);
    }
  }
}
