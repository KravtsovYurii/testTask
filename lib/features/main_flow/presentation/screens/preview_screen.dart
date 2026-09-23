import 'package:flutter/material.dart';
import 'package:test_task/features/main_flow/data/models/models.dart';
import 'package:test_task/features/main_flow/presentation/widgets/widgets.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.task});

  final Item task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview screen')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridBoard(task: task),
            Text(
              task.pathString.isNotEmpty ? task.pathString : 'Шлях не знайдено',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
