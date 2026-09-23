import 'package:flutter/material.dart';
import 'package:test_task/core/constants/constans.dart';
import 'package:test_task/features/main_flow/data/models/models.dart';
import 'package:test_task/features/main_flow/presentation/screens/screens.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.tasks});

  final List<Item> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result list screen')),
      body: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1, color: AppColors.divider),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PreviewScreen(task: task)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                task.pathString.isNotEmpty ? task.pathString : 'Path not found',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
