import 'package:home_widget/home_widget.dart';
import '../models/habit.dart';

class WidgetService {
  static const String _widgetName = 'HobbitHabitWidget';

  /// Update widget with habit data
  static Future<void> updateWidget(List<Habit> habits) async {
    try {
      // Calculate totals
      int totalHabits = habits.length;
      int totalStreak = 0;
      int totalDaysCompleted = 0;
      String topHabitName = '';
      int topHabitStreak = 0;

      if (habits.isNotEmpty) {
        // Find habit with highest streak
        for (var habit in habits) {
          totalStreak += habit.currentStreak;
          totalDaysCompleted += habit.totalDaysConquered;
          
          if (habit.currentStreak > topHabitStreak) {
            topHabitStreak = habit.currentStreak;
            topHabitName = habit.name;
          }
        }
      }

      // Save data to widget
      await HomeWidget.saveWidgetData<int>('total_habits', totalHabits);
      await HomeWidget.saveWidgetData<int>('total_streak', totalStreak);
      await HomeWidget.saveWidgetData<int>('total_days', totalDaysCompleted);
      await HomeWidget.saveWidgetData<String>('top_habit_name', topHabitName);
      await HomeWidget.saveWidgetData<int>('top_habit_streak', topHabitStreak);
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
