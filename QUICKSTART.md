# Hobbit Habits - Quick Start Guide

## 📖 Quick Overview

Hobbit Habits is a Flutter habit tracker with:
- ✅ **Infinite tracking** - no day limits
- 🏆 **Custom milestones** - set rewards at any day
- 🎯 **Consequences** - accountability for breaking habits  
- 🔥 **Streak tracking** - monitor your progress
- 📜 **Beautiful UI** - hobbit/medieval theme

## 🚀 Quick Start

```bash
# 1. Get dependencies
flutter pub get

# 2. Run the app
flutter run

# 3. (Optional) Generate Hive adapters if needed
flutter packages pub run build_runner build
```

## 💡 Usage Flow

### Step 1: Create a Habit ("Quest")
1. Tap "New Quest" button
2. Enter habit name: "Morning Meditation" 
3. Enter consequence: "No coffee for the day"
4. Tap "Start Quest"

### Step 2: Add Milestones
1. Open the habit
2. Tap "Add Prize" button
3. Enter day 30: "Buy a new book"
4. Enter day 60: "Treat myself to a movie"
5. Enter day 100: "Weekend getaway"

### Step 3: Track Daily
1. Each day, open your habit
2. Tap today's circle to mark complete
3. Watch your streak grow! 🔥
4. When you hit a milestone day, enjoy the celebration! 🎉

## 🎨 UI Features

### Home Screen
- View all your habits
- See current streak and total days
- Quick access to any habit

### Habit Detail Screen
- **Scrollable grid** - grouped by 30 days
- **Gold borders** - indicate milestone days
- **Green circles** - completed days
- **Stats bar** - streak and total at top
- **Infinite scroll** - automatically loads more days

### Milestone Indicators
- 🌟 Star icon on upcoming milestone days
- 🏆 Trophy icon on completed milestone days
- ✨ Gold glow effect on milestone days
- 🎊 Celebration dialog when unlocked

## 📁 File Structure

```
lib/
├── main.dart                    # App initialization
├── models/
│   ├── habit.dart              # Habit data model
│   ├── habit.g.dart            # Hive adapter
│   ├── milestone.dart          # Milestone model
│   └── milestone.g.dart        # Hive adapter
├── providers/
│   └── habit_provider.dart     # State management
└── screens/
    ├── home_screen.dart        # Habit list
    ├── add_habit_screen.dart   # Create habit
    └── habit_detail_screen.dart # Track progress
```

## 🔧 Key Technical Features

### Infinite Scrolling
- Starts with 50 days visible
- Loads 30 more as you scroll
- Smooth performance even with 1000+ days

### Smart Day Grouping  
- Days grouped by 30 (Days 1-30, 31-60, etc.)
- Keeps UI organized and readable
- Easy to navigate to specific time periods

### Streak Calculation
- Counts consecutive completed days
- Checks if streak is current (includes today/yesterday)
- Automatically updates as you complete days

### Data Persistence
- Uses Hive for local storage
- Type-safe with generated adapters
- Instant load times
- Automatic saves on every change

## 🎯 Design Philosophy

### Clean Code
- Clear separation of concerns
- Single responsibility principle
- Immutable data models
- Provider pattern for state

### User Experience
- Visual feedback on every action
- Celebration when goals achieved
- Clear progress indicators
- Intuitive tap-to-complete

### Performance
- Lazy loading for efficiency
- Efficient list rendering
- Minimal re-renders with Provider
- Smooth scrolling even with many days

## 🔮 Extending the App

Easy to add:
- Habit categories/tags
- Notifications and reminders
- Statistics and charts
- Data export/import
- Habit templates
- Dark mode theme
- Cloud backup

## 💾 Data Format

Habits are stored in Hive as objects:

```dart
Habit {
  id: "1234567890",
  name: "Morning Exercise",
  completedDays: [1, 2, 3, 5, 6, 7, ...],  // Infinite list
  milestones: [
    Milestone(dayCount: 30, prize: "New shoes"),
    Milestone(dayCount: 60, prize: "Gym membership"),
  ],
  consequence: "Donate $10 to charity",
  createdAt: DateTime(2024, 1, 1)
}
```

## 🎨 Theme Colors

- Primary: Brown shades (parchment/earth tones)
- Accent: Amber/Gold (for milestones)
- Success: Green (completed days)
- Background: Gradient brown tones
- Cards: Light brown with dark borders

## 📱 Screenshots

(In a real project, add screenshots here showing:)
- Home screen with habits
- Habit detail with grid
- Milestone celebration dialog
- Add habit form
- Milestone list view

## 🤝 Contributing

This is a clean, well-documented codebase designed for future development:

1. Fork the repo
2. Create a feature branch
3. Follow existing code patterns
4. Test your changes
5. Submit a pull request

## 📄 License

MIT License - feel free to use and modify!

---

Built with ❤️ and Flutter
