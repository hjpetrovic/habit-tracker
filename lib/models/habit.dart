class Habit {
  final String id;
  final String name;
  final int color; // ARGB color as int
  final DateTime createdDate;
  final bool isActive;

  Habit({
    required this.id,
    required this.name,
    required this.color,
    required this.createdDate,
    this.isActive = true,
  });

  Habit copyWith({
    String? id,
    String? name,
    int? color,
    DateTime? createdDate,
    bool? isActive,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdDate: createdDate ?? this.createdDate,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'createdDate': createdDate.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['color'] as int,
      createdDate: DateTime.parse(map['createdDate'] as String),
      isActive: (map['isActive'] as int) == 1,
    );
  }
}
