import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/article_model.dart';
import '../../core/models/comment_config.dart';
import '../../core/models/recipe_ingredient.dart';
import 'widgets/ingredient_selector.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/pos/pos_provider.dart';

class ArticleFormScreen extends ConsumerStatefulWidget {
  final ArticleModel? article;
  final String? categoryId;
  final bool initialIsStockTracked;

  const ArticleFormScreen({
    super.key, 
    this.article, 
    this.categoryId,
    this.initialIsStockTracked = false,
  });

  @override
  ConsumerState<ArticleFormScreen> createState() => _ArticleFormScreenState();

}

class _ArticleFormScreenState extends ConsumerState<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late TextEditingController _priceController;
  String? _selectedCategoryId;
  late CommentConfig _commentConfig;
  
  bool _isComposite = false;
  List<RecipeIngredient> _recipe = [];
  bool _isSold = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.article?.name ?? '';
    _selectedCategoryId = widget.article?.categoryId ?? widget.categoryId;
    _priceController = TextEditingController(text: widget.article?.price.toString() ?? '');
    _commentConfig = widget.article?.commentConfig ?? const CommentConfig();
    _isComposite = widget.article?.isComposite ?? false;
    _recipe = List.from(widget.article?.recipe ?? []);
    _isSold = true;
  }
  
  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final data = {
        'name': _name.trim(),
        'price': double.parse(_priceController.text),
        'categoryId': _selectedCategoryId,
        'commentConfig': _commentConfig.toJson(),
        'totalProfit': widget.article?.totalProfit ?? 0.0,
        'isComposite': _isComposite,
        'recipe': _recipe.map((e) => e.toJson()).toList(),
        'isSold': _isSold,
      };

      if (widget.article == null) {
        await FirebaseFirestore.instance.collection('articles').add(data);
      } else {
        await FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.article!.id)
            .update(data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddIngredientDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Ingredient'),
        content: SizedBox(
          width: double.maxFinite,
          child: IngredientSelector(
            excludeId: widget.article?.id,
            onSelected: (id, name, type) {
              Navigator.pop(context);
              _addIngredient(id, name, type);
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }

  void _addIngredient(String id, String name, IngredientType type) {
    showDialog(
      context: context,
      builder: (context) {
        final qtyController = TextEditingController();
        return AlertDialog(
          title: Text('Quantity of $name'),
          content: TextFormField(
            controller: qtyController,
            decoration: InputDecoration(labelText: 'Quantity ${type == IngredientType.article ? '(servings/pieces)' : ''}'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(qtyController.text);
                if (qty != null) {
                  setState(() {
                    _recipe.add(RecipeIngredient(
                      id: id,
                      name: name,
                      quantity: qty,
                      type: type,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _importFromStock() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Stock Product'),
        content: SizedBox(
          width: double.maxFinite,
          child: IngredientSelector(
            onSelected: (id, name, type) {
              if (type == IngredientType.article) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a Stock item, not an article')));
                return;
              }
              Navigator.pop(context);
              setState(() {
                _name = name;
                _isComposite = true;
                _recipe = [RecipeIngredient(id: id, name: name, quantity: 1.0, type: type)];
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article == null ? 'Add Article' : 'Edit Article')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey(_name),
                      initialValue: _name,
                      decoration: const InputDecoration(labelText: 'Article Name'),
                      onChanged: (val) => _name = val,
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Initialize from Stock',
                    icon: const Icon(Icons.inventory_2, color: Colors.blue),
                    onPressed: _importFromStock,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              const Text('Category', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              ref.watch(categoriesProvider).when(
                data: (categories) => DropdownButtonFormField<String>(
                  key: ValueKey(_selectedCategoryId),
                  initialValue: _selectedCategoryId,
                  hint: const Text('Select Category'),
                  items: categories.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (val) => val == null ? 'Category Required' : null,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error loading categories: $e'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Selling Price', prefixText: '\$'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid price' : null,
              ),
              const SizedBox(height: 32),

              const Text('Stock Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Uses Recipe / Ingredients?'),
                subtitle: const Text('Link this menu item to stock products or other items'),
                value: _isComposite,
                onChanged: (val) => setState(() => _isComposite = val),
              ),

              if (_isComposite) ...[
                const SizedBox(height: 16),
                const Text('Ingredients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ..._recipe.map((ingredient) => Card(
                  key: ValueKey(ingredient.id),
                  child: ListTile(
                    leading: Icon(
                      ingredient.type == IngredientType.stock 
                          ? Icons.inventory_2 
                          : Icons.restaurant_menu,
                      size: 20,
                      color: Colors.grey,
                    ),
                    title: Text(ingredient.name),
                    subtitle: Text('Quantity: ${ingredient.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _recipe.remove(ingredient)),
                    ),
                  ),
                )),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Ingredient'),
                  onPressed: _showAddIngredientDialog,
                ),
              ],
              
              const SizedBox(height: 32),
              const Text('Comment Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<CommentType>(
                key: ValueKey(_commentConfig.commentType),
                initialValue: _commentConfig.commentType,
                decoration: const InputDecoration(labelText: 'Comment Interaction'),
                items: CommentType.values.map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t.name.toUpperCase()),
                )).toList(),
                onChanged: (val) => setState(() => _commentConfig = _commentConfig.copyWith(commentType: val!)),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Required Comment'),
                subtitle: const Text('Employee must add a note before adding to cart'),
                value: _commentConfig.isRequired,
                onChanged: (val) => setState(() => _commentConfig = _commentConfig.copyWith(isRequired: val)),
              ),
              
              if (_commentConfig.commentType != CommentType.none) ...[
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _commentConfig.commentOptions.join(', '),
                  decoration: const InputDecoration(labelText: 'Options (comma separated)'),
                  onChanged: (val) {
                    final options = val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                    setState(() => _commentConfig = _commentConfig.copyWith(commentOptions: options));
                  },
                ),
              ],
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                    : const Text('Save Article'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
