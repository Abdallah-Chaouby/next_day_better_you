import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newyoubetteryou/views/bottom_sheets/GeneralTaskPage.dart';
import 'package:newyoubetteryou/views/general_tasks_page.dart'; // Import for navPages
import 'package:newyoubetteryou/views/task_page.dart'; // Import for navPages
import '../models/task_model.dart'; // Assuming this defines your Task model
import '../models/user_model.dart'; // Assuming this defines your User model
import 'package:shared_preferences/shared_preferences.dart';

class AppViewModel extends ChangeNotifier {
  // Data
  List<Task> tasks = [];
  User user = User("Abel");

  // Colors
  final Color clrLvl1 = Colors.cyan.shade50;
  final Color clrLvl2 = Colors.cyan.shade200;
  final Color clrLvl3 = Colors.cyan.shade800;
  final Color clrLvl4 = Colors.cyan.shade900;

  // Getters
  int get numTasks => tasks.length;
  int get numTasksRemaining => tasks.where((task) => !task.complete).length;
  String get username => user.username;
  
  // Habit Tracking Members
  late List<Habit> _dailyHabits;
  late String _todayKey;

  List<Habit> get dailyHabits => _dailyHabits;

  Map<String, int> _lastNotifiedStreak = {}; 
  final List<int> _streakMilestones = const [7, 30, 100]; 
  late Function(String habitName, int streak) _notifyStreakAchievement;


  // Navigation Management
  int _currentIndex = 0;
  final List<Widget> navPages = const [
    TaskPage(),           // 0: Habits Dashboard
    GeneralTasksPage(),   // 1: General Tasks Page
  ];

  // Navigation Getters/Setters
  int get currentIndex => _currentIndex;
  Widget get currentPage => navPages[_currentIndex];

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  
  double get dailyCompletionPercentage {
    if (_dailyHabits.isEmpty) return 0.0;
    int completedCount = _dailyHabits.where((habit) => habit.isCompleted).length;
    return completedCount / _dailyHabits.length;
  }

  int get maxHabitStreak {
    if (_dailyHabits.isEmpty) return 0;
    return _dailyHabits
        .map((h) => h.currentStreak).fold(
          0, (int max, int current) => current > max ? current : max
        );
  }
  
  // Constructor
  AppViewModel() {
    tasks = [];
    user = User("New User");
    _initializeHabitTracker();
    _loadDailyProgress().then((_){
      checkAndAdvanceDay();
      loadAllHabitHistory();
    });
  }

  // Task Management
  void addTask(Task newTask) {
    tasks.add(newTask);
    notifyListeners();
  }

  bool getTaskValue(int taskIndex) => tasks[taskIndex].complete;
  String getTaskTitle(int taskIndex) => tasks[taskIndex].title;

  void setTaskValue(int taskIndex, bool taskValue) {
    tasks[taskIndex].complete = taskValue;
    notifyListeners();
  }

  void deleteTask(int taskIndex) {
    tasks.removeAt(taskIndex);
    notifyListeners();
  }

  void deleteAllTasks() {
    tasks.clear();
    notifyListeners();
  }

  void deleteCompletedTasks() {
    tasks = tasks.where((task) => !task.complete).toList();
    notifyListeners();
  }

  // Streak Notifier Setup
  void setStreakNotifier(Function(String habitName, int streak) notifier) {
    _notifyStreakAchievement = notifier;
  }

  // Habit Toggling and Streak Check
  bool getHabitValue(int index) {
    return _dailyHabits[index].isCompleted;
  }

  String getHabitTitle(int index){
    return _dailyHabits[index].name;
  }

  void toggleHabitCompletion (int index, bool newValue) {
    if (index >=0 && index < _dailyHabits.length) {
      _dailyHabits[index].isCompleted = newValue;
      
      // Check for Streak Achievement ONLY if the habit was just marked as completed
      if (newValue) {
        final habit = _dailyHabits[index];
        final newStreak = habit.currentStreak;
        final lastNotified = _lastNotifiedStreak[habit.name] ?? 0;

        // Check if the new streak hits a milestone we haven't notified for
        for (var milestone in _streakMilestones) {
          if (newStreak >= milestone && lastNotified < milestone) {
            
            _lastNotifiedStreak[habit.name] = milestone;
            _notifyStreakAchievement(habit.name, newStreak);
            break; 
          }
        }
      }

      notifyListeners();
      _saveDailyProgress();
    }
  }

  // Persistence Logic
  Future<void> _saveDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String> completedNames = _dailyHabits.where((h) => h.isCompleted).map((h) => h.name).toList();
    await prefs.setStringList(_todayKey, completedNames);
  }

  Future<void> _loadDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedcompletedNames = prefs.getStringList(_todayKey);

    if (savedcompletedNames != null) {
      for (var habit in _dailyHabits) {
        habit.isCompleted = savedcompletedNames.contains(habit.name);
      }
    }
    notifyListeners();
  }

  Future<void> checkAndAdvanceDay() async {
    final prefs = await SharedPreferences.getInstance();
    
    final DateFormat formatter = DateFormat('yyyyMMdd'); 
    final String currentKey = formatter.format(DateTime.now()); 

    if (_todayKey != currentKey) {
      if (_todayKey.isNotEmpty && _dailyHabits.isNotEmpty) {
        await prefs.setStringList(_todayKey, _dailyHabits
            .where((h) => h.isCompleted)
            .map((h) => h.name)
            .toList());
            print("Saved progress for $_todayKey");
      } 

      _todayKey = currentKey;
      for (var habit in _dailyHabits) {
        habit.isCompleted = false;
      }

      await _loadDailyProgress();
      notifyListeners();
    }
  }

  Future<Set<String>> _loadHabitsForDay(String dateKey) async { 
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedcompletedNames = prefs.getStringList(dateKey); 
    
    if (savedcompletedNames != null) { 
      return savedcompletedNames.toSet();
    }
    return <String>{}; 
  }
  
  Future<void> loadAllHabitHistory() async {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final DateTime now = DateTime.now();

    for (var habit in _dailyHabits) {
      habit.completionRecord.clear();
    }

    for (int daysBack = 1; daysBack <= 365; daysBack++) {
      DateTime pastDate = now.subtract(Duration(days: daysBack));
      String dateKey = formatter.format(pastDate);

      Set<String> completedHabits = await _loadHabitsForDay(dateKey);

      for (var habit in _dailyHabits) {
        bool wasCompleted = completedHabits.contains(habit.name);
        habit.completionRecord[dateKey] = wasCompleted;
      }
    }

    notifyListeners(); 
    print('Finished loading 365 days of history for all habits.');
  }


  // User Management
  void updateUsername(String newUsername) {
    user.username = newUsername;
    notifyListeners();
  }

  // Habit Tracker Initialization
  void _initializeHabitTracker() {
    const List <String> permanentHabitNames= [
      "Drink Water",
      "Exercise",
      "Read",
      "Meditate",
      "Sleep Early"
    ];

    _dailyHabits = permanentHabitNames
        .map((name) => Habit(name: name, isCompleted: false))
        .toList();

    _todayKey = DateFormat('yyyyMMdd').format(DateTime.now());
  }

  // UI Helpers
  void bottomSheetBuilder(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(42),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => bottomSheetView,
    );
  }
}


// --- Habit Class (Must be outside the AppViewModel class) ---
// You will need to ensure this class is available to your AppViewModel (e.g., in a separate file or directly below)

class Habit {
  final String name;
  bool isCompleted;
  final Map<String, bool> completionRecord;

  Habit({required this.name, this.isCompleted = false})
      : completionRecord = {}; 

  // Getter for the current streak
  int get currentStreak {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    int streak = 0;
    
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 1));
    
    for (int i = 0; i < 365; i++) { 
      String checkKey = formatter.format(currentDate);
      
      if (completionRecord[checkKey] == true) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}