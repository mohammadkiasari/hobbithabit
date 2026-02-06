# Code Documentation

## Overview
This document provides detailed information about the codebase structure and key components of the Hobbit Habits app.

## Data Models

### Milestone (`lib/models/milestone.dart`)
```dart
class Milestone {
  final int dayCount;      // The day number when this milestone is reached
  final String prize;      // The reward/prize name
}
```
- Simple immutable model for milestone data
- Hive type adapter for persistence (typeId: 0)
- Includes JSON serialization methods for backup/restore

### Habit (`lib/models/habit.dart`)
```dart
class Habit {
  final String id;                    // Unique identifier
  final String name;                  // Habit name
  final List<int> completedDays;      // List of completed day indices (infinite)
  final List<Milestone> milestones;   // Custom milestones
  final String consequence;           // Penalty for breaking habit
  final DateTime createdAt;           // Creation timestamp
}
```

Key methods:
- `currentStreak`: Calculates the current consecutive days streak
- `totalDaysConquered`: Returns the total number of completed days
- `copyWith`: Immutable update pattern

## State Management

### HabitProvider (`lib/providers/habit_provider.dart`)
The main state management class using Provider pattern.

**Initialization:**
```dart
Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MilestoneAdapter());
  Hive.registerAdapter(HabitAdapter());
  _habitBox = await Hive.openBox<Habit>('habits');
  _loadHabits();
}
```

**Key Methods:**
- `addHabit(Habit)`: Adds a new habit to storage
- `updateHabit(Habit)`: Updates existing habit
- `deleteHabit(String)`: Removes a habit
- `toggleDay(String, int)`: Marks/unmarks a day as completed
- `addMilestone(String, Milestone)`: Adds a milestone to a habit
- `removeMilestone(String, int)`: Removes a milestone
- `getMilestoneForDay(Habit, int)`: Gets milestone for a specific day
- `isDayCompleted(Habit, int)`: Checks if a day is completed

## UI Screens

### HomeScreen (`lib/screens/home_screen.dart`)
The main landing page showing all habits.

**Key Features:**
- Displays habit cards with stats (current streak, total days)
- Shows milestone count for each habit
- Floating action button to create new habits
- Empty state when no habits exist

**Design Elements:**
- Brown gradient background (hobbit theme)
- Card-based layout with rounded corners
- Icon-based visual language

### AddHabitScreen (`lib/screens/add_habit_screen.dart`)
Form screen for creating new habits.

**Form Fields:**
- Habit name (required)
- Consequence text (required, multiline)

**Validation:**
- Both fields must be filled
- Creates habit with empty completedDays and milestones lists

### HabitDetailScreen (`lib/screens/habit_detail_screen.dart`)
The main screen for tracking habit progress.

**Key Features:**
1. **Header**: Shows habit name, consequence info button, milestone list button
2. **Stats Bar**: Displays current streak and total days conquered
3. **Scrollable Grid**: Infinite-loading day grid grouped by 30s
4. **Floating Action Button**: Add new milestones

**Infinite Scrolling Implementation:**
```dart
void _onScroll() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent * 0.8) {
    setState(() {
      _displayedDays += _daysPerLoad;
    });
  }
}
```
- Loads more days when user scrolls to 80% of current content
- Starts with 50 days, loads 30 more at a time
- Uses ScrollController to detect scroll position

**Day Grid Grouping:**
```dart
Widget _buildDaysGrid(Habit habit, HabitProvider provider) {
  final groups = (_displayedDays / 30).ceil();
  
  return Column(
    children: List.generate(groups, (groupIndex) {
      // Creates groups of 30 days each
      // Each group is a separate card with title "Days X - Y"
    }),
  );
}
```

**Day Circle Logic:**
- Green background for completed days
- Brown/white for incomplete days
- Gold border for milestone days (3px vs 2px)
- Star icon on uncompleted milestone days
- Trophy icon on completed milestone days
- Box shadow on milestone days for emphasis

**Milestone Celebration:**
```dart
void _showMilestoneUnlockedDialog(String prize) {
  // Shows amber-themed dialog with celebration emojis
  // Displays the prize/reward name
  // Triggered when completing a milestone day
}
```

## Design Patterns

### Provider Pattern
```dart
Consumer<HabitProvider>(
  builder: (context, provider, child) {
    // UI rebuilds automatically when provider changes
    return Widget(...);
  },
)
```
- Used throughout the app for reactive UI updates
- Provider notifies listeners when data changes
- Widgets rebuild efficiently

### Immutability
```dart
final updatedHabit = habit.copyWith(completedDays: newCompletedDays);
```
- Habit and Milestone are immutable
- Updates create new instances using copyWith
- Ensures data integrity and predictable state changes

### Repository Pattern
```dart
class HabitProvider {
  late Box<Habit> _habitBox;  // Data source abstraction
  // All data operations go through provider
}
```
- HabitProvider acts as a repository
- Abstracts Hive storage details
- Easy to swap storage implementation

## Performance Considerations

### Lazy Loading
- Only renders visible days initially
- Loads more on demand as user scrolls
- Prevents rendering thousands of widgets at once

### Efficient List Operations
```dart
final completedDays = List<int>.from(habit.completedDays);
```
- Creates new lists instead of mutating existing ones
- Hive efficiently handles list storage
- Provider efficiently notifies only necessary listeners

### Widget Build Optimization
```dart
GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  // Builds only visible items
)
```
- Uses builder pattern for efficient rendering
- Nested inside SingleChildScrollView for infinite scroll
- shrinkWrap allows proper sizing within scroll view

## Testing Considerations

While tests are not included in the initial implementation, here are key areas to test:

### Unit Tests
- Habit.currentStreak calculation
- Habit.totalDaysConquered
- Milestone equality and serialization
- HabitProvider methods (add, update, delete, toggle)

### Widget Tests
- HomeScreen empty state
- HomeScreen with habits
- AddHabitScreen form validation
- HabitDetailScreen day circle rendering
- Milestone dialog interactions

### Integration Tests
- Complete habit creation flow
- Day completion and milestone unlock flow
- Infinite scrolling behavior
- Data persistence across app restarts

## Extension Points

### Adding New Features
1. **Habit Categories**: Add category field to Habit model
2. **Reminders**: Integrate with flutter_local_notifications
3. **Statistics**: Add chart widgets using fl_chart
4. **Themes**: Extract colors to a theme provider
5. **Cloud Sync**: Add API layer and repository pattern

### Code Quality
- All classes are well-commented
- Methods are small and focused
- Clear separation of concerns
- Consistent naming conventions
- Follow Flutter/Dart style guide

## Best Practices Used

1. **Single Responsibility**: Each class has one clear purpose
2. **Dependency Injection**: Provider injected via constructor
3. **Immutability**: Data models are immutable
4. **Type Safety**: Strong typing throughout
5. **Error Handling**: Try-catch in milestone lookup
6. **Null Safety**: Uses Dart null safety features
7. **Clean Architecture**: Models, providers, and UI are separated
