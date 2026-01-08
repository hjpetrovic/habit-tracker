import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ColorPickerWidget extends StatelessWidget {
  final int selectedColor;
  final Function(int) onColorSelected;
  final bool isDark;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppColors.habitColors.map((color) {
            final isSelected = color.value == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(color.value),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: _getTextColor(color),
                        size: 28,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getTextColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
