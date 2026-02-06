import 'package:hive/hive.dart';

part 'milestone.g.dart';

@HiveType(typeId: 0)
class Milestone {
  @HiveField(0)
  final int streakCount;

  @HiveField(1)
  final String prize;

  Milestone({
    required this.streakCount,
    required this.prize,
  });

  Map<String, dynamic> toJson() => {
        'streakCount': streakCount,
        'prize': prize,
      };

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        streakCount: json['streakCount'] as int,
        prize: json['prize'] as String,
      );
}
