import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/main.dart';

void main() {
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
}
