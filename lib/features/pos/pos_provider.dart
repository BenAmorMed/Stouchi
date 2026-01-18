import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/article_model.dart';
import '../../core/models/category_model.dart';
import '../../core/models/order_item_model.dart';
import '../../core/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_provider.dart';

// Stream of Categories
final categoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories')
      .orderBy('orderIndex')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Stream of Articles for a specific category
final articlesProvider = StreamProvider.family<List<ArticleModel>, String>((ref, categoryId) {
  return FirebaseFirestore.instance
      .collection('articles')
      .where('categoryId', isEqualTo: categoryId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ArticleModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Selected Category State
final selectedCategoryIdProvider = StateProvider<String?>((ref) => null);

// Cart State (managed as an OrderModel)
class CartNotifier extends StateNotifier<OrderModel> {
  CartNotifier(String userId)
      : super(OrderModel(
          id: '',
          userId: userId,
          items: [],
          total: 0.0,
          timestamp: DateTime.now(),
        ));

  void toggleArticle(ArticleModel article) {
    final existingIndex = state.items.indexWhere((item) => item.articleId == article.id);

    if (existingIndex >= 0) {
      // Remove if already in cart
      final newItems = List<OrderItemModel>.from(state.items)..removeAt(existingIndex);
      _updateState(newItems);
    } else {
      // Add with default comment
      final newItem = OrderItemModel(
        articleId: article.id,
        articleName: article.name,
        price: article.price,
        comments: [article.commentConfig.defaultOption],
      );
      final newItems = [...state.items, newItem];
      _updateState(newItems);
    }
  }

  void updateComments(String articleId, List<String> comments) {
    final newItems = state.items.map((item) {
      if (item.articleId == articleId) {
        return item.copyWith(comments: comments);
      }
      return item;
    }).toList();
    _updateState(newItems);
  }

  void updateItem(String articleId, int quantity, List<String> comments) {
    final newItems = state.items.map((item) {
      if (item.articleId == articleId) {
        return item.copyWith(quantity: quantity, comments: comments);
      }
      return item;
    }).toList();
    _updateState(newItems);
  }

  void removeItem(String articleId) {
    final newItems = state.items.where((item) => item.articleId != articleId).toList();
    _updateState(newItems);
  }

  void clear() {
    state = state.copyWith(items: [], total: 0.0, tableName: null, tableId: null);
  }

  void setTable(String? name) {
    state = state.copyWith(tableName: name, tableId: name); // Simple ID for now
  }

  void loadOrder(OrderModel order) {
    state = order;
  }

  void _updateState(List<OrderItemModel> items) {
    final total = items.fold(0.0, (acc, item) => acc + (item.price * item.quantity));
    state = state.copyWith(items: items, total: total);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, OrderModel>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return CartNotifier(authState?.uid ?? '');
});
