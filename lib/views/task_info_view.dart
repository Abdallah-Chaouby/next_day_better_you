import 'package:flutter/material.dart';
import 'package:newyoubetteryou/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

class TaskInfoView extends StatelessWidget {
  const TaskInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, viewModel, child){
      return Padding( // Using Padding instead of margin on the container is often cleaner
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            // Max Streak Card (Replaced Total Tasks)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: viewModel.clrLvl2,
                  borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            // Display the max streak value
                            "${viewModel.maxHabitStreak}", 
                            style: TextStyle(
                              fontSize: 28, 
                              color: viewModel.clrLvl3, // Highlight color
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ), 
                    ), 
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                          child: Text(
                            "Current Streak 🔥", // Updated label
                            style: TextStyle(
                              fontSize: 16, 
                              color: viewModel.clrLvl4, 
                              fontWeight: FontWeight.w600
                            )
                          )
                        )
                      )
                    )
                  ],
                ),
              ),
            ),
            
            // Spacer
            const SizedBox(width: 20),
            
            // Remaining Tasks Card
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: viewModel.clrLvl2,
                  borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            "${viewModel.numTasksRemaining}", 
                            style: TextStyle(
                              fontSize: 28, 
                              color: viewModel.clrLvl3, 
                              fontWeight: FontWeight.bold
                            )
                          )
                        ),
                      ), 
                    ), 
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                          child: Text(
                            "Remaining Tasks", 
                            style: TextStyle(
                              fontSize: 16, 
                              color: viewModel.clrLvl4, 
                              fontWeight: FontWeight.w600
                            )
                          )
                        )
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}