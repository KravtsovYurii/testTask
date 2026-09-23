class PointModel {
  const PointModel({required this.x, required this.y});

  final int x;
  final int y;

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      x: int.parse(json['x'].toString()),
      y: int.parse(json['y'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  Map<String, String> toStepJson() => {'x': '$x', 'y': '$y'};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointModel &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}
