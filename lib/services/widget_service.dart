import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import '../models/habit.dart';

class WidgetService {
  static const String _widgetName = 'HobbitHabitWidget';

  /// Update widget with habit data
  static Future<void> updateWidget(List<Habit> habits) async {
    try {
      if (habits.isEmpty) {
        // Clear widget data if no habits
        await HomeWidget.saveWidgetData<int>('total_habits', 0);
        await HomeWidget.saveWidgetData<String>('habits_data', '');
        await HomeWidget.updateWidget(
          name: _widgetName,
          androidName: _widgetName,
          iOSName: _widgetName,
        );
        return;
      }

      // Prepare quest data with last 7 days status
      final habitDataList = <Map<String, dynamic>>[];
      final now = DateTime.now();
      
      for (var habit in habits) {
        // Get last 7 days status
        final last7Days = <int>[];
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          // Use date-only comparison
          final dateOnly = DateTime(date.year, date.month, date.day);
          final habitStartOnly = DateTime(habit.createdAt.year, habit.createdAt.month, habit.createdAt.day);
          final dayNumber = dateOnly.difference(habitStartOnly).inDays + 1;
          
          // Only include if day is after habit creation
          if (dayNumber > 0) {
            last7Days.add(habit.completedDays.contains(dayNumber) ? 1 : 0);
          } else {
            last7Days.add(0);
          }
        }
        
        habitDataList.add({
          'name': habit.name,
          'current_streak': habit.currentStreak,
          'total_days': habit.totalDaysConquered,
          'last_7_days': last7Days,
        });
      }

      // Convert to JSON string for safe serialization
      final habitsJson = jsonEncode(habitDataList);

      // Save data to widget
      await HomeWidget.saveWidgetData<int>('total_habits', habits.length);
      await HomeWidget.saveWidgetData<String>('habits_data', habitsJson);
      await HomeWidget.saveWidgetData<String>(
        'last_update',
        DateTime.now().toIso8601String(),
      );

      // Update the widget
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
        iOSName: _widgetName,
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Initialize widget
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.hobbithabit');
    } catch (e) {
      print('Error initializing widget: $e');
    }
  }

  /// Handle widget tap to open app
  static Future<void> registerBackgroundCallback() async {
    try {
      await HomeWidget.registerBackgroundCallback(backgroundCallback);
    } catch (e) {
      print('Error registering background callback: $e');
    }
  }
}

/// Background callback for widget taps
void backgroundCallback(Uri? uri) async {
  // Handle widget tap - app will be launched
  print('Widget tapped: $uri');
}
