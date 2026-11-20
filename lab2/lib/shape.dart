
import 'package:flutter/material.dart';

abstract class Shape {
  final Offset start;
  final Offset end;

  const Shape(this.start, this.end);

  void draw(Canvas canvas, Paint paint);
}

class PointShape extends Shape {
  const PointShape(super.start, super.end);

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawCircle(
      start,
      3,
      paint
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );
  }
}

class LineShape extends Shape {
  const LineShape(super.start, super.end);

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawLine(
      start,
      end,
      paint
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}

class RectangleShape extends Shape {
  const RectangleShape(super.start, super.end);

  Rect get rectangle {
    // Для варіанта 9: start — центр прямокутника,
    // end — один із його кутів.
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();

    return Rect.fromLTRB(
      start.dx - dx,
      start.dy - dy,
      start.dx + dx,
      start.dy + dy,
    );
  }

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawRect(
      rectangle,
      paint
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}

class EllipseShape extends Shape {
  const EllipseShape(super.start, super.end);

  Rect get rectangle => Rect.fromPoints(start, end);

  @override
  void draw(Canvas canvas, Paint paint) {
    // Блакитне заповнення.
    canvas.drawOval(
      rectangle,
      paint
        ..color = Colors.lightBlueAccent
        ..style = PaintingStyle.fill,
    );

    // Чорний контур.
    canvas.drawOval(
      rectangle,
      paint
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}
