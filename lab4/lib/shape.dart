
import 'package:flutter/material.dart';

abstract class Shape {
  final Offset start;
  final Offset end;

  const Shape(this.start, this.end);

  void draw(Canvas canvas);
}

// Спільні методи для малювання окремих елементів.
mixin LineDrawing {
  void drawLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Paint paint,
  ) {
    canvas.drawLine(a, b, paint);
  }
}

mixin EllipseDrawing {
  void drawEllipse(
    Canvas canvas,
    Rect rect,
    Paint paint,
  ) {
    canvas.drawOval(rect, paint);
  }
}

mixin RectangleDrawing {
  void drawRectangle(
    Canvas canvas,
    Rect rect,
    Paint paint,
  ) {
    canvas.drawRect(rect, paint);
  }
}

class PointShape extends Shape {
  const PointShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    canvas.drawCircle(
      start,
      3,
      Paint()..color = Colors.black,
    );
  }
}

class LineShape extends Shape with LineDrawing {
  const LineShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    drawLine(
      canvas,
      start,
      end,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2,
    );
  }
}

class RectangleShape extends Shape with RectangleDrawing {
  const RectangleShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    final rect = Rect.fromPoints(start, end);

    drawRectangle(
      canvas,
      rect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    drawRectangle(
      canvas,
      rect,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}

class EllipseShape extends Shape with EllipseDrawing {
  const EllipseShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();

    final rect = Rect.fromLTRB(
      start.dx - dx,
      start.dy - dy,
      start.dx + dx,
      start.dy + dy,
    );

    drawEllipse(
      canvas,
      rect,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}

// Нова фігура №5: лінія з кружечками на кінцях.
class LineOOShape extends Shape with LineDrawing, EllipseDrawing {
  const LineOOShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    drawLine(canvas, start, end, paint);

    const radius = 7.0;

    drawEllipse(
      canvas,
      Rect.fromCircle(center: start, radius: radius),
      paint,
    );

    drawEllipse(
      canvas,
      Rect.fromCircle(center: end, radius: radius),
      paint,
    );
  }
}

// Нова фігура №6: каркас куба.
class CubeShape extends Shape with LineDrawing, RectangleDrawing {
  const CubeShape(super.start, super.end);

  @override
  void draw(Canvas canvas) {
    final front = Rect.fromPoints(start, end);

    final paint = Paint()
      ..color = Colors.teal.shade700
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final shift = Offset(
      front.width * 0.25,
      -front.height * 0.25,
    );

    final back = front.shift(shift);

    drawRectangle(canvas, front, paint);
    drawRectangle(canvas, back, paint);

    drawLine(
      canvas,
      front.topLeft,
      back.topLeft,
      paint,
    );

    drawLine(
      canvas,
      front.topRight,
      back.topRight,
      paint,
    );

    drawLine(
      canvas,
      front.bottomLeft,
      back.bottomLeft,
      paint,
    );

    drawLine(
      canvas,
      front.bottomRight,
      back.bottomRight,
      paint,
    );
  }
}
