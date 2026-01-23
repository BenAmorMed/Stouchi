import 'package:flutter/material.dart';
import '../../../core/models/article_model.dart';
import '../../../core/models/comment_config.dart';
import '../../../core/theme/app_theme.dart';

class CommentSelectionModal extends StatefulWidget {
  final ArticleModel article;
  final List<String> initialComments;
  final Map<int, List<String>> initialPerUnitComments;
  final double initialQuantity;
  final Function(double quantity, List<String> comments, Map<int, List<String>> perUnitComments) onConfirm;

  const CommentSelectionModal({
    super.key,
    required this.article,
    required this.initialComments,
    this.initialPerUnitComments = const {},
    required this.initialQuantity,
    required this.onConfirm,
  });

  @override
  State<CommentSelectionModal> createState() => _CommentSelectionModalState();
}

class _CommentSelectionModalState extends State<CommentSelectionModal> {
  late List<String> _globalComments;
  late Map<int, List<String>> _perUnitComments;
  late TextEditingController _customCommentController;
  late double _quantity;
  bool _applyToAll = true; // Toggle for applying comments to all or one unit
  int? _selectedUnitIndex; // Which unit to apply comments to (when _applyToAll is false)

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _globalComments = List<String>.from(widget.initialComments);
    _perUnitComments = Map<int, List<String>>.from(widget.initialPerUnitComments);
    
    final config = widget.article.commentConfig;
    final predefinedOptions = config.commentOptions.toSet();
    
    // Extract custom text from global comments
    final customText = _globalComments.where((c) => !predefinedOptions.contains(c)).join(' ');
    
    _customCommentController = TextEditingController(text: customText);
    
    // Clean up global comments to only include predefined options
    _globalComments = _globalComments.where((c) => predefinedOptions.contains(c)).toList();
    
    // Find first unit without comments if quantity > 1
    if (_quantity > 1) {
      for (int i = 0; i < _quantity.toInt(); i++) {
        if (!_perUnitComments.containsKey(i) || _perUnitComments[i]!.isEmpty) {
          _selectedUnitIndex = i;
          break;
        }
      }
      _selectedUnitIndex ??= 0; // Default to first unit
    }
  }

  @override
  void dispose() {
    _customCommentController.dispose();
    super.dispose();
  }

  // Get current active comments (either global or for selected unit)
  List<String> _getCurrentComments() {
    if (_applyToAll) {
      return _globalComments;
    } else if (_selectedUnitIndex != null) {
      return _perUnitComments[_selectedUnitIndex!] ?? [];
    }
    return [];
  }

  // Update comments based on current mode
  void _updateComments(List<String> newComments) {
    setState(() {
      if (_applyToAll) {
        _globalComments = newComments;
      } else if (_selectedUnitIndex != null) {
        _perUnitComments[_selectedUnitIndex!] = newComments;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.article.commentConfig;
    final currentComments = _getCurrentComments();

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
      child: SingleChildScrollView(
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
                          if (_quantity > 1) {
                             _quantity = (_quantity - 1 < 1) ? 1 : _quantity - 1;
                             
                             // Update selected unit index if it's now out of bounds
                             if (_selectedUnitIndex != null && _selectedUnitIndex! >= _quantity.toInt()) {
                               _selectedUnitIndex = _quantity.toInt() - 1;
                             }
                          }
                        }),
                      ),
                      Text(
                        _quantity % 1 == 0 ? _quantity.toInt().toString() : _quantity.toString(),
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
            
            // Apply to all/one toggle (only show if quantity > 1)
            if (_quantity > 1) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Apply comments to:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildToggleButton(
                            label: 'All units',
                            isSelected: _applyToAll,
                            onTap: () => setState(() => _applyToAll = true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildToggleButton(
                            label: 'One unit',
                            isSelected: !_applyToAll,
                            onTap: () => setState(() => _applyToAll = false),
                          ),
                        ),
                      ],
                    ),
                    
                    // Unit selector (only show when "One unit" is selected)
                    if (!_applyToAll) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Select unit:',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(_quantity.toInt(), (index) {
                          final hasComments = _perUnitComments.containsKey(index) && _perUnitComments[index]!.isNotEmpty;
                          final isSelected = _selectedUnitIndex == index;
                          
                          return GestureDetector(
                            onTap: () => setState(() => _selectedUnitIndex = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppTheme.primaryColor 
                                    : AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: hasComments 
                                      ? Colors.greenAccent 
                                      : AppTheme.primaryColor.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Unit ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : AppTheme.textColor,
                                    ),
                                  ),
                                  if (hasComments) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: isSelected ? Colors.white : Colors.greenAccent,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // List Options
            if (config.commentType == CommentType.list || config.commentType == CommentType.both) ...[
              const Text('Predefined Options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: config.commentOptions.map((option) {
                  final isSelected = currentComments.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      final newComments = List<String>.from(currentComments);
                      if (selected) {
                        newComments.add(option);
                      } else {
                        newComments.remove(option);
                      }
                      _updateComments(newComments);
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
                maxLength: config.maxLength,
              ),
            ],
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Collect all comments
                final finalGlobalComments = <String>[];
                final finalPerUnitComments = Map<int, List<String>>.from(_perUnitComments);
                
                // Add custom text if provided
                final customText = _customCommentController.text.trim();
                
                if (_applyToAll) {
                  // Apply to all units (use global comments)
                  finalGlobalComments.addAll(_globalComments);
                  if (customText.isNotEmpty) {
                    finalGlobalComments.add(customText);
                  }
                } else if (_selectedUnitIndex != null) {
                  // Apply to selected unit only
                  final unitComments = List<String>.from(currentComments);
                  if (customText.isNotEmpty && !unitComments.contains(customText)) {
                    unitComments.add(customText);
                  }
                  finalPerUnitComments[_selectedUnitIndex!] = unitComments;
                  
                  // Keep existing global comments
                  finalGlobalComments.addAll(_globalComments);
                }
                
                widget.onConfirm(_quantity, finalGlobalComments, finalPerUnitComments); 
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Confirm Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: isSelected ? 1.0 : 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
