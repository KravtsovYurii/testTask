import 'point_model.dart';

class Item {
  const Item({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
    this.path,
  });

  final String id;
  final List<String> field;
  final PointModel start;
  final PointModel end;
  final List<PointModel>? path;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      field: (json['field'] as List<dynamic>).map((e) => e.toString()).toList(),
      start: PointModel.fromJson(json['start'] as Map<String, dynamic>),
      end: PointModel.fromJson(json['end'] as Map<String, dynamic>),
    );
  }

  Item copyWith({List<PointModel>? path}) {
    return Item(
      id: id,
      field: field,
      start: start,
      end: end,
      path: path ?? this.path,
    );
  }

  String get pathString {
    if (path == null || path!.isEmpty) return '';
    return path!.map((p) => p.toString()).join('->');
  }
}
