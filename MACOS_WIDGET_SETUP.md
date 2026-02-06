# macOS Widget Implementation Instructions

## Overview
These are manual steps to add the macOS widget in Xcode since widget creation requires Xcode IDE.

## Steps to Add macOS Widget

### 1. Open Project in Xcode
```bash
cd macos
open Runner.xcworkspace
```

### 2. Add Widget Extension
1. In Xcode, go to **File** > **New** > **Target**
2. Choose **Widget Extension** (under macOS)
3. Name it `HobbitHabitWidgetMac`
4. Product Name: `HobbitHabitWidgetMac`
5. Check "Include Configuration Intent" - NO
6. Click **Finish**
7. When prompted, click **Activate** to activate the scheme

### 3. Configure App Group
1. Select **Runner** target (macOS)
2. Go to **Signing & Capabilities**
3. Click **+ Capability** and add **App Groups**
4. Add group: `group.hobbithabit`
5. Select **HobbitHabitWidgetMac** target
6. Repeat: Add **App Groups** capability with `group.hobbithabit`

### 4. Replace Widget Code
Replace the content of `HobbitHabitWidgetMac.swift` with:

```swift
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HabitEntry {
        HabitEntry(date: Date(), totalHabits: 0, totalStreak: 0, totalDays: 0, topHabitName: "Loading...", topHabitStreak: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (HabitEntry) -> ()) {
        let entry = loadHabitData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = loadHabitData()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    func loadHabitData() -> HabitEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.hobbithabit")
        let totalHabits = sharedDefaults?.integer(forKey: "total_habits") ?? 0
        let totalStreak = sharedDefaults?.integer(forKey: "total_streak") ?? 0
        let totalDays = sharedDefaults?.integer(forKey: "total_days") ?? 0
        let topHabitName = sharedDefaults?.string(forKey: "top_habit_name") ?? "No habits yet"
        let topHabitStreak = sharedDefaults?.integer(forKey: "top_habit_streak") ?? 0
        
        return HabitEntry(
            date: Date(),
            totalHabits: totalHabits,
            totalStreak: totalStreak,
            totalDays: totalDays,
            topHabitName: topHabitName,
            topHabitStreak: topHabitStreak
        )
    }
}

struct HabitEntry: TimelineEntry {
    let date: Date
    let totalHabits: Int
    let totalStreak: Int
    let totalDays: Int
    let topHabitName: String
    let topHabitStreak: Int
}

struct HobbitHabitWidgetMacEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 230/255, blue: 211/255)
            
            VStack(spacing: 8) {
                // Title
                Text("🧙‍♂️ Hobbit Habits")
                    .font(.headline)
                    .foregroundColor(Color(red: 93/255, green: 64/255, blue: 55/255))
                
                // Top Habit
                if entry.topHabitStreak > 0 {
                    HStack {
                        Text("🔥")
                        Text(entry.topHabitName)
                            .font(.subheadline)
                            .lineLimit(1)
                        Spacer()
                        Text("\(entry.topHabitStreak)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 255/255, green: 111/255, blue: 0/255))
                        Text("days")
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                }
                
                Spacer()
                
                // Stats
                HStack(spacing: 20) {
                    VStack {
                        Text("\(entry.totalHabits)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Habits")
                            .font(.caption2)
                    }
                    
                    VStack {
                        Text("\(entry.totalStreak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 255/255, green: 111/255, blue: 0/255))
                        Text("Streak")
                            .font(.caption2)
                    }
                    
                    VStack {
                        Text("\(entry.totalDays)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 67/255, green: 160/255, blue: 71/255))
                        Text("Days")
                            .font(.caption2)
                    }
                }
            }
            .padding()
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 161/255, green: 136/255, blue: 127/255), lineWidth: 2)
        )
    }
}

@main
struct HobbitHabitWidgetMac: Widget {
    let kind: String = "HobbitHabitWidgetMac"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HobbitHabitWidgetMacEntryView(entry: entry)
        }
        .configurationDisplayName("Hobbit Habits")
        .description("View your habit progress at a glance")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct HobbitHabitWidgetMac_Previews: PreviewProvider {
    static var previews: some View {
        HobbitHabitWidgetMacEntryView(entry: HabitEntry(
            date: Date(),
            totalHabits: 3,
            totalStreak: 21,
            totalDays: 45,
            topHabitName: "Morning Exercise",
            topHabitStreak: 7
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
```

### 5. Update macOS Deployment Target
1. Select **Runner** target (macOS)
2. Go to **General** tab
3. Set **Minimum Deployment** to macOS 11.0 or higher
4. Repeat for **HobbitHabitWidgetMac** target

### 6. Build and Run
1. Select the **HobbitHabitWidgetMac** scheme
2. Choose "My Mac"
3. Click **Run** (▶️)
4. The widget will be installed

### 7. Add Widget to Notification Center
1. Open **Notification Center** (click clock or swipe from right edge)
2. Scroll to the bottom
3. Click **Edit Widgets**
4. Find "Hobbit Habits"
5. Click **+** to add
6. Drag to position and click **Done**

## Troubleshooting

### Widget Shows "No Data"
- Open the main app at least once
- Create some habits
- The widget will update automatically

### Build Errors
- Ensure both targets have the same App Group: `group.hobbithabit`
- Check that macOS Deployment Target is 11.0 or higher
- Clean build folder: **Product** > **Clean Build Folder**

### Widget Not Appearing
- Check system preferences: **System Preferences** > **Extensions** > **Widgets**
- Ensure "Hobbit Habits" is enabled

## Widget Sizes

### Small Widget
- Shows: Title, total habits count, streak sum
- Compact view of your progress

### Medium Widget
- Shows: Title, top habit with streak, all stats
- Recommended for best experience

## macOS-Specific Notes

- Widgets appear in Notification Center, not on desktop
- Widgets update every 15 minutes automatically
- Click widget to open the main app
- Widgets persist across system restarts
