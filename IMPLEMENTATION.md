# 🧙‍♂️ Hobbit Habits - Your Quest to Build Better Habits

A Flutter app inspired by the Shire, designed to help you track habits indefinitely with custom milestones and rewards.

## ✨ Features

### 🎯 Core Functionality
- **Infinite Duration**: No 40-day limit! Track your habits indefinitely
- **Dynamic Grid**: View days in an organized, scrollable grid that loads more days as you scroll
- **Custom Milestones**: Set rewards at any day count and celebrate when you reach them
- **Consequences**: Set a penalty for breaking the habit to keep yourself accountable
- **Streak Tracking**: Monitor your current streak and total days conquered

### 📊 Data Model
The app uses a clean, extensible data model:
- **Habit**: Contains name, completedDays list, milestones list, consequence, and creation date
- **Milestone**: Contains dayCount and prize/reward name
- **No hard limits**: The completedDays list can grow infinitely

### 🎨 UI/UX Design
- **Scrollable Parchment**: Main habit view resembles an unrolling scroll with a medieval theme
- **Grouped Days**: Days are organized in groups of 30 for better readability
- **Milestone Indicators**: Days with milestones have a gold border and star icon
- **Visual Celebrations**: When you complete a milestone day, see a celebration dialog
- **Progress Display**: Current streak and total days conquered shown at the top

## 🏗️ Architecture

### Technology Stack
- **State Management**: Provider pattern for reactive state updates
- **Local Storage**: Hive for efficient local data persistence
- **UI Framework**: Flutter with Material Design 3

### Project Structure
```
lib/
├── main.dart                           # App entry point
├── models/
│   ├── habit.dart                      # Habit data model
│   ├── habit.g.dart                    # Hive adapter (generated)
│   ├── milestone.dart                  # Milestone data model
│   └── milestone.g.dart                # Hive adapter (generated)
├── providers/
│   └── habit_provider.dart             # State management
└── screens/
    ├── home_screen.dart                # List of all habits
    ├── add_habit_screen.dart           # Create new habit
    └── habit_detail_screen.dart        # Scrollable grid view
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mohammadkiasari/hobbithabit.git
cd hobbithabit
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 How to Use

### Creating a New Habit
1. Tap the "New Quest" button on the home screen
2. Enter a habit name (e.g., "Morning Exercise")
3. Enter a consequence for breaking the habit (e.g., "Donate $10 to charity")
4. Tap "Start Quest"

### Adding Milestones
1. Open any habit by tapping on it
2. Tap the "Add Prize" button
3. Enter the day number (e.g., 50)
4. Enter the reward name (e.g., "Buy a new book")
5. The milestone day will appear with a gold border and star icon

### Tracking Progress
1. Tap any day circle to mark it as completed
2. Completed days turn green
3. When you complete a milestone day, you'll see a celebration dialog
4. View your current streak and total days at the top

### Managing Milestones
1. Tap the trophy icon in the habit detail screen
2. View all milestones and their completion status
3. Delete milestones you no longer want

## 🎯 Key Features Explained

### Infinite Scrolling
The app initially displays 50 days but automatically loads 30 more days as you scroll down. This ensures smooth performance while supporting unlimited habit tracking.

### Day Grouping
Days are organized in groups of 30 (Days 1-30, Days 31-60, etc.) to maintain readability even when tracking habits for months or years.

### Streak Calculation
The current streak is calculated based on consecutive completed days, checking if the last completed day is recent (today or yesterday).

### Milestone Celebration
When you check off a day that has a milestone attached to it, the app triggers a visual celebration dialog showing the unlocked reward.

## 🔧 Technical Details

### State Management
The app uses the Provider pattern for state management:
- `HabitProvider` manages all habit-related state and operations
- All screens consume the provider using `Consumer` widgets
- State changes automatically trigger UI updates

### Data Persistence
Hive is used for local storage:
- Type-safe object storage with generated adapters
- Efficient read/write operations
- Automatic persistence of all changes

### Performance Optimizations
- Lazy loading of days (load more as needed)
- Grouped rendering to prevent massive widget trees
- Efficient list updates using Provider

## 🎨 Theming

The app uses a medieval/hobbit-inspired theme:
- Brown color palette (reminiscent of parchment and earth tones)
- Rounded corners on cards and buttons
- Gradient backgrounds
- Icon-based visual language

## 🔮 Future Development

The codebase is structured for easy extension:
- Add habit categories or tags
- Implement habit sharing
- Add data export/import
- Create habit templates
- Add notification reminders
- Implement habit statistics and charts

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by the world of Hobbits and their simple, consistent lifestyle
- Built with Flutter and the amazing Flutter community packages
