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
    final dayController = TextEditingController();
    final prizeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Add Milestone Prize'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dayController,
              decoration: const InputDecoration(
                labelText: 'Day Number',
                hintText: 'e.g., 50',
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
              final day = int.tryParse(dayController.text);
              final prize = prizeController.text;
              if (day != null && day > 0 && prize.isNotEmpty) {
                final milestone = Milestone(dayCount: day, prize: prize);
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
                    final isCompleted =
                        provider.isDayCompleted(habit, milestone.dayCount);
                    return ListTile(
                      leading: Icon(
                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                      ),
                      title: Text(milestone.prize),
                      subtitle: Text('Day ${milestone.dayCount}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.removeMilestone(
                              widget.habit.id, milestone.dayCount);
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
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.brown.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.brown.shade300, width: 2),
          ),
          child: Row(
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
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
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
                _buildDaysGrid(habit, provider),
                const SizedBox(height: 16),
                Text(
                  'Scroll down to load more days...',
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

  Widget _buildDaysGrid(Habit habit, HabitProvider provider) {
    // Group days by 30s for better readability
    final groups = (_displayedDays / 30).ceil();
    
    return Column(
      children: List.generate(groups, (groupIndex) {
        final startDay = groupIndex * 30 + 1;
        final endDay = (groupIndex + 1) * 30 <= _displayedDays 
            ? (groupIndex + 1) * 30 
            : _displayedDays;
        
      return Column(
        children: [
          if (groupIndex > 0) const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.brown.shade300, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  'Days $startDay - $endDay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: endDay - startDay + 1,
                  itemBuilder: (context, index) {
                    final day = startDay + index;
                    return _buildDayCircle(day, habit, provider);
                  },
                ),
              ],
            ),
          ),
        ],
      );
      }),
    );
  }

  Widget _buildDayCircle(int day, Habit habit, HabitProvider provider) {
    final isCompleted = provider.isDayCompleted(habit, day);
    final milestone = provider.getMilestoneForDay(habit, day);
    final hasMilestone = milestone != null;

    return GestureDetector(
      onTap: () async {
        final wasCompleted = isCompleted;
        await provider.toggleDay(habit.id, day);
        
        // Check if this day has a milestone and was just completed (not uncompleted)
        if (!wasCompleted && hasMilestone) {
          _showMilestoneUnlockedDialog(milestone.prize);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? Colors.green.shade400 : Colors.brown.shade100,
          border: Border.all(
            color: hasMilestone
                ? Colors.amber.shade700
                : Colors.brown.shade300,
            width: hasMilestone ? 3 : 2,
          ),
          boxShadow: hasMilestone
              ? [
                  BoxShadow(
                    color: Colors.amber.shade300.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.white : Colors.brown.shade800,
                ),
              ),
            ),
            if (hasMilestone && !isCompleted)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.amber.shade700,
                ),
              ),
            if (isCompleted && hasMilestone)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.emoji_events,
                  size: 12,
                  color: Colors.amber.shade700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
