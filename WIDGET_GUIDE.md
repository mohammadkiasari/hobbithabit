# Home Screen Widget Implementation Guide

## Overview
The Hobbit Habits app now includes home screen widgets for iOS, Android, and macOS that display your habit progress directly on your device's home screen.

## Widget Display Information
The widget shows:
- **Total Habits**: Number of active habits
- **Combined Streak**: Sum of all habit streaks
- **Total Days**: Total days conquered across all habits
- **Top Habit**: The habit with the highest current streak

## Platform-Specific Setup

### iOS Widget Setup

1. **Add App Group** (already configured):
   - App Group ID: `group.hobbithabit`
   - This allows the widget to access habit data

2. **Widget Extension**:
   - Create widget extension in Xcode
   - File: `ios/Widget/HobbitHabitWidget.swift`
   - The widget uses SwiftUI for iOS 14+

3. **Add Widget to Home Screen**:
   - Long press on home screen
   - Tap "+" button
   - Search for "Hobbit Habits"
   - Select widget size and add

### Android Widget Setup

1. **Widget Provider** (already configured):
   - File: `android/app/src/main/res/xml/hobbithabit_widget_info.xml`
   - Layout: `android/app/src/main/res/layout/hobbithabit_widget.xml`

2. **Add Widget to Home Screen**:
   - Long press on home screen
   - Tap "Widgets"
   - Find "Hobbit Habits"
   - Drag to home screen

### macOS Widget Setup

1. **Widget Extension** (similar to iOS):
   - Uses SwiftUI for macOS 11+
   - File: `macos/Widget/HobbitHabitWidget.swift`

2. **Add Widget to Notification Center**:
   - Open Notification Center
   - Scroll to bottom and click "Edit Widgets"
   - Find "Hobbit Habits" and add

## Automatic Updates

The widget automatically updates when:
- A habit is added, updated, or deleted
- A day is marked complete/incomplete
- A milestone is added or removed
- The app is opened or closed

## Widget Refresh Frequency

- **iOS**: Updates every 15 minutes (system-controlled)
- **Android**: Updates on data change
- **macOS**: Updates every 15 minutes (system-controlled)

## Technical Implementation

### Data Sharing
- Uses `home_widget` package (v0.6.0)
- Shares data via App Groups (iOS/macOS) or Shared Preferences (Android)
- Updates triggered from `HabitProvider`

### Widget Service
The `WidgetService` class handles:
- Calculating widget data from habits
- Saving data for widget access
- Triggering widget updates
- Handling widget taps (opens app)

### Code Structure
```
lib/
  services/
    widget_service.dart    # Widget data management
  providers/
    habit_provider.dart    # Calls widget service on changes
```

## Widget Data Format

The following data is shared with widgets:
```dart
{
  'total_habits': int,        // Number of habits
  'total_streak': int,        // Sum of all streaks
  'total_days': int,          // Total days completed
  'top_habit_name': String,   // Name of top habit
  'top_habit_streak': int,    // Streak of top habit
  'last_update': String,      // ISO8601 timestamp
}
```

## Troubleshooting

### Widget Not Showing Data
1. Ensure app has been opened at least once
2. Check that habits exist in the app
3. Remove and re-add the widget
4. Restart the device

### Widget Not Updating
1. Open the app to trigger an update
2. Check system widget refresh settings
3. Verify app group configuration (iOS/macOS)

## Future Enhancements

Possible widget improvements:
- Multiple widget sizes (small, medium, large)
- Different widget styles (list view, chart view)
- Interactive buttons (mark day complete from widget)
- Widget configuration (choose which habits to show)
- Dark mode support
