import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/time_tracking_service.dart';
import '../../auth/auth_provider.dart';
import '../../../core/models/time_entry_model.dart';
import 'dart:async';

final timeTrackingServiceProvider = Provider((ref) => TimeTrackingService());

final currentSessionProvider = StreamProvider<TimeEntryModel?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();
  return ref.watch(timeTrackingServiceProvider).getCurrentSession(user.uid);
});

class ClockInButton extends ConsumerStatefulWidget {
  const ClockInButton({super.key});

  @override
  ConsumerState<ClockInButton> createState() => _ClockInButtonState();
}

class _ClockInButtonState extends ConsumerState<ClockInButton> {
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(DateTime startTime) {
    _timer?.cancel();
    _duration = DateTime.now().difference(startTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _duration = DateTime.now().difference(startTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(currentSessionProvider);
    final user = ref.watch(authStateProvider).value;

    return sessionAsync.when(
      data: (session) {
        if (session != null) {
          if (_timer == null || !_timer!.isActive) _startTimer(session.clockIn);
          
          return OutlinedButton.icon(
            onPressed: () async {
               // Confirm Clock Out
               final confirm = await showDialog<bool>(
                 context: context,
                 builder: (c) => AlertDialog(
                   title: const Text('Clock Out?'),
                   content: const Text('Are you sure you want to end your shift?'),
                   actions: [
                     TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                     ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Clock Out')),
                   ],
                 ),
               );
               
               if (confirm == true && user != null) {
                 await ref.read(timeTrackingServiceProvider).clockOut(user.uid);
               }
            },
            icon: const Icon(Icons.stop_circle_outlined, color: Colors.white), // Fixed icon color
            label: Text(
              '${_duration.inHours}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Fixed text color
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.8), // Red background
              side: BorderSide.none,
            ),
          );
        } else {
          _timer?.cancel();
          return ElevatedButton.icon(
            onPressed: () async {
               if (user != null) {
                 await ref.read(timeTrackingServiceProvider).clockIn(user.uid);
               }
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Clock In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          );
        }
      },
      loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
      error: (_, __) => const Icon(Icons.error, color: Colors.orange),
    );
  }
}
