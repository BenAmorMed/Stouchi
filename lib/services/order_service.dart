import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../core/models/order_model.dart';
import '../core/models/order_item_model.dart';
import '../core/models/recipe_ingredient.dart';
import '../core/models/table_model.dart';

class OrderService {
  final _db = FirebaseFirestore.instance;

  Future<void> completeOrder(OrderModel order) async {
    await _db.runTransaction((transaction) async {
      final articleProfitUpdates = <String, double>{};
      final stockDeductionUpdates = <String, Map<String, dynamic>>{};
      final processedItems = <OrderItemModel>[];

      Future<double> resolveDeductions({
        required String id,
        required String name,
        required double multiplier,
        required IngredientType type,
        Set<String>? visited,
      }) async {
        visited ??= {};
        if (visited.contains(id)) throw Exception('Circular recipe detected for $name');
        visited.add(id);

        double totalCost = 0.0;

        if (type == IngredientType.stock) {
          final stockRef = _db.collection('stock_products').doc(id);
          final stockDoc = await transaction.get(stockRef);
          if (!stockDoc.exists) throw Exception('Stock item $name not found');
          
          final stockData = stockDoc.data()!;
          final batchesList = (stockData['batches'] as List<dynamic>?) ?? [];
          final batches = batchesList.map((b) => Map<String, dynamic>.from(b)).toList();
          
          double qtyRemaining = multiplier;
          final currentTotalStock = (stockData['stockQuantity'] as num).toDouble();
          
          final newBatches = <Map<String, dynamic>>[];
          for (final batch in batches) {
            double batchQty = (batch['quantity'] as num).toDouble();
            double batchCost = (batch['costPrice'] as num).toDouble();
            
            if (qtyRemaining <= 0) {
              newBatches.add(batch);
              continue;
            }

            if (batchQty > qtyRemaining) {
              totalCost += qtyRemaining * batchCost;
              batch['quantity'] = batchQty - qtyRemaining;
              newBatches.add(batch);
              qtyRemaining = 0;
            } else {
              totalCost += batchQty * batchCost;
              qtyRemaining -= batchQty;
            }
          }

          stockDeductionUpdates[id] = {
            'stockQuantity': currentTotalStock - multiplier,
            'batches': newBatches,
          };
          
          return totalCost;
        } else {
          final articleRef = _db.collection('articles').doc(id);
          final articleDoc = await transaction.get(articleRef);
          if (!articleDoc.exists) throw Exception('Ingredient article $name not found');
          
          final articleData = articleDoc.data()!;
          if (articleData['isComposite'] != true) return 0.0;

          final recipe = (articleData['recipe'] as List<dynamic>?) ?? [];
          for (final ing in recipe) {
            final ingredient = RecipeIngredient.fromJson(Map<String, dynamic>.from(ing));
            
            totalCost += await resolveDeductions(
              id: ingredient.id,
              name: ingredient.name,
              multiplier: ingredient.quantity * multiplier,
              type: ingredient.type,
              visited: Set.from(visited),
            );
          }
          return totalCost;
        }
      }

      for (final item in order.items) {
        final articleRef = _db.collection('articles').doc(item.articleId);
        final articleDoc = await transaction.get(articleRef);
        if (!articleDoc.exists) throw Exception('Article ${item.articleName} not found');

        final articleData = articleDoc.data()!;
        final itemTotalCost = await resolveDeductions(
          id: item.articleId,
          name: item.articleName,
          multiplier: item.quantity,
          type: IngredientType.article, // Start with the article itself
        );
        
        final revenue = item.price * item.quantity;
        final profit = revenue - itemTotalCost;
        articleProfitUpdates[item.articleId] = (articleData['totalProfit'] as num? ?? 0.0).toDouble() + profit;
        
        processedItems.add(item.copyWith(costPrice: itemTotalCost / item.quantity));
      }

      // WRITES START HERE
      for (final entry in articleProfitUpdates.entries) {
        transaction.update(_db.collection('articles').doc(entry.key), {'totalProfit': entry.value});
      }
      for (final entry in stockDeductionUpdates.entries) {
        transaction.update(_db.collection('stock_products').doc(entry.key), entry.value);
      }

      // Free the table if it exists
      if (order.tableId != null) {
        transaction.update(_db.collection('tables').doc(order.tableId), {
          'status': TableStatus.free.name,
        });
      }
      
      final orderRef = order.id.isEmpty ? _db.collection('orders').doc() : _db.collection('orders').doc(order.id);
      final finalOrderWithId = order.copyWith(
        id: orderRef.id,
        items: processedItems,
        status: OrderStatus.completed,
      );
      
      transaction.set(orderRef, finalOrderWithId.toJson());
    });
    
    await _updateStats(order);
  }

  Future<void> _updateStats(OrderModel order) async {
     final batch = _db.batch();
     final dateStr = DateFormat('yyyy-MM-dd').format(order.timestamp);
     final statsDocId = '${order.userId}_$dateStr';
     final statsRef = _db.collection('daily_statistics').doc(statsDocId);
     
     final profit = order.total - order.items.fold(0.0, (currentSum, item) => currentSum + item.costPrice);

     final Map<String, dynamic> statsUpdate = {
        'id': statsDocId,
        'userId': order.userId,
        'date': Timestamp.fromDate(DateTime.parse(dateStr)),
        'sales': FieldValue.increment(order.total),
        'profit': FieldValue.increment(profit),
        'tips': FieldValue.increment(order.tip),
        'orderCount': FieldValue.increment(1),
     };

     for (final item in order.items) {
        final itemProfit = (item.price * item.quantity) - item.costPrice;
        statsUpdate['articleStats.${item.articleId}.qty'] = FieldValue.increment(item.quantity);
        statsUpdate['articleStats.${item.articleId}.revenue'] = FieldValue.increment(item.price * item.quantity);
        statsUpdate['articleStats.${item.articleId}.profit'] = FieldValue.increment(itemProfit);
        statsUpdate['articleStats.${item.articleId}.name'] = item.articleName;
     }

     batch.set(statsRef, statsUpdate, SetOptions(merge: true));
     
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

  Future<void> holdOrder(OrderModel order) async {
    await _db.runTransaction((transaction) async {
      String? finalTableId = order.tableId;
      String? finalTableName = order.tableName;

      if (finalTableId == null) {
        // Auto-assign table
        final freeTablesQuery = await _db.collection('tables')
            .where('status', isEqualTo: TableStatus.free.name)
            .limit(1)
            .get();
        
        if (freeTablesQuery.docs.isNotEmpty) {
          final tableDoc = freeTablesQuery.docs.first;
          finalTableId = tableDoc.id;
          finalTableName = tableDoc.data()['name'] as String;
          // Occupy existing free table
          transaction.update(_db.collection('tables').doc(finalTableId), {
            'status': TableStatus.occupied.name,
          });
        } else {
          // Create and occupy temporary table
          finalTableId = 'temp_${const Uuid().v4().substring(0, 8)}';
          finalTableName = 'Temp ${const Uuid().v4().substring(0, 4)}';
          final tempTable = TableModel(
            id: finalTableId,
            name: finalTableName,
            x: -500, y: -500, width: 100, height: 100, // Put it somewhere outside main layout
            status: TableStatus.occupied,
          );
          transaction.set(_db.collection('tables').doc(finalTableId), tempTable.toJson());
        }
      } else {
        // User picked a table, mark it occupied
        transaction.update(_db.collection('tables').doc(finalTableId), {
          'status': TableStatus.occupied.name,
        });
      }

      // Save order as pending
      final orderRef = order.id.isEmpty ? _db.collection('orders').doc() : _db.collection('orders').doc(order.id);
      final finalOrder = order.copyWith(
        id: orderRef.id,
        tableId: finalTableId,
        tableName: finalTableName,
        status: OrderStatus.pending,
      );

      transaction.set(orderRef, finalOrder.toJson());
    });
  }

  /// Cancel/Mark an order as cancelled and free its table
  Future<void> cancelOrder(String orderId) async {
    if (orderId.isEmpty) return; // Nothing to cancel if there's no order ID
    
    await _db.runTransaction((transaction) async {
      final orderRef = _db.collection('orders').doc(orderId);
      final orderDoc = await transaction.get(orderRef);
      
      if (!orderDoc.exists) return;
      
      final orderData = orderDoc.data()!;
      final tableId = orderData['tableId'] as String?;
      
      // Free the table if it exists
      if (tableId != null) {
        final tableRef = _db.collection('tables').doc(tableId);
        final tableDoc = await transaction.get(tableRef);
        
        if (tableDoc.exists) {
          // If it's a temp table (created automatically), delete it
          if (tableId.startsWith('temp_')) {
            transaction.delete(tableRef);
          } else {
            // Otherwise, just mark it as free
            transaction.update(tableRef, {
              'status': TableStatus.free.name,
            });
          }
        }
      }
      
      // Delete the order permanently
      transaction.delete(orderRef);
    });
  }

  /// Update an existing order in Firestore
  Future<void> updateOrder(OrderModel order) async {
    if (order.id.isEmpty) return; // Nothing to update if there's no order ID
    
    final orderRef = _db.collection('orders').doc(order.id);
    await orderRef.update(order.toJson());
  }
}
