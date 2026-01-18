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
                data: (articles) => ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ListTile(
                      title: Text(article.name),
                      subtitle: Text('\$${article.price.toStringAsFixed(2)}'),
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
