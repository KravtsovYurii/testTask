import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/features/main_flow/bloc/main_flow_bloc.dart';
import 'package:test_task/features/main_flow/bloc/main_flow_event.dart';
import 'package:test_task/features/main_flow/bloc/main_flow_state.dart';
import 'package:test_task/features/main_flow/presentation/screens/screens.dart';
import 'package:test_task/features/main_flow/presentation/widgets/widgets.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process screen')),
      body: SafeArea(
        child: BlocConsumer<MainFlowBloc, MainFlowState>(
          listener: (context, state) {
            if (state is MainFlowSendSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ResultsScreen(tasks: state.tasks),
                ),
              );
            } else if (state is MainFlowError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            final isCalculating = state is MainFlowCalculating;
            final isCompleted =
                state is MainFlowCalculationCompleted ||
                state is MainFlowSending ||
                (state is MainFlowError && state.canRetrySend);
            final isSending = state is MainFlowSending;

            final int percent = isCalculating
                ? state.percentage
                : (isCompleted ? 100 : 0);

            final double? progressValue = isCalculating
                ? state.progress
                : (isCompleted ? 1 : null);

            final titleText = isCompleted
                ? 'All calculations has finished, you can send\nyour results to server'
                : (isCalculating
                      ? 'Calculations in progress...'
                      : 'Loading tasks from server...');

            return Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      titleText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 3.5,
                        color: Colors.blue,
                        backgroundColor: Colors.blue.withValues(alpha: 0.15),
                      ),
                    ),
                    const Spacer(flex: 3),
                    if (isCompleted)
                      PrimaryButton(
                        text: 'Send results to server',
                        isLoading: isSending,
                        onPressed: () {
                          context.read<MainFlowBloc>().add(
                            const SendResultsEvent(),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
