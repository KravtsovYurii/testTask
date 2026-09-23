import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/core/services/services.dart';
import 'package:test_task/features/main_flow/bloc/main_flow_bloc.dart';
import 'package:test_task/features/main_flow/bloc/main_flow_event.dart';
import 'package:test_task/features/main_flow/presentation/screens/screens.dart';
import 'package:test_task/features/main_flow/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _baseUrlController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedBaseUrl();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedBaseUrl() async {
    final saveBaseUrl = await StorageService.getSavedUrl();
    if (saveBaseUrl != null && mounted) {
      _baseUrlController.text = saveBaseUrl;
    }
  }

  void _onStart() {
    final rawUrl = _baseUrlController.text.trim();

    if (rawUrl.isEmpty) {
      setState(() {
        _errorMessage = "Enter base URL";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    context.read<MainFlowBloc>().add(StartProcessEvent(rawUrl));

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProcessScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home screen')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set valid API base URL in order to continue',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.swap_horiz, color: Colors.black, size: 26),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _baseUrlController,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        isDense: true,
                        errorText: _errorMessage,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      onChanged: (_) {
                        if (_errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              PrimaryButton(
                text: 'Start counting process',
                onPressed: _onStart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
