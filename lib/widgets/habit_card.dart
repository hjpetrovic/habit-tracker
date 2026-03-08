import 'package:flutter/material.dart';
import '../models/models.dart';
import 'contribution_grid.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final Map<DateTime, bool> entries;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleToday;
  final bool isDark;

  const HabitCard({
    super.key,
    required this.habit,
    required this.entries,
    required this.onTap,
    required this.onDelete,
    required this.onToggleToday,
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

  bool get _isTodayDone {
    final today = DateTime.now();
    return entries[DateTime(today.year, today.month, today.day)] ?? false;
  }

  /// Completions in the current Mon–Sun week up to today.
  int get _thisWeekCompletions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    int count = 0;
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      if (day.isAfter(today)) break;
      if (entries[day] ?? false) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.color);
    final streak = _currentStreak;
    final todayDone = _isTodayDone;
    final weeklyDone = _thisWeekCompletions;
    final weeklyTarget = habit.targetDays;
    final weeklyProgress =
        weeklyTarget > 0 ? weeklyDone / weeklyTarget : 0.0;
    final onTarget = weeklyDone >= weeklyTarget;

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
                  // Tap icon to mark today done/undone
                  GestureDetector(
                    onTap: onToggleToday,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: todayDone
                            ? color
                            : color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          todayDone
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: todayDone
                              ? (color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white)
                              : color,
                          size: 26,
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
                              color: isDark
                                  ? Colors.orange
                                  : Colors.orange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streak day${streak == 1 ? '' : 's'} streak',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isDark
                                        ? Colors.orange.shade400
                                        : Colors.orange.shade700,
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
                      color: isDark
                          ? Colors.red.shade400
                          : Colors.red.shade700,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Weekly target progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'This week',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                  ),
                  Row(
                    children: [
                      if (onTarget) ...[
                        Icon(
                          Icons.emoji_events,
                          size: 14,
                          color: isDark
                              ? Colors.amber.shade400
                              : Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '$weeklyDone / $weeklyTarget days',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: onTarget
                                      ? (isDark
                                          ? Colors.green.shade400
                                          : Colors.green.shade700)
                                      : (isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700),
                                ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: weeklyProgress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    onTarget ? Colors.green : color,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
