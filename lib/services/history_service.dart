import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../core/models/history_archive_model.dart';
import '../core/models/daily_statistic_model.dart';
import '../core/models/user_model.dart';
import '../core/models/fixed_expense_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService();
});

class HistoryService {
  final _db = FirebaseFirestore.instance;

  /// Resets user statistics and moves them to an archive.
  /// This is typically called by an Admin.
  Future<void> archiveAndResetStats(UserModel user) async {
    // 1. Fetch all current daily statistics for the user
    final statsSnapshot = await _db.collection('daily_statistics')
        .where('userId', isEqualTo: user.id)
        .get();

    if (statsSnapshot.docs.isEmpty) return;

    final batch = _db.batch();

    double totalSales = 0;
    double totalTips = 0;
    int totalOrders = 0;

    for (var doc in statsSnapshot.docs) {
      final stats = DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id});
      totalSales += stats.sales;
      totalTips += stats.tips;
      totalOrders += stats.orderCount;

      // Mark for deletion or clearing
      batch.delete(doc.reference);
    }

    // 2. Create Archive entry
    final archiveRef = _db.collection('history_archives').doc();
    final archive = HistoryArchiveModel(
      id: archiveRef.id,
      userId: user.id,
      userName: user.name,
      date: DateTime.now(),
      totalSales: totalSales,
      totalTips: totalTips,
      orderCount: totalOrders,
      archivedAt: DateTime.now(),
    );

    batch.set(archiveRef, archive.toJson());

    // 3. Optional: Clear user's current shift data if any
    // This is handled per shift, but we could also reset shift totals here.

    await batch.commit();
  }

  /// Automated cleanup: Delete history older than 7 days for a specific user.
  /// Note: In a production app, this would be best handled by a Firebase Cloud Function.
  Future<void> cleanupOldHistory(String userId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    
    final oldStats = await _db.collection('daily_statistics')
        .where('userId', isEqualTo: userId)
        .where('date', isLessThan: sevenDaysAgo)
        .get();

    final batch = _db.batch();
    for (var doc in oldStats.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
  /// Generates a financial report and returns the file path.
  Future<String> generateReport({required List<FixedExpenseModel> expenses}) async {
    // 1. Fetch All Data
    final statsSnapshot = await _db.collection('daily_statistics').get();
    
    // Aggregate Data
    double totalSales = 0;
    double totalTips = 0;
    double totalGrossProfit = 0;
    Map<String, _ArticleAgg> articleAggregates = {};
    Map<String, double> userSales = {};

    for (var doc in statsSnapshot.docs) {
      final data = doc.data();
      // Safely handle potential nulls or type mismatches
      final sales = (data['sales'] as num?)?.toDouble() ?? 0.0;
      final tips = (data['tips'] as num?)?.toDouble() ?? 0.0;
      final profit = (data['profit'] as num?)?.toDouble() ?? 0.0;
      final userId = data['userId'] as String? ?? 'Unknown';

      totalSales += sales;
      totalTips += tips;
      totalGrossProfit += profit;

      userSales[userId] = (userSales[userId] ?? 0) + sales;

      // Aggregate Article Stats
      final articles = data['articleStats'] as Map<String, dynamic>?;
      if (articles != null) {
        articles.forEach((key, value) {
          final stats = value as Map<String, dynamic>;
          final name = stats['name'] as String? ?? 'Unknown';
          final qty = (stats['qty'] as num?)?.toDouble() ?? 0.0;
          final revenue = (stats['revenue'] as num?)?.toDouble() ?? 0.0;
          
          if (!articleAggregates.containsKey(name)) {
            articleAggregates[name] = _ArticleAgg(name, 0, 0);
          }
          articleAggregates[name]!.qty += qty;
          articleAggregates[name]!.revenue += revenue;
        });
      }
    }

    // Fixed Expenses Calculation
    double totalFixedExpenses = expenses.fold(0.0, (acc, e) => acc + e.amount);
    double netProfit = totalGrossProfit - totalFixedExpenses;

    // 2. Format Report
    final sb = StringBuffer();
    sb.writeln('==================================================');
    sb.writeln('             STOUCHI FINANCIAL REPORT             ');
    sb.writeln('Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');
    sb.writeln('==================================================');
    sb.writeln('');
    sb.writeln('FINANCIAL SUMMARY');
    sb.writeln('-----------------');
    sb.writeln('Total Sales:        \$${totalSales.toStringAsFixed(2)}');
    sb.writeln('Total Tips:         \$${totalTips.toStringAsFixed(2)}');
    sb.writeln('Gross Profit:       \$${totalGrossProfit.toStringAsFixed(2)}');
    sb.writeln('');
    sb.writeln('FIXED EXPENSES DEDUCTION');
    sb.writeln('------------------------');
    for (var e in expenses) {
      sb.writeln('- ${e.name} (${e.frequency.name}): \$${e.amount.toStringAsFixed(2)}');
    }
    sb.writeln('--------------------------------------------------');
    sb.writeln('Total Expenses:     -\$${totalFixedExpenses.toStringAsFixed(2)}');
    sb.writeln('--------------------------------------------------');
    sb.writeln('NET PROFIT:         \$${netProfit.toStringAsFixed(2)}');
    sb.writeln('');
    sb.writeln('==================================================');
    sb.writeln('');
    sb.writeln('TOP PERFORMING ARTICLES');
    sb.writeln('-----------------------');
    
    // Sort articles by revenue
    final sortedArticles = articleAggregates.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue)); // Descending

    for (var i = 0; i < sortedArticles.length; i++) {
        final art = sortedArticles[i];
        if (i < 10) { // Limit to top 10 for detailed summary
             sb.writeln('${i+1}. ${art.name.padRight(20)} Qty: ${art.qty.toInt().toString().padLeft(4)}   \$${art.revenue.toStringAsFixed(2)}');
        }
    }

    sb.writeln('');
    sb.writeln('USER CONTRIBUTIONS');
    sb.writeln('------------------');
    // Fetch user names would be ideal, but for now use ID or assume name if cached.
    // Simplifying to just display what we have.
    userSales.forEach((uid, amount) {
        sb.writeln('- User ($uid): \$${amount.toStringAsFixed(2)}');
    });

    sb.writeln('');
    sb.writeln('==================================================');
    sb.writeln('END OF REPORT');

    // 3. Write to File
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/stouchi_report_${DateTime.now().millisecondsSinceEpoch}.txt');
    await file.writeAsString(sb.toString());

    return file.path;
  }

  /// Permanently deletes all history.
  Future<void> performHardReset() async {
    final batch = _db.batch();
    
    // Delete Daily Statistics
    final stats = await _db.collection('daily_statistics').get();
    for (var doc in stats.docs) {
      batch.delete(doc.reference);
    }
    
    // Delete Orders
    final orders = await _db.collection('orders').get();
    for (var doc in orders.docs) {
      batch.delete(doc.reference);
    }

    // Add comprehensive archive entry? 
    // Maybe later. For now, just wipe as requested.
    
    await batch.commit();
  }

  Future<Uint8List> generatePdfReport({required List<FixedExpenseModel> expenses}) async {
    final pdf = pw.Document();

    // 1. Fetch Data
    final data = await _fetchAndAggregateData(expenses);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 1, child: pw.Text('STOUCHI FINANCIAL REPORT')),
              pw.Text('Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
              pw.Divider(),
              pw.SizedBox(height: 20),
              
              pw.Text('Total Sales: \$${data.totalSales.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Total Tips: \$${data.totalTips.toStringAsFixed(2)}'),
              pw.Text('Gross Profit: \$${data.grossProfit.toStringAsFixed(2)}'),
              pw.SizedBox(height: 10),
              
              pw.Text('Fixed Expenses:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...data.expenses.map((e) => pw.Text('- ${e.name} (${e.frequency.name}): \$${e.amount.toStringAsFixed(2)}')),
              pw.Divider(),
              pw.Text('Total Expenses: -\$${data.totalFixedExpenses.toStringAsFixed(2)}', style: pw.TextStyle(color: PdfColors.red)),
              pw.Divider(),
              pw.Text('NET PROFIT: \$${data.netProfit.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
              
              pw.SizedBox(height: 20),
              pw.Header(level: 2, child: pw.Text('Top Performing Articles')),
              ...data.topArticles.take(10).map((art) => pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   pw.Text(art.name), 
                   pw.Text('${art.qty.toInt()} qty  \$${art.revenue.toStringAsFixed(2)}'),
                ]
              )),
              
              pw.SizedBox(height: 20),
              pw.Header(level: 2, child: pw.Text('User Contributions')),
              ...data.userSales.entries.map((e) => pw.Text('User (${e.key}): \$${e.value.toStringAsFixed(2)}')),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<_ReportData> _fetchAndAggregateData(List<FixedExpenseModel> expenses) async {
    final statsSnapshot = await _db.collection('daily_statistics').get();
    
    double totalSales = 0;
    double totalTips = 0;
    double totalGrossProfit = 0;
    Map<String, _ArticleAgg> articleAggregates = {};
    Map<String, double> userSales = {};

    for (var doc in statsSnapshot.docs) {
      final data = doc.data();
      final sales = (data['sales'] as num?)?.toDouble() ?? 0.0;
      final tips = (data['tips'] as num?)?.toDouble() ?? 0.0;
      final profit = (data['profit'] as num?)?.toDouble() ?? 0.0;
      final userId = data['userId'] as String? ?? 'Unknown';

      totalSales += sales;
      totalTips += tips;
      totalGrossProfit += profit;
      userSales[userId] = (userSales[userId] ?? 0) + sales;

      final articles = data['articleStats'] as Map<String, dynamic>?;
      if (articles != null) {
        articles.forEach((key, value) {
          final stats = value as Map<String, dynamic>;
          final name = stats['name'] as String? ?? 'Unknown';
          final qty = (stats['qty'] as num?)?.toDouble() ?? 0.0;
          final revenue = (stats['revenue'] as num?)?.toDouble() ?? 0.0;
          
          if (!articleAggregates.containsKey(name)) {
            articleAggregates[name] = _ArticleAgg(name, 0, 0);
          }
          articleAggregates[name]!.qty += qty;
          articleAggregates[name]!.revenue += revenue;
        });
      }
    }

    double totalFixedExpenses = expenses.fold(0.0, (acc, e) => acc + e.amount);
    double netProfit = totalGrossProfit - totalFixedExpenses;
    
    final sortedArticles = articleAggregates.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    return _ReportData(
      totalSales: totalSales,
      totalTips: totalTips,
      grossProfit: totalGrossProfit,
      totalFixedExpenses: totalFixedExpenses,
      netProfit: netProfit,
      expenses: expenses,
      topArticles: sortedArticles,
      userSales: userSales,
    );
  }
}

class _ReportData {
  final double totalSales;
  final double totalTips;
  final double grossProfit;
  final double totalFixedExpenses;
  final double netProfit;
  final List<FixedExpenseModel> expenses;
  final List<_ArticleAgg> topArticles;
  final Map<String, double> userSales;

  _ReportData({
    required this.totalSales,
    required this.totalTips,
    required this.grossProfit,
    required this.totalFixedExpenses,
    required this.netProfit,
    required this.expenses,
    required this.topArticles,
    required this.userSales,
  });
}

class _ArticleAgg {
  final String name;
  double qty;
  double revenue;
  _ArticleAgg(this.name, this.qty, this.revenue);
}
