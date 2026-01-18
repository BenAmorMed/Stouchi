import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'pos_provider.dart';
import 'widgets/comment_modal.dart';
import 'checkout_screen.dart';
import '../statistics/server_statistics_screen.dart';
import '../../core/models/article_model.dart';
import '../../core/models/order_item_model.dart';
import '../auth/profile_screen.dart';
import '../auth/auth_provider.dart';

class POSScreen extends ConsumerWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Stouchi POS'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ServerStatisticsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // 1. Categories Sidebar (Left) - Use Flexible instead of fixed width
          Flexible(
            flex: 2, // Relative width
            child: Container(
              color: AppTheme.surfaceColor,
              child: categoriesAsync.when(
                data: (categories) {
                  // Set initial category if none selected
                  if (selectedCategoryId == null && categories.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(selectedCategoryIdProvider.notifier).state = categories[0].id;
                    });
                  }
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategoryId == category.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: InkWell(
                          onTap: () => ref.read(selectedCategoryIdProvider.notifier).state = category.id,
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryColor : AppTheme.mutedTextColor.withValues(alpha: 0.1),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_rounded,
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.mutedTextColor,
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppTheme.primaryColor : AppTheme.mutedTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Icon(Icons.error),
              ),
            ),
          ),

          // 2. Articles Grid (Center) - Dynamic columns based on width
          Expanded(
            flex: 8,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on width
                final columns = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 3 : 2);
                
                return selectedCategoryId == null
                    ? const Center(child: Text('Select a category'))
                    : ref.watch(articlesProvider(selectedCategoryId)).when(
                          data: (articles) => GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              final isInCart = cart.items.any((item) => item.articleId == article.id);
                              
                              return _ArticleCard(
                                article: article,
                                isSelected: isInCart,
                                onTap: () => ref.read(cartProvider.notifier).toggleArticle(article),
                                onLongPress: () {
                                  if (article.commentConfig.hasComments) {
                                    final currentItem = cart.items.firstWhere(
                                      (i) => i.articleId == article.id,
                                      orElse: () => OrderItemModel(
                                        articleId: article.id,
                                        articleName: article.name,
                                        price: article.price,
                                        comments: [article.commentConfig.defaultOption],
                                      ),
                                    );
                                    
                                    if (!isInCart) {
                                      ref.read(cartProvider.notifier).toggleArticle(article);
                                    }

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => CommentSelectionModal(
                                        article: article,
                                        initialComments: currentItem.comments,
                                        initialQuantity: currentItem.quantity,
                                        onConfirm: (quantity, comments) => ref
                                            .read(cartProvider.notifier)
                                            .updateItem(article.id, quantity, comments),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text('Error: $e')),
                        );
              },
            ),
          ),

          // 3. Order Sidebar (Right) - Flexible width
          Flexible(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(-5, 0))
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Text(
                      'Current Order',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          onTap: () async {
                            // Find article to get its config
                            final articles = await ref.read(articlesProvider(selectedCategoryId!).future);
                            final article = articles.firstWhere((a) => a.id == item.articleId);
                            
                            if (context.mounted) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => CommentSelectionModal(
                                  article: article,
                                  initialComments: item.comments,
                                  initialQuantity: item.quantity,
                                  onConfirm: (quantity, comments) => ref
                                      .read(cartProvider.notifier)
                                      .updateItem(item.articleId, quantity, comments),
                                ),
                              );
                            }
                          },
                          title: Text(
                            '${item.quantity} x ${item.articleName}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            item.comments.join(', '),
                            style: const TextStyle(fontSize: 11, color: Colors.white60),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                                onPressed: () => ref.read(cartProvider.notifier).removeItem(item.articleId),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: cart.items.isEmpty
                              ? null
                              : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                                  ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Checkout', style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: cart.items.isEmpty ? null : () => _quickSave(context, ref),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: const BorderSide(color: AppTheme.primaryColor),
                            foregroundColor: AppTheme.primaryColor,
                          ),
                          child: const Text('Quick Save & New', style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _quickSave(BuildContext context, WidgetRef ref) async {
    final cart = ref.read(cartProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Quick Save & New'),
        content: Text('Are you sure you want to save this order of \$${cart.total.toStringAsFixed(2)} and start a new one?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save Order'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final finalOrder = cart.copyWith(timestamp: DateTime.now(), tip: 0.0);
        await ref.read(orderServiceProvider).completeOrder(finalOrder);
        ref.read(cartProvider.notifier).clear();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order saved successfully! 🚀')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving order: $e')),
          );
        }
      }
    }
  }
}

class _ArticleCard extends StatefulWidget {
  final ArticleModel article;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ArticleCard({
    required this.article,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20), // More rounded
            border: Border.all(
              color: widget.isSelected ? AppTheme.primaryColor : AppTheme.mutedTextColor.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.article.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: widget.isSelected ? Colors.white : AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${widget.article.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isSelected ? Colors.white.withValues(alpha: 0.8) : AppTheme.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.article.commentConfig.hasComments)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.comment_outlined,
                    size: 14,
                    color: Colors.white54,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
