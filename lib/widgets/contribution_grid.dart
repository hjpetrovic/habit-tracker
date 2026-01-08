import 'package:flutter/material.dart';

class ContributionGrid extends StatelessWidget {
  final Color color;
  final Map<DateTime, bool> entries;
  final bool isDark;

  const ContributionGrid({
    super.key,
    required this.color,
    required this.entries,
    this.isDark = false,
  });

  List<DateTime> _getLast30Days() {
    final now = DateTime.now();
    final List<DateTime> days = [];
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      days.add(DateTime(date.year, date.month, date.day));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getLast30Days();
    
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: days.map((date) {
              final isCompleted = entries[date] ?? false;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              
              return Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getCellColor(isCompleted),
                  borderRadius: BorderRadius.circular(4),
                  border: isToday
                      ? Border.all(
                          color: isDark ? Colors.white : Colors.black,
                          width: 2,
                        )
                      : null,
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: _getTextColor(isCompleted),
                      )
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getCellColor(bool isCompleted) {
    if (!isCompleted) {
      return isDark 
          ? Colors.grey.shade800 
          : Colors.grey.shade200;
    }
    return color;
  }

  Color _getTextColor(bool isCompleted) {
    if (!isCompleted) {
      return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    }
    
    // Calculate contrast
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
