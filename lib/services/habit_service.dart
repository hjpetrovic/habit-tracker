import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'database_service.dart';

class HabitService {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<Habit>> getHabits() async {
    return await _databaseService.getHabits();
  }

  Future<Habit> addHabit(Habit habit) async {
    return await _databaseService.addHabit(habit);
  }

  Future<void> updateHabit(Habit habit) async {
    await _databaseService.updateHabit(habit);
  }

  Future<void> deleteHabit(String habitId) async {
    await _databaseService.deleteHabit(habitId);
  }

  Future<void> toggleDailyEntry(String habitId, DateTime date, bool isCompleted) async {
    await _databaseService.addDailyEntry(habitId, date, isCompleted);
  }

  Future<List<DailyEntry>> getDailyEntries(String habitId, int year, int month) async {
    return await _databaseService.getDailyEntries(habitId, year, month);
  }

  Future<DailyEntry?> getDailyEntry(String habitId, DateTime date) async {
    return await _databaseService.getDailyEntry(habitId, date);
  }

  Future<int> calculateStreak(String habitId) async {
    return await _databaseService.calculateStreak(habitId);
  }
}

final habitServiceProvider = Provider<HabitService>((ref) {
  return HabitService();
});
