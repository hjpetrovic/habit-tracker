import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_providers.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final habits = ref.read(habitListProvider);
    for (final habit in habits.habits) {
      await ref.read(dailyEntriesProvider.notifier).loadEntriesForMonth(
            habit.id,
            DateTime.now().year,
            DateTime.now().month,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitList = ref.watch(habitListProvider);
    final dailyEntries = ref.watch(dailyEntriesProvider);
    final themeState = ref.watch(themeProvider);
    final isDark = themeState.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: habitList.isLoading
          ? const Center(child: CircularProgressIndicator())
          : habitList.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? Colors.red.shade400 : Colors.red.shade700,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${habitList.error}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(habitListProvider.notifier).loadHabits(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : habitList.habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.track_changes,
                            size: 80,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No habits yet',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to add your first habit',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: habitList.habits.length,
                      itemBuilder: (context, index) {
                        final habit = habitList.habits[index];
                        final habitEntries = <DateTime, bool>{};
                        
                        if (dailyEntries.entries.containsKey(habit.id)) {
                          final entries = dailyEntries.entries[habit.id]!;
                          for (final entry in entries.values) {
                            habitEntries[DateTime(
                              entry.date.year,
                              entry.date.month,
                              entry.date.day,
                            )] = entry.isCompleted;
                          }
                        }
                        
                        return HabitCard(
                          habit: habit,
                          entries: habitEntries,
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitDetailScreen(habit: habit),
                              ),
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Habit'),
                                content: Text('Are you sure you want to delete "${habit.name}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            
                            if (confirm == true) {
                              await ref.read(habitListProvider.notifier).deleteHabit(habit.id);
                            }
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
          if (result == true) {
            await ref.read(habitListProvider.notifier).loadHabits();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
