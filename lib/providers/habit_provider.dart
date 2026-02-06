import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../models/milestone.dart';

class HabitProvider extends ChangeNotifier {
  late Box<Habit> _habitBox;
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MilestoneAdapter());
    Hive.registerAdapter(HabitAdapter());
    _habitBox = await Hive.openBox<Habit>('habits');
    _loadHabits();
  }

  void _loadHabits() {
    _habits = _habitBox.values.toList();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
    _loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
    _loadHabits();
  }

  Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
    _loadHabits();
  }

  Future<void> toggleDay(String habitId, int day) async {
    final habit = _habitBox.get(habitId);
    if (habit == null) return;

    final completedDays = List<int>.from(habit.completedDays);
    if (completedDays.contains(day)) {
      completedDays.remove(day);
    } else {
      completedDays.add(day);
    }

    final updatedHabit = habit.copyWith(completedDays: completedDays);
    await updateHabit(updatedHabit);
  }

  Future<void> addMilestone(String habitId, Milestone milestone) async {
    final habit = _habitBox.get(habitId);
    if (habit == null) return;

    final milestones = List<Milestone>.from(habit.milestones)..add(milestone);
    final updatedHabit = habit.copyWith(milestones: milestones);
    await updateHabit(updatedHabit);
  }

  Future<void> removeMilestone(String habitId, int dayCount) async {
    final habit = _habitBox.get(habitId);
    if (habit == null) return;

    final milestones = List<Milestone>.from(habit.milestones)
      ..removeWhere((m) => m.dayCount == dayCount);
    final updatedHabit = habit.copyWith(milestones: milestones);
    await updateHabit(updatedHabit);
  }

  Milestone? getMilestoneForDay(Habit habit, int day) {
    try {
      return habit.milestones.firstWhere((m) => m.dayCount == day);
    } catch (e) {
      return null;
    }
  }

  bool isDayCompleted(Habit habit, int day) {
    return habit.completedDays.contains(day);
  }
}
