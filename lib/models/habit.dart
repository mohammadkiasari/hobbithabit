import 'package:hive/hive.dart';
import 'milestone.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<int> completedDays;

  @HiveField(3)
  final List<Milestone> milestones;

  @HiveField(4)
  final String consequence;

  @HiveField(5)
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    required this.completedDays,
    required this.milestones,
    required this.consequence,
    required this.createdAt,
  });

  Habit copyWith({
    String? id,
    String? name,
    List<int>? completedDays,
    List<Milestone>? milestones,
    String? consequence,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      completedDays: completedDays ?? this.completedDays,
      milestones: milestones ?? this.milestones,
      consequence: consequence ?? this.consequence,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  int get currentStreak {
    if (completedDays.isEmpty) return 0;

    final sortedDays = List<int>.from(completedDays)..sort();
    int streak = 1;
    int maxDay = sortedDays.last;

    // Check if the last completed day is today or yesterday
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays + 1;
    if (maxDay < daysSinceCreation - 1) return 0;

    for (int i = sortedDays.length - 2; i >= 0; i--) {
      if (sortedDays[i] == sortedDays[i + 1] - 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int get totalDaysConquered => completedDays.length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'completedDays': completedDays,
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'consequence': consequence,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        completedDays: List<int>.from(json['completedDays'] as List),
        milestones: (json['milestones'] as List)
            .map((m) => Milestone.fromJson(m as Map<String, dynamic>))
            .toList(),
        consequence: json['consequence'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
