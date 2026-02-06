import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'habit_detail_screen.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '🧙‍♂️ Hobbit Habits Quest 🧙‍♂️',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
              ),
              Expanded(
                child: Consumer<HabitProvider>(
                  builder: (context, provider, child) {
                    if (provider.habits.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.spa,
                              size: 80,
                              color: Colors.brown.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Quests Yet!',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.brown.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to begin your journey',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.brown.shade400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.habits.length,
                      itemBuilder: (context, index) {
                        final habit = provider.habits[index];
                        return _buildHabitCard(context, habit);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        backgroundColor: Colors.brown.shade700,
        icon: const Icon(Icons.add),
        label: const Text('New Quest'),
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.brown.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.brown.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(habit: habit),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Quest icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Quest details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔥 ${habit.currentStreak} days  •  ⚔️ ${habit.totalDaysConquered} total',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.brown.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(context, habit);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context, habit);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit Quest'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Quest', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                icon: Icon(Icons.more_vert, color: Colors.brown.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Habit habit) {
    final nameController = TextEditingController(text: habit.name);
    final consequenceController = TextEditingController(text: habit.consequence);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✏️ Edit Quest'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Quest Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: consequenceController,
              decoration: const InputDecoration(
                labelText: 'Consequence',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
              final name = nameController.text.trim();
              final consequence = consequenceController.text.trim();
              if (name.isNotEmpty) {
                final updatedHabit = habit.copyWith(
                  name: name,
                  consequence: consequence.isEmpty ? habit.consequence : consequence,
                );
                Provider.of<HabitProvider>(context, listen: false)
                    .updateHabit(updatedHabit);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Delete Quest'),
        content: Text(
          'Are you sure you want to delete "${habit.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<HabitProvider>(context, listen: false)
                  .deleteHabit(habit.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
