// GeneralTasksPage.dart

import 'package:flutter/material.dart';
import 'package:newyoubetteryou/view_models/app_view_model.dart';
import 'package:newyoubetteryou/views/add_task_view.dart'; // Assuming this is your FAB
import 'package:provider/provider.dart';

class GeneralTasksPage extends StatelessWidget {
  const GeneralTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          // FloatingActionButton for adding new tasks
          floatingActionButton: const AddTaskView(), 
          
          body: CustomScrollView( 
            slivers: [
              // Spacer for layout consistency with other pages
              const SliverToBoxAdapter(child: SizedBox(height: 20)), 
              
              // Header for General Tasks
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
                  child: Text(
                    'General To-Do Items (${viewModel.numTasks})',
                    style: TextStyle(
                      color: viewModel.clrLvl4,
                      fontSize: 24, // Made header slightly larger
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // General Tasks List
              SliverList.separated(
                itemCount: viewModel.numTasks,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Dismissible(
                      // Using the item's title as key is often fine, but UniqueKey() is safer if titles can repeat.
                      key: UniqueKey(), 
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        viewModel.deleteTask(index);
                      },
                      background: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: viewModel.clrLvl1,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            side: BorderSide(width: 2, color: viewModel.clrLvl3),
                            checkColor: viewModel.clrLvl1,
                            activeColor: viewModel.clrLvl3,
                            value: viewModel.getTaskValue(index),
                            onChanged: (value) {
                              viewModel.setTaskValue(index, value!);
                            },
                          ),
                          title: Text(
                            viewModel.getTaskTitle(index),
                            style: TextStyle(
                              color: viewModel.clrLvl4,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Padding at the bottom to ensure the last task isn't hidden by the FAB
              const SliverToBoxAdapter(child: SizedBox(height: 80)), 
            ],
          ),
        );
      }
    );
  }
}