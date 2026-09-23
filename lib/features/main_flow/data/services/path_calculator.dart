import 'dart:collection';
import 'package:test_task/features/main_flow/data/models/models.dart';

class GridNode {
  const GridNode(this.point, [this.parent]);

  final PointModel point;
  final GridNode? parent;
}

class PathGrid {
  final List<String> field;
  final int height;
  final int width;

  PathGrid(this.field)
    : height = field.length,
      width = field.isNotEmpty ? field[0].length : 0;

  bool isValid(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  bool isBlocked(int x, int y) {
    if (!isValid(x, y)) return true;
    return field[y][x] == 'X';
  }

  bool canVisit(int x, int y) {
    return isValid(x, y) && !isBlocked(x, y);
  }
}

class PathCalculator {
  static const List<PointModel> _directions = [
    PointModel(x: -1, y: -1),
    PointModel(x: 0, y: -1),
    PointModel(x: 1, y: -1),
    PointModel(x: -1, y: 0),
    PointModel(x: 1, y: 0),
    PointModel(x: -1, y: 1),
    PointModel(x: 0, y: 1),
    PointModel(x: 1, y: 1),
  ];

  List<PointModel> findPath({
    required List<String> field,
    required PointModel start,
    required PointModel end,
  }) {
    if (field.isEmpty) return [];

    final grid = PathGrid(field);

    if (!grid.canVisit(start.x, start.y) || !grid.canVisit(end.x, end.y)) {
      return [];
    }

    if (start == end) {
      return [start];
    }

    final queue = Queue<GridNode>();
    final visited = <PointModel>{};

    queue.add(GridNode(start));
    visited.add(start);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();

      if (current.point == end) {
        return _buildPath(current);
      }

      for (final dir in _directions) {
        final nextPoint = PointModel(
          x: current.point.x + dir.x,
          y: current.point.y + dir.y,
        );

        if (grid.canVisit(nextPoint.x, nextPoint.y) &&
            !visited.contains(nextPoint)) {
          visited.add(nextPoint);
          queue.add(GridNode(nextPoint, current));
        }
      }
    }

    return [];
  }

  List<PointModel> _buildPath(GridNode targetNode) {
    final path = <PointModel>[];
    GridNode? curr = targetNode;
    while (curr != null) {
      path.add(curr.point);
      curr = curr.parent;
    }
    return path.reversed.toList();
  }
}
