class DailyEntry {
  final String habitId;
  final DateTime date;
  final bool isCompleted;

  DailyEntry({
    required this.habitId,
    required this.date,
    required this.isCompleted,
  });

  DailyEntry copyWith({
    String? habitId,
    DateTime? date,
    bool? isCompleted,
  }) {
    return DailyEntry(
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory DailyEntry.fromMap(Map<String, dynamic> map) {
    return DailyEntry(
      habitId: map['habitId'] as String,
      date: DateTime.parse(map['date'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }

  String get dateKey => '${date.year}-${date.month}-${date.day}';
}
