import 'package:hive/hive.dart';

part 'milestone.g.dart';

@HiveType(typeId: 0)
class Milestone {
  @HiveField(0)
  final int dayCount;

  @HiveField(1)
  final String prize;

  Milestone({
    required this.dayCount,
    required this.prize,
  });

  Map<String, dynamic> toJson() => {
        'dayCount': dayCount,
        'prize': prize,
      };

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        dayCount: json['dayCount'] as int,
        prize: json['prize'] as String,
      );
}
