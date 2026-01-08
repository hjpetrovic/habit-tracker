import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/habit_service.dart';

// Habit List State
class HabitListState {
  final List<Habit> habits;
  final bool isLoading;
  final String? error;

  HabitListState({
    this.habits = const [],
    this.isLoading = false,
    this.error,
  });

  HabitListState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? error,
  }) {
    return HabitListState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Habit List Notifier
class HabitListNotifier extends StateNotifier<HabitListState> {
  final HabitService _habitService;

  HabitListNotifier(this._habitService) : super(HabitListState()) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final habits = await _habitService.getHabits();
      state = state.copyWith(habits: habits, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addHabit(Habit habit) async {
    try {
      await _habitService.addHabit(habit);
      await loadHabits();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitService.updateHabit(habit);
      await loadHabits();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _habitService.deleteHabit(habitId);
      await loadHabits();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Providers
final habitListProvider = StateNotifierProvider<HabitListNotifier, HabitListState>((ref) {
  final habitService = ref.watch(habitServiceProvider);
  return HabitListNotifier(habitService);
});

// Daily Entries State
class DailyEntriesState {
  final Map<String, Map<String, DailyEntry>> entries;
  final bool isLoading;

  DailyEntriesState({
    this.entries = const {},
    this.isLoading = false,
  });

  DailyEntriesState copyWith({
    Map<String, Map<String, DailyEntry>>? entries,
    bool? isLoading,
  }) {
    return DailyEntriesState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Daily Entries Notifier
class DailyEntriesNotifier extends StateNotifier<DailyEntriesState> {
  final HabitService _habitService;

  DailyEntriesNotifier(this._habitService) : super(DailyEntriesState());

  Future<void> loadEntriesForMonth(String habitId, int year, int month) async {
    try {
      final entries = await _habitService.getDailyEntries(habitId, year, month);
      final entryMap = <String, Map<String, DailyEntry>>{};
      
      for (var entry in entries) {
        if (!entryMap.containsKey(entry.habitId)) {
          entryMap[entry.habitId] = {};
        }
        entryMap[entry.habitId]![entry.dateKey] = entry;
      }

      final currentEntries = Map<String, Map<String, DailyEntry>>.from(state.entries);
      currentEntries[habitId] = entryMap[habitId] ?? {};
      
      state = state.copyWith(entries: currentEntries);
    } catch (e) {
      print('Error loading entries: $e');
    }
  }

  Future<void> toggleEntry(String habitId, DateTime date) async {
    final entry = await _habitService.getDailyEntry(habitId, date);
    final newStatus = entry == null ? true : !entry.isCompleted;
    
    try {
      await _habitService.toggleDailyEntry(habitId, date, newStatus);
      
      final currentEntries = Map<String, Map<String, DailyEntry>>.from(state.entries);
      if (!currentEntries.containsKey(habitId)) {
        currentEntries[habitId] = {};
      }
      
      currentEntries[habitId]![date.year.toString() + date.month.toString() + date.day.toString()] = DailyEntry(
        habitId: habitId,
        date: date,
        isCompleted: newStatus,
      );
      
      state = state.copyWith(entries: currentEntries);
    } catch (e) {
      print('Error toggling entry: $e');
    }
  }

  bool isCompleted(String habitId, DateTime date) {
    return state.entries[habitId]?[dateKey(date)]?.isCompleted ?? false;
  }

  String dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}

final dailyEntriesProvider = StateNotifierProvider<DailyEntriesNotifier, DailyEntriesState>((ref) {
  final habitService = ref.watch(habitServiceProvider);
  return DailyEntriesNotifier(habitService);
});

// Theme State
class ThemeState {
  final bool isDarkMode;

  ThemeState({this.isDarkMode = false});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState());

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
