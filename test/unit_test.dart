import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/models/models.dart';

void main() {
  group('Habit model', () {
    test('constructs with default values', () {
      final habit = Habit(
        id: 'abc',
        name: 'Exercise',
        color: 0xFF6366F1,
        createdDate: DateTime(2024, 1, 15),
      );

      expect(habit.id, 'abc');
      expect(habit.name, 'Exercise');
      expect(habit.color, 0xFF6366F1);
      expect(habit.isActive, true);
      expect(habit.targetDays, 7);
    });

    test('constructs with custom targetDays', () {
      final habit = Habit(
        id: 'abc',
        name: 'Exercise',
        color: 0xFF6366F1,
        createdDate: DateTime(2024, 1, 15),
        targetDays: 5,
      );
      expect(habit.targetDays, 5);
    });

    test('toMap includes targetDays', () {
      final habit = Habit(
        id: 'abc',
        name: 'Exercise',
        color: 0xFF6366F1,
        createdDate: DateTime(2024, 1, 15),
        targetDays: 3,
      );
      final map = habit.toMap();
      expect(map['targetDays'], 3);
      expect(map['id'], 'abc');
      expect(map['name'], 'Exercise');
      expect(map['isActive'], 1);
    });

    test('fromMap restores all fields', () {
      final original = Habit(
        id: 'xyz',
        name: 'Read',
        color: 0xFFEC4899,
        createdDate: DateTime(2024, 3, 8),
        isActive: true,
        targetDays: 5,
      );
      final restored = Habit.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.color, original.color);
      expect(restored.isActive, original.isActive);
      expect(restored.targetDays, original.targetDays);
    });

    test('fromMap defaults targetDays to 7 when missing', () {
      final map = {
        'id': 'abc',
        'name': 'Meditate',
        'color': 0xFF6366F1,
        'createdDate': DateTime(2024, 1, 15).toIso8601String(),
        'isActive': 1,
        // no targetDays key — simulates old DB rows before migration
      };
      final habit = Habit.fromMap(map);
      expect(habit.targetDays, 7);
    });

    test('copyWith updates only specified fields', () {
      final original = Habit(
        id: 'abc',
        name: 'Exercise',
        color: 0xFF6366F1,
        createdDate: DateTime(2024, 1, 15),
        targetDays: 5,
      );
      final updated = original.copyWith(name: 'Run', targetDays: 3);

      expect(updated.name, 'Run');
      expect(updated.targetDays, 3);
      expect(updated.id, original.id);
      expect(updated.color, original.color);
    });

    test('isActive serialises correctly', () {
      final activeHabit = Habit(
        id: '1',
        name: 'A',
        color: 0,
        createdDate: DateTime.now(),
        isActive: true,
      );
      final inactiveHabit = Habit(
        id: '2',
        name: 'B',
        color: 0,
        createdDate: DateTime.now(),
        isActive: false,
      );

      expect(activeHabit.toMap()['isActive'], 1);
      expect(inactiveHabit.toMap()['isActive'], 0);
      expect(Habit.fromMap(activeHabit.toMap()).isActive, true);
      expect(Habit.fromMap(inactiveHabit.toMap()).isActive, false);
    });
  });

  group('DailyEntry model', () {
    test('constructs correctly', () {
      final entry = DailyEntry(
        habitId: 'habit1',
        date: DateTime(2024, 3, 8),
        isCompleted: true,
      );
      expect(entry.habitId, 'habit1');
      expect(entry.isCompleted, true);
    });

    test('dateKey format is year-month-day', () {
      final entry = DailyEntry(
        habitId: 'h1',
        date: DateTime(2024, 3, 8),
        isCompleted: false,
      );
      expect(entry.dateKey, '2024-3-8');
    });

    test('dateKey with single-digit month and day', () {
      final entry = DailyEntry(
        habitId: 'h1',
        date: DateTime(2024, 1, 5),
        isCompleted: false,
      );
      expect(entry.dateKey, '2024-1-5');
    });

    test('toMap and fromMap round-trip', () {
      final original = DailyEntry(
        habitId: 'habit1',
        date: DateTime(2024, 3, 8),
        isCompleted: true,
      );
      final map = original.toMap();
      expect(map['isCompleted'], 1);

      final restored = DailyEntry.fromMap({
        ...map,
        'habitId': 'habit1',
      });
      expect(restored.habitId, original.habitId);
      expect(restored.isCompleted, original.isCompleted);
    });

    test('copyWith updates fields', () {
      final entry = DailyEntry(
        habitId: 'h1',
        date: DateTime(2024, 1, 1),
        isCompleted: false,
      );
      final updated = entry.copyWith(isCompleted: true);
      expect(updated.isCompleted, true);
      expect(updated.habitId, entry.habitId);
    });
  });

  group('Habit weekly target logic', () {
    test('targetDays clamps to valid range in usage', () {
      // Test that targetDays values 1..7 are all valid
      for (int t = 1; t <= 7; t++) {
        final h = Habit(
          id: 't$t',
          name: 'Habit $t',
          color: 0,
          createdDate: DateTime.now(),
          targetDays: t,
        );
        expect(h.targetDays, t);
      }
    });
  });
}
