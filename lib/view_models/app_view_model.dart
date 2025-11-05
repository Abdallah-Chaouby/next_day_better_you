import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class AppViewModel extends ChangeNotifier {
  List <Task> tasks = <Task>[];
  User user = User("Abel");

  Color clrLvl1 = Colors.grey.shade50;
  Color clrLvl2 = Colors.grey.shade200;
  Color clrLvl3 = Colors.grey.shade800;
  Color clrLvl4 = Colors.grey.shade900;

  void addTask(Task newTask) {
    tasks.add(newTask);
    notifyListeners();
    
  }

  void bottomSheetBuilder(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context, builder: ((context) {
      return bottomSheetView;
    }));
  

}
}