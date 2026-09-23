import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:test_task/core/constants/constans.dart';
import 'package:test_task/features/main_flow/data/models/models.dart';

class GridBoard extends StatelessWidget {
  final Item task;

  const GridBoard({super.key, required this.task});

  Color _getCellColor(PointModel point, Set<PointModel> pathSet) {
    if (point == task.start) {
      return AppColors.cellStart;
    }
    if (point == task.end) {
      return AppColors.cellEnd;
    }
    if (pathSet.contains(point)) {
      return AppColors.cellPath;
    }
    if (task.field[point.y][point.x] == 'X') {
      return AppColors.cellBlocked;
    }
    return AppColors.cellEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final height = task.field.length;
    final width = height > 0 ? task.field[0].length : 0;

    if (width == 0 || height == 0) {
      return const Center(child: Text('Empty grid'));
    }

    final pathSet = task.path != null ? task.path!.toSet() : <PointModel>{};

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final cellSize = math.max(screenWidth / width, 32.0);
        final isScrollable = (cellSize * width) > screenWidth;

        Widget gridContent = Column(
          children: List.generate(height, (y) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(width, (x) {
                final point = PointModel(x: x, y: y);
                final color = _getCellColor(point, pathSet);
                final isBlocked = color == AppColors.cellBlocked;

                return Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(color: AppColors.gridBorder, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '($x,$y)',
                    style: TextStyle(
                      fontSize: (cellSize * 0.16).clamp(10, 15),
                      fontWeight: FontWeight.w400,
                      color: isBlocked ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }),
            );
          }),
        );

        if (isScrollable) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: gridContent,
          );
        }

        return gridContent;
      },
    );
  }
}
