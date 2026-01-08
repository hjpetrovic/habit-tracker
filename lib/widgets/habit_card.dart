import 'package:flutter/material.dart';
import '../models/models.dart';
import 'contribution_grid.dart';
import 'dart:math' as math;

class HabitCard extends StatelessWidget {
  final Habit habit;
  final Map<DateTime, bool> entries;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDark;

  const HabitCard({
    super.key,
    required this.habit,
    required this.entries,
    required this.onTap,
    required this.onDelete,
    this.isDark = false,
  });

  int get _currentStreak {
    int streak = 0;
    DateTime date = DateTime.now();
    
    while (true) {
      final checkDate = DateTime(date.year, date.month, date.day);
      if (entries[checkDate] ?? false) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else if (streak == 0) {
        // Check if today is not completed but we should check yesterday
        date = date.subtract(const Duration(days: 1));
        if (!(entries[DateTime(date.year, date.month, date.day)] ?? false)) {
          break;
        }
      } else {
        break;
      }
    }
    
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.color);
    final streak = _currentStreak;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: isDark ? Colors.orange : Colors.orange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streak day${streak == 1 ? '' : 's'} streak',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDark ? Colors.orange.shade400 : Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: isDark ? Colors.red.shade400 : Colors.red.shade700,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ContributionGrid(
                color: color,
                entries: entries,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
