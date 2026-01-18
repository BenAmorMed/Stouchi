import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/history_archive_model.dart';
import '../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

final historyArchivesProvider = StreamProvider<List<HistoryArchiveModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('history_archives')
      .orderBy('archivedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => HistoryArchiveModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

class HistoryArchiveScreen extends ConsumerWidget {
  const HistoryArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivesAsync = ref.watch(historyArchivesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History Archives')),
      body: archivesAsync.when(
        data: (archives) {
          if (archives.isEmpty) {
            return const Center(child: Text('No archived history found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: archives.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final archive = archives[index];
              final date = DateFormat('MMM d, yyyy • HH:mm').format(archive.archivedAt);

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          archive.userName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          date,
                          style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ArchiveMetric(label: 'Sales', value: '\$${archive.totalSales.toStringAsFixed(2)}'),
                        _ArchiveMetric(label: 'Tips', value: '\$${archive.totalTips.toStringAsFixed(2)}'),
                        _ArchiveMetric(label: 'Orders', value: '${archive.orderCount}'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ArchiveMetric extends StatelessWidget {
  final String label;
  final String value;

  const _ArchiveMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
