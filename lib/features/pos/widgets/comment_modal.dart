import 'package:flutter/material.dart';
import '../../../core/models/article_model.dart';
import '../../../core/models/comment_config.dart';
import '../../../core/theme/app_theme.dart';

class CommentSelectionModal extends StatefulWidget {
  final ArticleModel article;
  final List<String> initialComments;
  final int initialQuantity;
  final Function(int quantity, List<String> comments) onConfirm;

  const CommentSelectionModal({
    super.key,
    required this.article,
    required this.initialComments,
    required this.initialQuantity,
    required this.onConfirm,
  });

  @override
  State<CommentSelectionModal> createState() => _CommentSelectionModalState();
}

class _CommentSelectionModalState extends State<CommentSelectionModal> {
  late List<String> _selectedComments;
  late TextEditingController _customCommentController;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _selectedComments = List<String>.from(widget.initialComments);
    
    final config = widget.article.commentConfig;
    final customTag = config.commentOptions.toSet();
    final customText = _selectedComments.where((c) => !customTag.contains(c)).join(' ');
    
    _customCommentController = TextEditingController(text: customText);
    
    // Clean up selected comments to only include options
    _selectedComments = _selectedComments.where((c) => customTag.contains(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.article.commentConfig;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.article.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, color: AppTheme.primaryColor),
                      onPressed: () => setState(() {
                        if (_quantity > 1) _quantity--;
                      }),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, color: AppTheme.primaryColor),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // List Options
          if (config.commentType == CommentType.list || config.commentType == CommentType.both) ...[
            const Text('Options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: config.commentOptions.map((option) {
                final isSelected = _selectedComments.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedComments.add(option);
                      } else {
                        _selectedComments.remove(option);
                      }
                    });
                  },
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Custom Text
          if (config.commentType == CommentType.text || config.commentType == CommentType.both) ...[
            const Text('Custom Instructions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
            const SizedBox(height: 12),
            TextField(
              controller: _customCommentController,
              decoration: InputDecoration(
                hintText: 'e.g. Extra hot, sugar on the side...',
                hintStyle: TextStyle(color: Colors.white30),
                fillColor: Colors.black26,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),
          ],
          
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final finalComments = [..._selectedComments];
              final customText = _customCommentController.text.trim();
              if (customText.isNotEmpty) {
                finalComments.add(customText);
              }
              widget.onConfirm(_quantity, finalComments); 
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleAt(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Confirm Changes'),
          ),
        ],
      ),
    );
  }
}
