import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/main_flow/bloc/main_flow_bloc.dart';
import 'package:test_task/core/constants/constans.dart';
import 'package:test_task/features/main_flow/presentation/screens/screens.dart';

class WebSparkApp extends StatelessWidget {
  const WebSparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainFlowBloc(),
      child: MaterialApp(
        title: 'WebSpark test task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
