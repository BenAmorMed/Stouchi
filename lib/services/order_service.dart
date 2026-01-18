import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../core/models/order_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  Future<void> completeOrder(OrderModel order) async {
    final batch = _db.batch();
    
    // 1. Save the order
    final orderRef = _db.collection('orders').doc();
    final orderWithId = order.copyWith(id: orderRef.id);
    batch.set(orderRef, orderWithId.toJson());

    // 2. Update Daily Statistics
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

    // 3. Update Current Shift (if applicable)
    // For now, we assume user profile is updated with currentShiftId on login
    // but we can also update it here if we find an active shift for the user.
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

    await batch.commit();
  }
}
