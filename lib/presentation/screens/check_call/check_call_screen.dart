import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../../data/database/app_database.dart';

class CheckCallScreen extends ConsumerStatefulWidget {
  final CheckCall checkCall;
  final String siteName;

  const CheckCallScreen({
    super.key,
    required this.checkCall,
    required this.siteName,
  });

  @override
  ConsumerState<CheckCallScreen> createState() => _CheckCallScreenState();
}

class _CheckCallScreenState extends ConsumerState<CheckCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _countdownTimer;
  int _secondsRemaining = 300; // 5 minutes grace period
  bool _isResponding = false;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Calculate remaining time
    final now = DateTime.now();
    final scheduledTime = widget.checkCall.scheduledTime;
    final graceEnd = scheduledTime.add(const Duration(minutes: 5));
    _secondsRemaining = graceEnd.difference(now).inSeconds.clamp(0, 300);

    // Setup pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start countdown
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        // Auto-dismiss when time runs out
        if (mounted) {
          Navigator.of(context).pop(false);
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdownTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleRespond() async {
    setState(() => _isResponding = true);

    try {
      final checkCallController = ref.read(checkCallControllerProvider.notifier);
      final success = await checkCallController.respondToCheckCall(
        widget.checkCall.id,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _isResponding = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to respond. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isResponding = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSnooze() async {
    final checkCallController = ref.read(checkCallControllerProvider.notifier);
    await checkCallController.snoozeCurrentCheckCall();
    if (!mounted) return;
    Navigator.of(context).pop(false);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUrgent = _secondsRemaining < 60;

    return Scaffold(
      backgroundColor: isUrgent ? Colors.red[900] : theme.colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_callback,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'CHECK CALL REQUIRED',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Site name
              Text(
                widget.siteName,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Scheduled time
              Text(
                'Scheduled: ${DateFormat('HH:mm').format(widget.checkCall.scheduledTime)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 32),

              // Countdown timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: isUrgent ? Colors.red : Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      isUrgent ? 'URGENT!' : 'Time Remaining',
                      style: TextStyle(
                        fontSize: 14,
                        color: isUrgent ? Colors.white : Colors.white70,
                        fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(_secondsRemaining),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Notes input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Add notes (optional)',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  // Snooze button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isResponding ? null : _handleSnooze,
                      icon: const Icon(Icons.snooze),
                      label: const Text('Snooze 5 min'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Respond button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isResponding ? null : _handleRespond,
                      icon: _isResponding
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.green,
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text(_isResponding ? 'Responding...' : 'RESPOND NOW'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green[700],
                        padding: const EdgeInsets.all(20),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Warning message
              Text(
                'Your location will be recorded with your response',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
