import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

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

  // User Management
  void updateUsername(String newUsername) {
    user.username = newUsername;
    notifyListeners();
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

