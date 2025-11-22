// MainNavigationView.dart (or wherever you defined this widget)

import 'package:flutter/material.dart';
import 'package:newyoubetteryou/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    // The Consumer listens to the AppViewModel for changes to currentIndex
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          // The body displays the page determined by the ViewModel
          body: viewModel.currentPage, 
          
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.currentIndex, // Read current index from ViewModel
            selectedItemColor: Theme.of(context).primaryColor, 
            unselectedItemColor: Colors.grey,
            // When a tab is tapped, call the ViewModel method to change the state
            onTap: viewModel.changeTab, 
            
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outlined),
                label: 'Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), 
                label: 'Tasks',
              ),
              // Ensure you add all items that correspond to the pages in AppViewModel.navPages
            ],
          ),
        );
      }
    );
  }
}