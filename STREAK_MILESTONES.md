# Streak-Based Milestone System 🔥

## Overview
The app now uses **streak-based milestones** instead of day-based milestones. Users set rewards for achieving specific streak counts (consecutive days).

## How It Works

### Setting Milestones
1. Open a habit detail screen
2. Tap "Add Prize" button
3. Enter **Streak Count** (e.g., 7 for a 7-day streak)
4. Enter **Reward Name** (e.g., "Buy a new book")
5. Tap "Add"

### Example Milestones
- 7-day streak → "Treat yourself to coffee"
- 30-day streak → "Buy a new book"
- 100-day streak → "Weekend getaway"

### Achieving Milestones
When you complete days and reach a milestone streak:
1. The app detects the streak count matches a milestone
2. A celebration dialog appears: "Quest Completed: [Reward Name] Unlocked!"
3. The milestone is marked as unlocked
4. Next time you view milestones, it shows with a green checkmark

### Visual Indicators

#### Stats Bar
```
┌─────────────────────────────────────┐
│  🔥 Current Streak    │  ⚔️ Total   │
│     7 days           │    12 days   │
├─────────────────────────────────────┤
│  🏆 Next: Buy a new book (23 days)  │  ← Shows next milestone
└─────────────────────────────────────┘
```

#### Milestone List
```
🏆 Milestones
┌────────────────────────────────┐
│ ✅ Treat yourself to coffee    │
│    7-day streak (Unlocked!)    │
│                                │
│ ⭕ Buy a new book              │
│    30-day streak               │
│                                │
│ ⭕ Weekend getaway             │
│    100-day streak              │
└────────────────────────────────┘
```

## Data Model Changes

### Before (Day-Based)
```dart
class Milestone {
  final int dayCount;     // Specific day number
  final String prize;
}
```

### After (Streak-Based)
```dart
class Milestone {
  final int streakCount;  // Streak count to achieve
  final String prize;
}

class Habit {
  // ... other fields
  final List<int> unlockedMilestones;  // Tracks achieved streaks
}
```

## Why Streak-Based?

### Advantages
1. **More Motivating**: Focuses on consistency, not just calendar days
2. **Fair**: You can skip days and restart your streak
3. **Clearer Goals**: "Build a 30-day streak" is clearer than "complete day 30"
4. **Better Tracking**: Unlocked milestones persist even if streak breaks

### Example Scenario
**Day-Based (Old):**
- User sets milestone at "Day 50"
- User completes days 1-40, then skips days 41-45
- User completes day 50 anyway → milestone unlocks (not meaningful)

**Streak-Based (New):**
- User sets milestone at "50-day streak"
- User completes days 1-40 (streak = 40)
- User skips a day → streak resets to 0
- User must build another 50-day streak to unlock → more meaningful

## Platform Support

The app uses Flutter and works on:
- ✅ **Android** (phones and tablets)
- ✅ **iOS** (iPhones and iPads)
- ✅ **macOS** (desktop)
- ✅ **Web** (browsers)
- ✅ **Windows** (desktop)
- ✅ **Linux** (desktop)

No additional configuration needed - Flutter provides cross-platform support by default!

## Usage Tips

### Starting Out
Set small milestones first:
- 3-day streak → Small reward
- 7-day streak → Medium reward
- 14-day streak → Bigger reward

### Long-Term Goals
Add ambitious milestones:
- 30-day streak → Special treat
- 60-day streak → Shopping trip
- 100-day streak → Weekend vacation
- 365-day streak → Major celebration!

### Break Prevention
The "Next" indicator in the stats bar helps you:
- See how close you are to the next reward
- Stay motivated to continue your streak
- Plan your rewards strategically
