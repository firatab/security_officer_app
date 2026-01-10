import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';

class MapScreen extends ConsumerStatefulWidget {
  final Shift? focusedShift;

  const MapScreen({super.key, this.focusedShift});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Circle> _geofenceCircles = {};
  List<Shift> _shifts = [];
  bool _isLoading = true;
  bool _followUser = true;
  StreamSubscription<Position>? _positionSubscription;
  Shift? _selectedShift;

  // Default location (London)
  static const LatLng _defaultLocation = LatLng(51.5074, -0.1278);

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    setState(() => _isLoading = true);

    try {
      // Get current location
      final locationService = ref.read(locationServiceProvider);
      _currentPosition = await locationService.getCurrentLocation();

      // Load shifts with locations
      await _loadShifts();

      // Start location updates
      _startLocationUpdates();

      // If there's a focused shift, center on it
      if (widget.focusedShift != null) {
        _selectedShift = widget.focusedShift;
      }
    } catch (e) {
      AppLogger.error('Error initializing map', e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadShifts() async {
    try {
      final shiftRepo = ref.read(shiftRepositoryProvider);
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 14));

      _shifts = await shiftRepo.getShiftsInRange(startOfWeek, endOfWeek);
      _updateMarkers();
    } catch (e) {
      AppLogger.error('Error loading shifts for map', e);
    }
  }

  void _startLocationUpdates() {
    _positionSubscription?.cancel();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _updateMarkers();
        });

        if (_followUser && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }
      }
    });
  }

  void _updateMarkers() {
    final markers = <Marker>{};
    final circles = <Circle>{};

    // Add current location marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    // Add shift/site markers
    for (final shift in _shifts) {
      if (shift.siteLatitude != null && shift.siteLongitude != null) {
        final isSelected = _selectedShift?.id == shift.id;
        final isTodayShift = _isToday(shift.shiftDate);

        markers.add(
          Marker(
            markerId: MarkerId('shift_${shift.id}'),
            position: LatLng(shift.siteLatitude!, shift.siteLongitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isSelected
                  ? BitmapDescriptor.hueGreen
                  : isTodayShift
                      ? BitmapDescriptor.hueOrange
                      : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: shift.siteName,
              snippet: '${shift.clientName} - ${_formatDate(shift.shiftDate)}',
              onTap: () => _showShiftDetails(shift),
            ),
            onTap: () {
              setState(() => _selectedShift = shift);
            },
          ),
        );

        // Add geofence circle
        circles.add(
          Circle(
            circleId: CircleId('geofence_${shift.id}'),
            center: LatLng(shift.siteLatitude!, shift.siteLongitude!),
            radius: AppConstants.geofenceRadiusMeters,
            fillColor: (isSelected ? Colors.green : Colors.blue).withValues(alpha: 0.15),
            strokeColor: isSelected ? Colors.green : Colors.blue,
            strokeWidth: 2,
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _geofenceCircles = circles;
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _showShiftDetails(Shift shift) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ShiftDetailsSheet(
        shift: shift,
        currentPosition: _currentPosition,
        onNavigate: () => _navigateToSite(shift),
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _navigateToSite(Shift shift) async {
    if (shift.siteLatitude == null || shift.siteLongitude == null) return;

    final url = 'https://www.google.com/maps/dir/?api=1&destination=${shift.siteLatitude},${shift.siteLongitude}&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open navigation')),
      );
    }
  }

  void _centerOnCurrentLocation() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15,
        ),
      );
      setState(() => _followUser = true);
    }
  }

  void _centerOnShift(Shift shift) {
    if (shift.siteLatitude != null && shift.siteLongitude != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(shift.siteLatitude!, shift.siteLongitude!),
          16,
        ),
      );
      setState(() {
        _selectedShift = shift;
        _followUser = false;
      });
      _updateMarkers();
    }
  }

  void _fitAllMarkers() {
    if (_markers.isEmpty || _mapController == null) return;

    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

    for (final marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng) maxLng = marker.position.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.01, minLng - 0.01),
          northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
        ),
        50,
      ),
    );
    setState(() => _followUser = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Map'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadShifts,
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'fit_all':
                  _fitAllMarkers();
                  break;
                case 'my_location':
                  _centerOnCurrentLocation();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'fit_all',
                child: Row(
                  children: [
                    Icon(Icons.zoom_out_map),
                    SizedBox(width: 8),
                    Text('Show All Sites'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'my_location',
                child: Row(
                  children: [
                    Icon(Icons.my_location),
                    SizedBox(width: 8),
                    Text('My Location'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.focusedShift?.siteLatitude != null
                        ? LatLng(widget.focusedShift!.siteLatitude!, widget.focusedShift!.siteLongitude!)
                        : _currentPosition != null
                            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                            : _defaultLocation,
                    zoom: 14,
                  ),
                  markers: _markers,
                  circles: _geofenceCircles,
                  myLocationEnabled: false, // We handle this manually
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (widget.focusedShift != null) {
                      _centerOnShift(widget.focusedShift!);
                    }
                  },
                  onCameraMove: (_) {
                    if (_followUser) {
                      setState(() => _followUser = false);
                    }
                  },
                ),

          // Legend
          Positioned(
            top: 16,
            left: 16,
            child: _buildLegend(),
          ),

          // Shift list drawer button
          Positioned(
            bottom: 100,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: 'shift_list',
              onPressed: () => _showShiftListSheet(),
              backgroundColor: Colors.white,
              child: Icon(Icons.list, color: theme.colorScheme.primary),
            ),
          ),

          // Current location button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'my_location',
              onPressed: _centerOnCurrentLocation,
              backgroundColor: _followUser ? theme.colorScheme.primary : Colors.white,
              child: Icon(
                Icons.my_location,
                color: _followUser ? Colors.white : theme.colorScheme.primary,
              ),
            ),
          ),

          // Selected shift info card
          if (_selectedShift != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildSelectedShiftCard(_selectedShift!),
            ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLegendItem(Colors.blue, 'Your Location'),
            _buildLegendItem(Colors.orange, "Today's Shift"),
            _buildLegendItem(Colors.red, 'Other Shifts'),
            _buildLegendItem(Colors.green, 'Selected'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: color, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSelectedShiftCard(Shift shift) {
    final theme = Theme.of(context);
    String? distanceText;

    if (_currentPosition != null && shift.siteLatitude != null && shift.siteLongitude != null) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        shift.siteLatitude!,
        shift.siteLongitude!,
      );
      if (distance < 1000) {
        distanceText = '${distance.toInt()} m away';
      } else {
        distanceText = '${(distance / 1000).toStringAsFixed(1)} km away';
      }
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.siteName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        shift.clientName,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _selectedShift = null),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(_formatDate(shift.shiftDate)),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('${_formatTime(shift.startTime)} - ${_formatTime(shift.endTime)}'),
              ],
            ),
            if (distanceText != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.straighten, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    distanceText,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showShiftDetails(shift),
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToSite(shift),
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Navigate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showShiftListSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _ShiftListSheet(
          shifts: _shifts,
          scrollController: scrollController,
          onShiftSelected: (shift) {
            Navigator.pop(context);
            _centerOnShift(shift);
          },
        ),
      ),
    );
  }
}

/// Bottom sheet for shift details
class _ShiftDetailsSheet extends StatelessWidget {
  final Shift shift;
  final Position? currentPosition;
  final VoidCallback onNavigate;
  final VoidCallback onClose;

  const _ShiftDetailsSheet({
    required this.shift,
    required this.currentPosition,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String? distanceText;

    if (currentPosition != null && shift.siteLatitude != null && shift.siteLongitude != null) {
      final distance = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        shift.siteLatitude!,
        shift.siteLongitude!,
      );
      if (distance < 1000) {
        distanceText = '${distance.toInt()} meters';
      } else {
        distanceText = '${(distance / 1000).toStringAsFixed(1)} km';
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  shift.siteName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          const Divider(height: 24),
          _buildDetailRow(Icons.business, 'Client', shift.clientName),
          _buildDetailRow(Icons.place, 'Address', shift.siteAddress),
          _buildDetailRow(
            Icons.calendar_today,
            'Date',
            '${shift.shiftDate.day}/${shift.shiftDate.month}/${shift.shiftDate.year}',
          ),
          _buildDetailRow(
            Icons.access_time,
            'Time',
            '${_formatTime(shift.startTime)} - ${_formatTime(shift.endTime)}',
          ),
          if (distanceText != null)
            _buildDetailRow(Icons.straighten, 'Distance', distanceText),
          if (shift.checkCallEnabled)
            _buildDetailRow(
              Icons.phone,
              'Check Calls',
              'Every ${shift.checkCallFrequency ?? 60} minutes',
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNavigate,
              icon: const Icon(Icons.directions),
              label: const Text('Navigate to Site'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Bottom sheet for shift list
class _ShiftListSheet extends StatelessWidget {
  final List<Shift> shifts;
  final ScrollController scrollController;
  final Function(Shift) onShiftSelected;

  const _ShiftListSheet({
    required this.shifts,
    required this.scrollController,
    required this.onShiftSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shiftsWithLocation = shifts.where((s) => s.siteLatitude != null).toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Shift Locations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${shiftsWithLocation.length} sites',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: shiftsWithLocation.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'No shift locations available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: shiftsWithLocation.length,
                    itemBuilder: (context, index) {
                      final shift = shiftsWithLocation[index];
                      return _ShiftListItem(
                        shift: shift,
                        onTap: () => onShiftSelected(shift),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ShiftListItem extends StatelessWidget {
  final Shift shift;
  final VoidCallback onTap;

  const _ShiftListItem({
    required this.shift,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isToday(shift.shiftDate);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isToday ? Colors.orange : theme.colorScheme.primary,
        child: const Icon(Icons.location_on, color: Colors.white, size: 20),
      ),
      title: Text(
        shift.siteName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${shift.clientName} - ${_formatDate(shift.shiftDate)}',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: isToday
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}
