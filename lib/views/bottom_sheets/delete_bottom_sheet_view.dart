import 'package:flutter/material.dart';
import 'package:newyoubetteryou/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

class DeleteBottomSheetView extends StatelessWidget {
  const DeleteBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          height: 125,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // Delete All Tasks Button 

              ElevatedButton(
                onPressed: () {
                  viewModel.deleteAllTasks();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: viewModel.clrLvl1,
                  backgroundColor: viewModel.clrLvl3,
                  textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                child: Text("Delete All Tasks"),
              ),

              
              SizedBox(width: 15,),
                
                
                //delete completed tasks button
                ElevatedButton(
                onPressed: () {
                  viewModel.deleteCompletedTasks();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: viewModel.clrLvl1,
                  backgroundColor: viewModel.clrLvl3,
                  textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                child: Text("Delete Completed Tasks"),),
            ],
          ),
        );
      },
    );
  }
}
