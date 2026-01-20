import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/recipe_ingredient.dart';

class IngredientSelector extends StatefulWidget {
  final String? excludeId;
  final Function(String id, String name, IngredientType type) onSelected;

  const IngredientSelector({super.key, required this.onSelected, this.excludeId});

  @override
  State<IngredientSelector> createState() => _IngredientSelectorState();
}

class _IngredientSelectorState extends State<IngredientSelector> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search stock or articles...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('stock_products').snapshots(),
            builder: (context, stockSnapshot) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('articles').snapshots(),
                builder: (context, articleSnapshot) {
                  if (!stockSnapshot.hasData || !articleSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final query = _searchQuery.toLowerCase();
                  
                  final stocks = stockSnapshot.data!.docs.map((doc) => {
                    'id': doc.id,
                    'name': doc['name'] as String,
                    'type': IngredientType.stock,
                    'info': 'Stock (${doc['unit']})',
                  }).toList();

                  final articles = articleSnapshot.data!.docs
                      .where((doc) => doc.id != widget.excludeId)
                      .map((doc) => {
                    'id': doc.id,
                    'name': doc['name'] as String,
                    'type': IngredientType.article,
                    'info': 'Article',
                  }).toList();

                  final combined = [...stocks, ...articles]
                      .where((item) => (item['name'] as String).toLowerCase().contains(query))
                      .toList();

                  if (combined.isEmpty) {
                    return const Center(child: Text('No matches found'));
                  }

                  return ListView.builder(
                    itemCount: combined.length,
                    itemBuilder: (context, index) {
                      final item = combined[index];
                      return ListTile(
                        title: Text(item['name'] as String),
                        subtitle: Text(item['info'] as String),
                        leading: Icon(
                          item['type'] == IngredientType.stock 
                              ? Icons.inventory_2 
                              : Icons.restaurant_menu,
                          color: item['type'] == IngredientType.stock ? Colors.blue : Colors.orange,
                        ),
                        onTap: () => widget.onSelected(
                          item['id'] as String, 
                          item['name'] as String, 
                          item['type'] as IngredientType
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
