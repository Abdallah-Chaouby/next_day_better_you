import 'package:flutter/material.dart';
import 'package:newyoubetteryou/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

// This is now effectively the Daily Habits View
class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        // 1. Register the SnackBar notifier function with the ViewModel
        // This allows the ViewModel to trigger the UI notification when a streak milestone is hit.
        viewModel.setStreakNotifier(
            (habitName, streak) => _showStreakSnackbar(context, habitName, streak));

        return Container(
          // Main container styling for the list section
          decoration: BoxDecoration(
            color: viewModel.clrLvl2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          
          child: CustomScrollView(
            slivers: [
              // 2. Permanent Habit List Section (Habits and Progress)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: HabitSection(viewModel: viewModel),
                ),
              ),
              
              // 3. Add a placeholder or reminder that general tasks moved
              SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "General To-Do items moved to the 'Tasks' tab for better focus! 📝",
                      style: TextStyle(
                        color: viewModel.clrLvl4.withOpacity(0.7), 
                        fontSize: 14, 
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  )
              ),
              
              const SliverToBoxAdapter(
                  child: SizedBox(height: 50)
              )
            ],
          ),
        );
      },
    );
  }
  
  // Function to show the SnackBar notification
  void _showStreakSnackbar(BuildContext context, String habitName, int streak) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Milestone Achieved! $habitName streak is now $streak days!'),
        backgroundColor: Colors.deepOrange,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}


// --- HABIT SECTION WIDGET ---
// This widget contains the progress bar, horizontal list, and streak display.
class HabitSection extends StatelessWidget {
  final AppViewModel viewModel;

  const HabitSection({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar (Daily Habits Completion Percentage)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Habits: ${(viewModel.dailyCompletionPercentage * 100).toInt()}% Done',
                style: TextStyle(
                  color: viewModel.clrLvl4,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: viewModel.dailyCompletionPercentage,
                minHeight: 12,
                backgroundColor: viewModel.clrLvl2,
                valueColor: AlwaysStoppedAnimation<Color>(viewModel.clrLvl3),
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        
        // Horizontal Scrollable Habit List
        SizedBox(
          height: 100, // Fixed height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.dailyHabits.length,
            itemBuilder: (context, index) {
              
              final habit = viewModel.dailyHabits[index]; 

              return Padding(
                // FIX: Removed 'const' keyword because the 'right' value is dynamic.
                padding: EdgeInsets.only(left: 15.0, right: index == viewModel.dailyHabits.length - 1 ? 15.0 : 0),
                child: Container(
                  width: 150, // Fixed width for each habit card
                  decoration: BoxDecoration(
                    color: viewModel.clrLvl1,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: habit.isCompleted ? viewModel.clrLvl3 : viewModel.clrLvl1,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      viewModel.toggleHabitCompletion(index, !habit.isCompleted);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            habit.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                            color: habit.isCompleted ? viewModel.clrLvl3 : viewModel.clrLvl4.withOpacity(0.6),
                            size: 24,
                          ),
                          const SizedBox(height: 5),
                          
                          // Display the Habit Title
                          Text(
                            habit.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: viewModel.clrLvl4,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                          // Display the Streak
                          if (habit.currentStreak > 0)
                            Text(
                              '🔥 ${habit.currentStreak} day${habit.currentStreak > 1 ? 's' : ''}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}