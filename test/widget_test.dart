import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/models/models.dart';
import 'package:habit_tracker/services/database_service.dart';
import 'package:habit_tracker/widgets/habit_card.dart';
import 'package:habit_tracker/widgets/target_days_picker.dart';

void main() {
  setUpAll(() {
    // Use FFI-based SQLite so sqflite works in the Linux CI test environment.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Reset the DB singleton so each test gets a fresh in-memory database.
    DatabaseService.resetForTesting();
    // Provide an empty SharedPreferences so ThemeNotifier doesn't throw.
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await DatabaseService.instance.close();
    DatabaseService.resetForTesting();
  });

  group('App startup', () {
    testWidgets('App starts and displays HomeScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HabitTrackerApp(),
        ),
      );

      expect(find.text('Habit Tracker'), findsOneWidget);
      expect(find.text('No habits yet'), findsOneWidget);
      expect(find.text('Tap + to add your first habit'), findsOneWidget);
    });

    testWidgets('App has navigation between Home and Settings', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HabitTrackerApp(),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('No habits yet'), findsOneWidget);
    });

    testWidgets('Theme toggle works in Settings', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HabitTrackerApp(),
        ),
      );

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
    });

    testWidgets('FAB opens AddHabitScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HabitTrackerApp(),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add New Habit'), findsOneWidget);
      expect(find.text('Habit Name'), findsOneWidget);
      expect(find.text('Weekly Target'), findsOneWidget);
    });

    testWidgets('AddHabitScreen validates empty name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HabitTrackerApp(),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try saving without a name
      await tester.tap(find.text('Save Habit'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a habit name'), findsOneWidget);
    });

    testWidgets('AddHabitScreen validates short name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HabitTrackerApp(),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'A');
      await tester.tap(find.text('Save Habit'));
      await tester.pumpAndSettle();

      expect(find.text('Habit name must be at least 2 characters'), findsOneWidget);
    });
  });

  group('HabitCard widget', () {
    Habit _makeHabit({int targetDays = 5}) {
      return Habit(
        id: 'test-id',
        name: 'Exercise',
        color: const Color(0xFF6366F1).value,
        createdDate: DateTime(2024, 1, 1),
        targetDays: targetDays,
      );
    }

    testWidgets('shows habit name and streak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCard(
              habit: _makeHabit(),
              entries: const {},
              onTap: () {},
              onDelete: () {},
              onToggleToday: () {},
            ),
          ),
        ),
      );

      expect(find.text('Exercise'), findsOneWidget);
      expect(find.textContaining('streak'), findsOneWidget);
    });

    testWidgets('shows weekly progress bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCard(
              habit: _makeHabit(targetDays: 5),
              entries: const {},
              onTap: () {},
              onDelete: () {},
              onToggleToday: () {},
            ),
          ),
        ),
      );

      expect(find.text('This week'), findsOneWidget);
      expect(find.text('0 / 5 days'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows trophy when weekly target met', (WidgetTester tester) async {
      final today = DateTime.now();
      final entries = <DateTime, bool>{};
      // Fill the current week
      for (int i = 0; i < 5; i++) {
        final day = today.subtract(Duration(days: today.weekday - 1 - i));
        entries[DateTime(day.year, day.month, day.day)] = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCard(
              habit: _makeHabit(targetDays: 5),
              entries: entries,
              onTap: () {},
              onDelete: () {},
              onToggleToday: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('check-in icon toggles appearance', (WidgetTester tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitCard(
              habit: _makeHabit(),
              entries: const {},
              onTap: () {},
              onDelete: () {},
              onToggleToday: () {
                toggled = true;
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.circle_outlined));
      await tester.pump();

      expect(toggled, true);
    });
  });

  group('TargetDaysPicker widget', () {
    testWidgets('shows Weekly Target label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TargetDaysPicker(
              targetDays: 7,
              onChanged: (_) {},
              isDark: false,
            ),
          ),
        ),
      );

      expect(find.text('Weekly Target'), findsOneWidget);
      expect(find.text('Every day'), findsOneWidget);
    });

    testWidgets('shows correct label for 1 day target', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TargetDaysPicker(
              targetDays: 1,
              onChanged: (_) {},
              isDark: false,
            ),
          ),
        ),
      );

      expect(find.text('1 day / week'), findsOneWidget);
    });

    testWidgets('shows correct label for partial week target', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TargetDaysPicker(
              targetDays: 5,
              onChanged: (_) {},
              isDark: false,
            ),
          ),
        ),
      );

      expect(find.text('5 days / week'), findsOneWidget);
    });

    testWidgets('fires onChanged callback when day tapped', (WidgetTester tester) async {
      int selected = 7;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TargetDaysPicker(
              targetDays: 7,
              onChanged: (v) {
                selected = v;
              },
              isDark: false,
            ),
          ),
        ),
      );

      // Tap the first day tile ('S' = 1 day/week)
      final sTiles = find.text('S');
      await tester.tap(sTiles.first);
      await tester.pump();

      expect(selected, 1);
    });
  });
}
