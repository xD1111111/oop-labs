
import 'package:flutter/material.dart';
import 'shape.dart';

enum ShapeType {
  point,
  line,
  rectangle,
  ellipse,
  lineOO,
  cube,
}

extension ShapeTypeInfo on ShapeType {
  String get title {
    switch (this) {
      case ShapeType.point:
        return 'Крапка';
      case ShapeType.line:
        return 'Лінія';
      case ShapeType.rectangle:
        return 'Прямокутник';
      case ShapeType.ellipse:
        return 'Еліпс';
      case ShapeType.lineOO:
        return 'Лінія з кружечками';
      case ShapeType.cube:
        return 'Каркас куба';
    }
  }

  IconData get icon {
    switch (this) {
      case ShapeType.point:
        return Icons.circle;
      case ShapeType.line:
        return Icons.show_chart;
      case ShapeType.rectangle:
        return Icons.crop_square;
      case ShapeType.ellipse:
        return Icons.circle_outlined;
      case ShapeType.lineOO:
        return Icons.linear_scale;
      case ShapeType.cube:
        return Icons.view_in_ar;
    }
  }
}

class ShapeEditor extends ChangeNotifier {
  static const int maxShapes = 110;

  // Колекція фіксованого розміру.
  final List<Shape?> _shapes =
      List<Shape?>.filled(maxShapes, null, growable: false);

  int _count = 0;
  ShapeType _selectedType = ShapeType.point;

  Offset? _start;
  Offset? _current;

  int get count => _count;
  ShapeType get selectedType => _selectedType;
  bool get isFull => _count >= maxShapes;

  Iterable<Shape> get shapes =>
      _shapes.take(_count).whereType<Shape>();

  Shape? get preview {
    if (_start == null || _current == null) {
      return null;
    }

    return _createShape(
      _selectedType,
      _start!,
      _current!,
    );
  }

  void selectType(ShapeType type) {
    _selectedType = type;
    _start = null;
    _current = null;
    notifyListeners();
  }

  void begin(Offset position) {
    if (isFull) return;

    _start = position;
    _current = position;
    notifyListeners();
  }

  void update(Offset position) {
    if (_start == null) return;

    _current = position;
    notifyListeners();
  }

  void finish(Offset position) {
    if (_start == null || isFull) return;

    _shapes[_count] = _createShape(
      _selectedType,
      _start!,
      position,
    );

    _count++;
    _start = null;
    _current = null;

    notifyListeners();
  }

  void clear() {
    for (int i = 0; i < _count; i++) {
      _shapes[i] = null;
    }

    _count = 0;
    _start = null;
    _current = null;

    notifyListeners();
  }

  Shape _createShape(
    ShapeType type,
    Offset start,
    Offset end,
  ) {
    switch (type) {
      case ShapeType.point:
        return PointShape(start, end);
      case ShapeType.line:
        return LineShape(start, end);
      case ShapeType.rectangle:
        return RectangleShape(start, end);
      case ShapeType.ellipse:
        return EllipseShape(start, end);
      case ShapeType.lineOO:
        return LineOOShape(start, end);
      case ShapeType.cube:
        return CubeShape(start, end);
    }
  }
}

// Малювання пунктирного контуру.
void drawDashedLine(
  Canvas canvas,
  Offset start,
  Offset end,
  Paint paint,
) {
  const dashLength = 8.0;
  const gapLength = 5.0;

  final delta = end - start;
  final distance = delta.distance;

  if (distance == 0) return;

  final direction = delta / distance;

  double current = 0;

  while (current < distance) {
    final dashEnd = (current + dashLength)
        .clamp(0.0, distance);

    canvas.drawLine(
      start + direction * current,
      start + direction * dashEnd,
      paint,
    );

    current += dashLength + gapLength;
  }
}

// Пунктирний контур прямокутника.
void drawDashedRect(
  Canvas canvas,
  Rect rect,
  Paint paint,
) {
  drawDashedLine(canvas, rect.topLeft, rect.topRight, paint);
  drawDashedLine(canvas, rect.topRight, rect.bottomRight, paint);
  drawDashedLine(canvas, rect.bottomRight, rect.bottomLeft, paint);
  drawDashedLine(canvas, rect.bottomLeft, rect.topLeft, paint);
}

// Пунктирний контур еліпса.
void drawDashedOval(
  Canvas canvas,
  Rect rect,
  Paint paint,
) {
  final path = Path()..addOval(rect);

  for (final metric in path.computeMetrics()) {
    double distance = 0;

    while (distance < metric.length) {
      final end = (distance + 8.0)
          .clamp(0.0, metric.length);

      canvas.drawPath(
        metric.extractPath(distance, end),
        paint,
      );

      distance += 13.0;
    }
  }
}

class DrawingPainter extends CustomPainter {
  final ShapeEditor editor;

  DrawingPainter(this.editor) : super(repaint: editor);

  @override
  void paint(Canvas canvas, Size size) {
    // Спочатку відображаємо завершені фігури.
    for (final shape in editor.shapes) {
      shape.draw(canvas);
    }

    final preview = editor.preview;
    if (preview == null) return;

    // У лабораторній №4 попередній контур пунктирний.
    // Колір зберігаємо синім, як у лабораторній №3.
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (preview is PointShape) {
      canvas.drawCircle(preview.start, 3, paint);
    } else if (preview is LineShape) {
      drawDashedLine(
        canvas,
        preview.start,
        preview.end,
        paint,
      );
    } else if (preview is RectangleShape) {
      drawDashedRect(
        canvas,
        Rect.fromPoints(preview.start, preview.end),
        paint,
      );
    } else if (preview is EllipseShape) {
      final dx =
          (preview.end.dx - preview.start.dx).abs();
      final dy =
          (preview.end.dy - preview.start.dy).abs();

      drawDashedOval(
        canvas,
        Rect.fromLTRB(
          preview.start.dx - dx,
          preview.start.dy - dy,
          preview.start.dx + dx,
          preview.start.dy + dy,
        ),
        paint,
      );
    } else if (preview is LineOOShape) {
      drawDashedLine(
        canvas,
        preview.start,
        preview.end,
        paint,
      );

      const radius = 7.0;

      drawDashedOval(
        canvas,
        Rect.fromCircle(
          center: preview.start,
          radius: radius,
        ),
        paint,
      );

      drawDashedOval(
        canvas,
        Rect.fromCircle(
          center: preview.end,
          radius: radius,
        ),
        paint,
      );
    } else if (preview is CubeShape) {
      final front = Rect.fromPoints(
        preview.start,
        preview.end,
      );

      final shift = Offset(
        front.width * 0.25,
        -front.height * 0.25,
      );

      final back = front.shift(shift);

      drawDashedRect(canvas, front, paint);
      drawDashedRect(canvas, back, paint);

      drawDashedLine(
        canvas,
        front.topLeft,
        back.topLeft,
        paint,
      );

      drawDashedLine(
        canvas,
        front.topRight,
        back.topRight,
        paint,
      );

      drawDashedLine(
        canvas,
        front.bottomLeft,
        back.bottomLeft,
        paint,
      );

      drawDashedLine(
        canvas,
        front.bottomRight,
        back.bottomRight,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.editor != editor;
  }
}
