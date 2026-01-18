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
import '../auth/setup_profile_screen.dart';
import '../auth/auth_provider.dart';
import '../../core/models/user_role.dart';

class POSScreen extends ConsumerWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final cart = ref.watch(cartProvider);
    final profile = ref.watch(userProfileProvider).value;

    // Non-blocking onboarding prompt
    if (profile != null && profile.isFirstLogin && profile.role != UserRole.admin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false, // Force them to at least see it
          builder: (context) => Dialog.fullscreen(
            child: const SetupProfileScreen(),
          ),
        );
      });
    }

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
          // 1. Categories Sidebar (Left)
          Container(
            width: 100,
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
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : AppTheme.mutedTextColor.withValues(alpha: 0.1),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_rounded,
                                color: isSelected ? AppTheme.primaryColor : AppTheme.mutedTextColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
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

          // 2. Articles Grid (Center)
          Expanded(
            child: selectedCategoryId == null
                ? const Center(child: Text('Select a category'))
                : ref.watch(articlesProvider(selectedCategoryId)).when(
                      data: (articles) => GridView.builder(
                        padding: const EdgeInsets.all(24), // Increased padding
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.3, // Adjusted ratio
                          crossAxisSpacing: 24, // Increased spacing
                          mainAxisSpacing: 24,
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
                                // Find item in cart or use default if adding via long press
                                final currentItem = cart.items.firstWhere(
                                  (i) => i.articleId == article.id,
                                  orElse: () => OrderItemModel(
                                    articleId: article.id,
                                    articleName: article.name,
                                    price: article.price,
                                    comments: [article.commentConfig.defaultOption],
                                  ),
                                );
                                
                                // Automatically add if not in cart
                                if (!isInCart) {
                                  ref.read(cartProvider.notifier).toggleArticle(article);
                                }

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent, // For custom shape
                                  builder: (context) => CommentSelectionModal(
                                    article: article,
                                    initialComments: currentItem.comments,
                                    onConfirm: (comments) => ref
                                        .read(cartProvider.notifier)
                                        .updateComments(article.id, comments),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Center(child: Text('Error: $e')),
                    ),
          ),

          // 3. Order Sidebar (Right)
          Container(
            width: 350,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(-5, 0))
              ],
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Current Order',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.articleName),
                        subtitle: Text(item.comments.join(', ')),
                        trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: cart.items.isEmpty
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                                ),
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
