import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../core/models/order_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  Future<void> completeOrder(OrderModel order) async {
    final batch = _db.batch();
    
    // 1. Save/Update the order
    final orderRef = order.id.isEmpty ? _db.collection('orders').doc() : _db.collection('orders').doc(order.id);
    final orderWithId = order.copyWith(id: orderRef.id);
    batch.set(orderRef, orderWithId.toJson());

    // 2. Only update statistics if the order is completed
    if (order.status == OrderStatus.completed) {
      // Update Daily Statistics
      final dateStr = DateFormat('yyyy-MM-dd').format(order.timestamp);
      final statsDocId = '${order.userId}_$dateStr';
      final statsRef = _db.collection('daily_statistics').doc(statsDocId);

      batch.set(statsRef, {
        'id': statsDocId,
        'userId': order.userId,
        'date': Timestamp.fromDate(DateTime.parse(dateStr)),
        'sales': FieldValue.increment(order.total),
        'tips': FieldValue.increment(order.tip),
        'orderCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      // Update Current Shift
      final activeShiftQuery = await _db.collection('shifts')
          .where('userId', isEqualTo: order.userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (activeShiftQuery.docs.isNotEmpty) {
        final shiftRef = activeShiftQuery.docs.first.reference;
        batch.update(shiftRef, {
          'totalSales': FieldValue.increment(order.total),
          'totalTips': FieldValue.increment(order.tip),
          'orderCount': FieldValue.increment(1),
        });
      }
    }

    try {
      await batch.commit();
      debugPrint('OrderService: Order completed successfully for ${order.id}');
    } catch (e) {
      debugPrint('OrderService: Error completing order: $e');
      rethrow;
    }
  }
}
