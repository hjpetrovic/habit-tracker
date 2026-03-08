import 'package:flutter/material.dart';

class TargetDaysPicker extends StatelessWidget {
  final int targetDays;
  final ValueChanged<int> onChanged;
  final bool isDark;

  const TargetDaysPicker({
    super.key,
    required this.targetDays,
    required this.onChanged,
    required this.isDark,
  });

  String get _targetLabel {
    if (targetDays == 7) return 'Every day';
    if (targetDays == 1) return '1 day / week';
    return '$targetDays days / week';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Target',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _targetLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(7, (i) {
            final day = i + 1;
            final selected = day <= targetDays;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(day),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.primary
                        : (isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      ['S', 'M', 'T', 'W', 'T', 'F', 'S'][i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? Colors.white
                            : (isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap to set how many days per week you want to complete this habit',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
