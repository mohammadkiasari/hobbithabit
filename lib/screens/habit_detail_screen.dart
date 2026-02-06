import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../models/milestone.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  int _displayedDays = 50; // Start with 50 days
  static const int _daysPerLoad = 30; // Load 30 more days when scrolling

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      setState(() {
        _displayedDays += _daysPerLoad;
      });
    }
  }

  void _showMilestoneDialog() {
    final streakController = TextEditingController();
    final prizeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Add Milestone Prize'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: streakController,
              decoration: const InputDecoration(
                labelText: 'Streak Count',
                hintText: 'e.g., 7 (for 7-day streak)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: prizeController,
              decoration: const InputDecoration(
                labelText: 'Reward Name',
                hintText: 'e.g., Buy a new book',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final streak = int.tryParse(streakController.text);
              final prize = prizeController.text;
              if (streak != null && streak > 0 && prize.isNotEmpty) {
                final milestone = Milestone(streakCount: streak, prize: prize);
                Provider.of<HabitProvider>(context, listen: false)
                    .addMilestone(widget.habit.id, milestone);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMilestoneUnlockedDialog(String prize) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.amber.shade100,
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text('Quest Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉🎊✨',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              prize,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlocked!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  void _showConsequenceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Consequence'),
        content: Text(
          widget.habit.consequence,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I understand'),
          ),
        ],
      ),
    );
  }

  void _showMilestoneListDialog() {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    final habit = provider.habits.firstWhere((h) => h.id == widget.habit.id);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Milestones'),
        content: SizedBox(
          width: double.maxFinite,
          child: habit.milestones.isEmpty
              ? const Text('No milestones yet. Add some!')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: habit.milestones.length,
                  itemBuilder: (context, index) {
                    final milestone = habit.milestones[index];
                    final isUnlocked = habit.unlockedMilestones.contains(milestone.streakCount);
                    return ListTile(
                      leading: Icon(
                        isUnlocked ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isUnlocked ? Colors.green : Colors.grey,
                      ),
                      title: Text(milestone.prize),
                      subtitle: Text('${milestone.streakCount}-day streak'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.removeMilestone(
                              widget.habit.id, milestone.streakCount);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Reset Quest'),
        content: const Text(
          'Are you sure you want to reset this quest? This will clear all completed days and unlocked milestones. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<HabitProvider>(context, listen: false)
                  .resetHabit(widget.habit.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown.shade100,
              Colors.brown.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildStatsBar(),
              Expanded(
                child: _buildScrollableParchment(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMilestoneDialog,
        backgroundColor: Colors.amber.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Add Prize'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.habit.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _showResetDialog,
            tooltip: 'Reset Quest',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showConsequenceDialog,
            tooltip: 'View Consequence',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: _showMilestoneListDialog,
            tooltip: 'View Milestones',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final habit = provider.habits.firstWhere((h) => h.id == widget.habit.id);
        
        // Find next milestone
        final currentStreak = habit.currentStreak;
        Milestone? nextMilestone;
        int? daysToNext;
        
        final sortedMilestones = List<Milestone>.from(habit.milestones)
          ..sort((a, b) => a.streakCount.compareTo(b.streakCount));
        
        for (final milestone in sortedMilestones) {
          if (milestone.streakCount > currentStreak && 
              !habit.unlockedMilestones.contains(milestone.streakCount)) {
            nextMilestone = milestone;
            daysToNext = milestone.streakCount - currentStreak;
            break;
          }
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.brown.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.brown.shade300, width: 2),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '🔥 Current Streak',
                    '${habit.currentStreak} days',
                    Colors.orange,
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.brown.shade300,
                  ),
                  _buildStatItem(
                    '⚔️ Total Days',
                    '${habit.totalDaysConquered}',
                    Colors.green,
                  ),
                ],
              ),
              if (nextMilestone != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade700),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Next: ${nextMilestone.prize} ($daysToNext days to go)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, MaterialColor color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.brown.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableParchment() {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final habit = provider.habits.firstWhere((h) => h.id == widget.habit.id);
        return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildCalendarGrid(habit, provider),
                const SizedBox(height: 16),
                Text(
                  'Scroll down to load more weeks...',
                  style: TextStyle(
                    color: Colors.brown.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _getDateForDay(Habit habit, int dayNumber) {
    return habit.createdAt.add(Duration(days: dayNumber - 1));
  }

  int _getDayNumberForDate(Habit habit, DateTime date) {
    final difference = date.difference(habit.createdAt).inDays;
    return difference + 1;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Widget _buildCalendarGrid(Habit habit, HabitProvider provider) {
    // Calculate weeks to display based on _displayedDays
    final weeksToDisplay = (_displayedDays / 7).ceil();
    final startDate = habit.createdAt;
    
    return Column(
      children: List.generate(weeksToDisplay, (weekIndex) {
        final weekStartDate = startDate.add(Duration(days: weekIndex * 7));
        final weekEndDate = weekStartDate.add(const Duration(days: 6));
        
        return Column(
          children: [
            if (weekIndex > 0) const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.brown.shade300, width: 2),
              ),
              child: Column(
                children: [
                  // Week header
                  Text(
                    '${_formatDate(weekStartDate)} - ${_formatDate(weekEndDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Day names header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown.shade600,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Calendar week
                  _buildWeekRow(habit, provider, weekStartDate),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  Widget _buildWeekRow(Habit habit, HabitProvider provider, DateTime weekStart) {
    // Normalize weekStart to Monday of that week for consistent Mon-Sun display
    // DateTime.weekday: Mon=1, Tue=2, ..., Sun=7
    // weekStart.weekday - 1 gives us: Mon=0, Tue=1, ..., Sun=6
    final mondayOffset = weekStart.weekday - 1;
    final monday = weekStart.subtract(Duration(days: mondayOffset));
    
    return Row(
      children: List.generate(7, (index) {
        final date = monday.add(Duration(days: index));
        final dayNumber = _getDayNumberForDate(habit, date);
        
        // Compare dates without time
        final todayDate = _normalizeDate(DateTime.now());
        final cellDate = _normalizeDate(date);
        final habitStartDate = _normalizeDate(habit.createdAt);
        
        final isInFuture = cellDate.isAfter(todayDate);
        final isBeforeStart = cellDate.isBefore(habitStartDate);
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _buildDayCell(dayNumber, habit, provider, date, isInFuture || isBeforeStart),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(int dayNumber, Habit habit, HabitProvider provider, DateTime date, bool isDisabled) {
    final isCompleted = !isDisabled && provider.isDayCompleted(habit, dayNumber);
    
    // Compare dates without time
    final todayDate = _normalizeDate(DateTime.now());
    final cellDate = _normalizeDate(date);
    final isToday = !isDisabled && cellDate == todayDate;

    return GestureDetector(
      onTap: isDisabled ? null : () async {
        final wasCompleted = isCompleted;
        final oldStreak = habit.currentStreak;
        
        await provider.toggleDay(habit.id, dayNumber);
        
        // Get updated habit to check new streak
        final updatedHabit = provider.habits.firstWhere((h) => h.id == habit.id);
        final newStreak = updatedHabit.currentStreak;
        
        // Check if we just achieved a new milestone streak (completing a day)
        if (!wasCompleted && newStreak > oldStreak) {
          final milestone = provider.getMilestoneForStreak(updatedHabit, newStreak);
          if (milestone != null && !updatedHabit.unlockedMilestones.contains(newStreak)) {
            // Mark milestone as unlocked
            final unlockedList = List<int>.from(updatedHabit.unlockedMilestones)..add(newStreak);
            final habitWithUnlocked = updatedHabit.copyWith(unlockedMilestones: unlockedList);
            await provider.updateHabit(habitWithUnlocked);
            
            _showMilestoneUnlockedDialog(milestone.prize);
          }
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDisabled 
              ? Colors.grey.shade200
              : isCompleted 
                  ? Colors.green.shade400 
                  : Colors.brown.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isToday ? Colors.amber.shade700 : Colors.brown.shade300,
            width: isToday ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isDisabled
                  ? Colors.grey.shade400
                  : isCompleted 
                      ? Colors.white 
                      : Colors.brown.shade800,
            ),
          ),
        ),
      ),
    );
  }
}
