import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/article_model.dart';
import '../../core/models/comment_config.dart';

class ArticleFormScreen extends StatefulWidget {
  final ArticleModel? article;
  final String? categoryId;

  const ArticleFormScreen({super.key, this.article, this.categoryId});

  @override
  State<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name; // Changed from TextEditingController to String
  late TextEditingController _priceController;
  late CommentConfig _commentConfig;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.article?.name ?? ''; // Initialize _name
    _priceController = TextEditingController(text: widget.article?.price.toString() ?? '');
    _commentConfig = widget.article?.commentConfig ?? const CommentConfig();
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
        'name': _name.trim(), // Use _name directly
        'price': double.parse(_priceController.text),
        'categoryId': widget.article?.categoryId ?? widget.categoryId,
        'commentConfig': _commentConfig.toJson(),
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
              TextFormField(
                initialValue: _name, // Changed from controller to initialValue
                decoration: const InputDecoration(labelText: 'Article Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onChanged: (val) => setState(() => _name = val), // Add onChanged to update _name
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', prefixText: '\$'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid price' : null,
              ),
              const SizedBox(height: 32),
              
              const Text('Comment Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Comments'),
                value: _commentConfig.hasComments,
                onChanged: (val) => setState(() => _commentConfig = _commentConfig.copyWith(hasComments: val)),
              ),
              
              if (_commentConfig.hasComments) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<CommentType>(
                  initialValue: _commentConfig.commentType,
                  decoration: const InputDecoration(labelText: 'Comment Type'),
                  items: CommentType.values.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  )).toList(),
                  onChanged: (val) => setState(() => _commentConfig = _commentConfig.copyWith(commentType: val!)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _commentConfig.commentOptions.join(', '),
                  decoration: const InputDecoration(
                    labelText: 'Options (comma separated)',
                    hintText: 'e.g. normal, serie, allonge',
                  ),
                  onChanged: (val) => setState(() {
                    final options = val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                    _commentConfig = _commentConfig.copyWith(commentOptions: options);
                  }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _commentConfig.defaultOption,
                  decoration: const InputDecoration(labelText: 'Default Option'),
                  onChanged: (val) => setState(() => _commentConfig = _commentConfig.copyWith(defaultOption: val.trim())),
                ),
              ],
              
              const SizedBox(height: 48),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save Article'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
