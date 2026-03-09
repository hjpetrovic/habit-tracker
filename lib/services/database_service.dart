import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habit_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE habits ADD COLUMN targetDays INTEGER NOT NULL DEFAULT 7',
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        createdDate TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        targetDays INTEGER NOT NULL DEFAULT 7
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId TEXT NOT NULL,
        date TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (habitId) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_daily_entries_habitId ON daily_entries(habitId)
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // For use in tests only — resets the singleton so a fresh DB is opened.
  static void resetForTesting() {
    _database = null;
  }

  Future<Habit> addHabit(Habit habit) async {
    final db = await database;
    await db.insert('habits', habit.toMap());
    return habit;
  }

  Future<void> deleteHabit(String habitId) async {
    final db = await database;
    await db.delete(
      'daily_entries',
      where: 'habitId = ?',
      whereArgs: [habitId],
    );
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [habitId],
    );
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      orderBy: 'createdDate DESC',
    );
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<void> addDailyEntry(String habitId, DateTime date, bool isCompleted) async {
    final db = await database;
    final existing = await db.query(
      'daily_entries',
      where: 'habitId = ? AND date = ?',
      whereArgs: [habitId, date.toIso8601String()],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'daily_entries',
        {'isCompleted': isCompleted ? 1 : 0},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await db.insert('daily_entries', {
        'habitId': habitId,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted ? 1 : 0,
      });
    }
  }

  Future<List<DailyEntry>> getDailyEntries(String habitId, int year, int month) async {
    final db = await database;
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);

    final List<Map<String, dynamic>> maps = await db.query(
      'daily_entries',
      where: 'habitId = ? AND date >= ? AND date <= ?',
      whereArgs: [
        habitId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'date ASC',
    );
    return List.generate(maps.length, (i) => DailyEntry.fromMap(maps[i]));
  }

  Future<List<DailyEntry>> getDailyEntriesForDate(DateTime date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_entries',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    return List.generate(maps.length, (i) => DailyEntry.fromMap(maps[i]));
  }

  Future<DailyEntry?> getDailyEntry(String habitId, DateTime date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_entries',
      where: 'habitId = ? AND date = ?',
      whereArgs: [habitId, date.toIso8601String()],
    );
    
    if (maps.isEmpty) return null;
    return DailyEntry.fromMap(maps.first);
  }

  Future<int> calculateStreak(String habitId) async {
    final db = await database;
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    while (true) {
      final entry = await getDailyEntry(habitId, currentDate);
      if (entry == null || !entry.isCompleted) {
        break;
      }
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    
    return streak;
  }
}
