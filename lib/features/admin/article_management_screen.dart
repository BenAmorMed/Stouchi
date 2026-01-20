import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../pos/pos_provider.dart';
import 'article_form_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleManagementScreen extends ConsumerWidget {
  const ArticleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Articles'),
        actions: [
          categoriesAsync.when(
            data: (categories) => DropdownButton<String>(
              value: selectedCategoryId ?? (categories.isNotEmpty ? categories[0].id : null),
              dropdownColor: AppTheme.surfaceColor,
              items: categories.map((c) => DropdownMenuItem(
                value: c.id,
                child: Text(c.name),
              )).toList(),
              onChanged: (val) => ref.read(selectedCategoryIdProvider.notifier).state = val,
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: selectedCategoryId == null
          ? const Center(child: Text('Select a category to view articles'))
          : ref.watch(articlesProvider(selectedCategoryId)).when(
                data: (articles) {
                  final totalProfit = articles.fold(0.0, (acc, a) => acc + a.totalProfit);
                  final totalItems = articles.length;
                  
                  return Column(
                    children: [
                       Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Card(
                           color: AppTheme.surfaceColor,
                           child: Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 Column(
                                   children: [
                                     const Text('Articles', style: TextStyle(color: Colors.grey)),
                                     Text('$totalItems', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                   ],
                                 ),
                                 Column(
                                   children: [
                                     const Text('Category Profit', style: TextStyle(color: Colors.grey)),
                                     Text('\$${totalProfit.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                       Expanded(
                         child: ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return ListTile(
                              title: Text(article.name),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('\$${article.price.toStringAsFixed(2)}'),
                                    if (article.isComposite)
                                      const Text(
                                        'Tracks Stock',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                                      ),
                                    if (article.totalProfit > 0)
                                       Text(
                                        'Profit: \$${article.totalProfit.toStringAsFixed(2)}',
                                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                  ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ArticleFormScreen(article: article),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('articles')
                                          .doc(article.id)
                                          .delete();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                                         ),
                       ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedCategoryId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleFormScreen(categoryId: selectedCategoryId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a category first')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
