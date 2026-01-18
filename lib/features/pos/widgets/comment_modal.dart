import 'package:flutter/material.dart';
import '../../../core/models/article_model.dart';
import '../../../core/models/comment_config.dart';
import '../../../core/theme/app_theme.dart';

class CommentSelectionModal extends StatefulWidget {
  final ArticleModel article;
  final List<String> initialComments;
  final Function(List<String>) onConfirm;

  const CommentSelectionModal({
    super.key,
    required this.article,
    required this.initialComments,
    required this.onConfirm,
  });

  @override
  State<CommentSelectionModal> createState() => _CommentSelectionModalState();
}

class _CommentSelectionModalState extends State<CommentSelectionModal> {
  late List<String> _selectedComments;
  late TextEditingController _customCommentController;

  @override
  void initState() {
    super.initState();
    _selectedComments = List<String>.from(widget.initialComments);
    _customCommentController = TextEditingController(
      text: widget.article.commentConfig.commentType == CommentType.text
          ? (widget.initialComments.isNotEmpty ? widget.initialComments.first : '')
          : '',
    );
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
          Text(
            'Comments for ${widget.article.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (config.commentType == CommentType.list)
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
                );
              }).toList(),
            )
          else
            TextField(
              controller: _customCommentController,
              decoration: const InputDecoration(
                hintText: 'Enter custom instruction...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (config.commentType == CommentType.text) {
                widget.onConfirm([_customCommentController.text.trim()]);
              } else {
                widget.onConfirm(_selectedComments);
              }
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
