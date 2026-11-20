
import 'package:flutter/material.dart';

abstract class Shape {
  final Offset start;
  final Offset end;

  const Shape(this.start, this.end);

  void draw(Canvas canvas);
}

class PointShape extends Shape {
  const PointShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(start, 3, paint);
  }
}

class LineShape extends Shape {
  const LineShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }
}

class RectangleShape extends Shape {
  const RectangleShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    // Варіант 10: два протилежні кути.
    final rect = Rect.fromPoints(start, end);

    final fill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, border);
  }
}

class EllipseShape extends Shape {
  const EllipseShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    // Варіант 10: від центра до кута.
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();

    final rect = Rect.fromLTRB(
      start.dx - dx,
      start.dy - dy,
      start.dx + dx,
      start.dy + dy,
    );

    final border = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawOval(rect, border);
  }
}
