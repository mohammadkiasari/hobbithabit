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

  @HiveField(6)
  final List<int> unlockedMilestones;

  Habit({
    required this.id,
    required this.name,
    required this.completedDays,
    required this.milestones,
    required this.consequence,
    required this.createdAt,
    List<int>? unlockedMilestones,
  }) : unlockedMilestones = unlockedMilestones ?? [];

  Habit copyWith({
    String? id,
    String? name,
    List<int>? completedDays,
    List<Milestone>? milestones,
    String? consequence,
    DateTime? createdAt,
    List<int>? unlockedMilestones,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      completedDays: completedDays ?? this.completedDays,
      milestones: milestones ?? this.milestones,
      consequence: consequence ?? this.consequence,
      createdAt: createdAt ?? this.createdAt,
      unlockedMilestones: unlockedMilestones ?? this.unlockedMilestones,
    );
  }

  int get currentStreak {
    if (completedDays.isEmpty) return 0;

    final sortedDays = List<int>.from(completedDays)..sort();
    final maxDay = sortedDays.last;
    int streak = 1;

    // Calculate backwards from the highest completed day
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
        'unlockedMilestones': unlockedMilestones,
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
        unlockedMilestones: json['unlockedMilestones'] != null
            ? List<int>.from(json['unlockedMilestones'] as List)
            : [],
      );
}
