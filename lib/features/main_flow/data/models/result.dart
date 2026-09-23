import 'point_model.dart';

class Result {
  const Result({required this.id, required this.steps, required this.path});

  final String id;
  final List<PointModel> steps;
  final String path;

  Map<String, dynamic> toJson() => {
    'id': id,
    'result': {
      'steps': steps.map((s) => s.toStepJson()).toList(),
      'path': path,
    },
  };
}
