import 'dart:convert';
import 'package:test_task/core/api/api.dart';
import 'package:test_task/features/main_flow/data/models/models.dart';

abstract class ApiService {
  Future<List<Item>> fetchTasks(String url);
  Future<void> sendResults(String url, List<Result> results);
}

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  String _buildUrl(String rawUrl) {
    var trimmed = rawUrl.trim();
    if (trimmed.startsWith('http://')) {
      trimmed = trimmed.replaceFirst('http://', 'https://');
    } else if (!trimmed.startsWith('https://')) {
      trimmed = 'https://$trimmed';
    }

    final uri = Uri.parse(trimmed);
    if (!uri.path.endsWith('/flutter/api')) {
      final base = uri.path.endsWith('/')
          ? uri.path.substring(0, uri.path.length - 1)
          : uri.path;
      return uri.replace(path: '$base/flutter/api').toString();
    }
    return trimmed;
  }

  @override
  Future<List<Item>> fetchTasks(String url) async {
    final targetUrl = _buildUrl(url);
    final dynamic data = await _apiClient.get(targetUrl);

    if (data is Map && data['error'] == true) {
      final message = data['message']?.toString() ?? 'Error fetching tasks';
      throw ApiException(message);
    }

    if (data is! Map || data['data'] == null) {
      throw const ApiException('Tasks list is empty or invalid format');
    }

    final list = data['data'] as List<dynamic>?;
    if (list == null) {
      throw const ApiException('Tasks list is empty');
    }

    return list
        .map((item) => Item.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> sendResults(String url, List<Result> results) async {
    final targetUrl = _buildUrl(url);
    final payload = results.map((r) => r.toJson()).toList();

    final dynamic data = await _apiClient.post(
      targetUrl,
      data: jsonEncode(payload),
    );

    if (data is Map && data['error'] == true) {
      final message = data['message']?.toString() ?? 'Error sending results';
      throw ApiException(message);
    }
  }
}
