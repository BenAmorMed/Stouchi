import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/order_model.dart';
import '../../core/theme/app_theme.dart';
import 'pos_provider.dart';
import 'widgets/comment_modal.dart';
import 'checkout_screen.dart';
import '../statistics/server_statistics_screen.dart';
import '../../core/models/article_model.dart';
import 'live_orders_screen.dart';
import '../../core/models/order_item_model.dart';
import '../auth/profile_screen.dart';

class POSScreen extends ConsumerWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Stouchi POS'),
            backgroundColor: Colors.transparent,
            leading: isMobile
                ? Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  )
                : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.table_bar_rounded),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiveOrdersScreen()),
                ),
              ),
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
              if (isMobile)
                Builder(
                  builder: (context) => Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      ),
                      if (cart.items.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '${cart.items.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: isMobile ? _buildCategoriesSidebar(context, ref, true) : null,
          endDrawer: isMobile ? _buildOrderSidebar(context, ref, true) : null,
          body: Row(
            children: [
              // 1. Categories Sidebar (Left) - Desktop Only
              if (!isMobile)
                _buildCategoriesSidebar(context, ref, false),

              // 2. Articles Grid (Center)
              Expanded(
                child: _buildArticlesGrid(context, ref, selectedCategoryId, cart),
              ),

              // 3. Order Sidebar (Right) - Desktop Only
              if (!isMobile)
                _buildOrderSidebar(context, ref, false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSidebar(BuildContext context, WidgetRef ref, bool isDrawer) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final theme = Theme.of(context);

    final content = ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: isDrawer ? 280 : null,
          color: isDrawer 
              ? theme.cardColor.withValues(alpha: 0.9) 
              : theme.cardColor.withValues(alpha: 0.4),
          child: categoriesAsync.when(
            data: (categories) {
              if (selectedCategoryId == null && categories.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(selectedCategoryIdProvider.notifier).state = categories[0].id;
                });
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategoryId == category.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedCategoryIdProvider.notifier).state = category.id;
                        if (isDrawer) Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.primaryColor : theme.canvasColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [BoxShadow(color: theme.primaryColor.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.category_rounded,
                              color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                                  letterSpacing: 0.5,
                                ),
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
    );

    if (isDrawer) return Drawer(child: content);
    return Flexible(flex: 2, child: content);
  }

  Widget _buildOrderSidebar(BuildContext context, WidgetRef ref, bool isDrawer) {
    final cart = ref.watch(cartProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final theme = Theme.of(context);

    final content = ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: isDrawer ? 320 : null,
          decoration: BoxDecoration(
            color: isDrawer 
                ? theme.cardColor.withValues(alpha: 0.9) 
                : theme.cardColor.withValues(alpha: 0.4),
            border: isDrawer ? null : Border(left: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long_rounded, color: theme.primaryColor),
                        const SizedBox(width: 12),
                        Text('Current Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _showTablePicker(context, ref),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.canvasColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.table_restaurant_rounded, size: 18, color: theme.primaryColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cart.tableName ?? 'Select Table',
                                style: TextStyle(
                                  color: cart.tableName != null ? theme.textTheme.bodyLarge?.color : theme.textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: theme.textTheme.bodyMedium?.color),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: cart.items.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.white10),
                          const SizedBox(height: 16),
                          Text('Cart is empty', style: TextStyle(color: Colors.white24)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () async {
                              if (selectedCategoryId == null) return;
                              final articles = await ref.read(articlesProvider(selectedCategoryId).future);
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
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor, // Indigo like the photo
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${item.quantity}x',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.articleName,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white70),
                                        onPressed: () => ref.read(cartProvider.notifier).removeItem(item.articleId),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  if (item.comments.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      item.comments.join(', '),
                                      style: const TextStyle(fontSize: 11, color: Colors.white70, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16, color: Colors.white60)),
                        Text(
                          '\$${cart.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: cart.items.isEmpty
                          ? null
                          : () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen())),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        elevation: 0,
                        backgroundColor: AppTheme.primaryColor,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: cart.items.isEmpty ? null : () => _quickSave(context, ref),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.5), width: 2),
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Quick Save & New', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: cart.items.isEmpty ? null : () => _cancelOrder(context, ref),
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text('Cancel Order', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.withValues(alpha: 0.8),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isDrawer) return Drawer(child: content);
    return Flexible(flex: 2, child: content);
  }

  Widget _buildArticlesGrid(BuildContext context, WidgetRef ref, String? selectedCategoryId, OrderModel cart) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 1200 ? 5 : (constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 3 : 2));
        
        return selectedCategoryId == null
            ? const Center(child: Text('Select a category'))
            : ref.watch(articlesProvider(selectedCategoryId)).when(
                  data: (articles) => GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
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
    );
  }

  void _quickSave(BuildContext context, WidgetRef ref) async {
    final cart = ref.read(cartProvider);
    
    if (cart.tableName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a table first! 🏢')),
      );
      _showTablePicker(context, ref);
      return;
    }

    try {
      final finalOrder = cart.copyWith(
        timestamp: DateTime.now(), 
        status: OrderStatus.pending, // Pending order for the table
        tip: 0.0,
      );
      await ref.read(orderServiceProvider).completeOrder(finalOrder);
      ref.read(cartProvider.notifier).clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order saved to table successfully! 🏢🚀')),
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

  void _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Cancel Order?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to cancel the current order? This cannot be undone.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, Keep Order', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
       ref.read(cartProvider.notifier).clear();
       if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order cancelled and cleared 🗑️')),
          );
       }
    }
  }

  void _showTablePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const Text('Select Table', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: 20, // 20 tables as example
                itemBuilder: (context, index) {
                  final tableName = 'Table ${index + 1}';
                  return InkWell(
                    onTap: () {
                      ref.read(cartProvider.notifier).setTable(tableName);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Text(tableName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
    final theme = Theme.of(context);
    
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
            color: widget.isSelected ? theme.primaryColor : theme.cardColor,
            borderRadius: BorderRadius.circular(20), // More rounded
            border: Border.all(
              color: widget.isSelected ? theme.primaryColor : theme.dividerColor.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
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
                          color: widget.isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${widget.article.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isSelected ? Colors.white.withValues(alpha: 0.8) : theme.textTheme.bodyMedium?.color,
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
