
import 'package:flutter/material.dart';
import 'shape.dart';

enum ShapeType {
  point('Крапка'),
  line('Лінія'),
  rectangle('Прямокутник'),
  ellipse('Еліпс');

  const ShapeType(this.label);
  final String label;
}

class ShapeEditor extends ChangeNotifier {
  static const int maxShapes = 109;

  // Динамічна колекція об'єктів Shape.
  final List<Shape> shapes = [];

  ShapeType selectedType = ShapeType.point;

  Offset? _start;
  Offset? _current;

  Offset? get start => _start;
  Offset? get current => _current;

  void selectType(ShapeType type) {
    selectedType = type;
    _start = null;
    _current = null;
    notifyListeners();
  }

  void beginDrawing(Offset position) {
    if (shapes.length >= maxShapes) return;

    _start = position;
    _current = position;
    notifyListeners();
  }

  void updateDrawing(Offset position) {
    if (_start == null) return;

    _current = position;
    notifyListeners();
  }

  void finishDrawing(Offset position) {
    if (_start == null || shapes.length >= maxShapes) return;

    final first = _start!;
    final second = position;

    Shape shape;

    switch (selectedType) {
      case ShapeType.point:
        shape = PointShape(first, second);
      case ShapeType.line:
        shape = LineShape(first, second);
      case ShapeType.rectangle:
        shape = RectangleShape(first, second);
      case ShapeType.ellipse:
        shape = EllipseShape(first, second);
    }

    shapes.add(shape);

    _start = null;
    _current = null;
    notifyListeners();
  }

  void cancelDrawing() {
    _start = null;
    _current = null;
    notifyListeners();
  }

  void clear() {
    shapes.clear();
    cancelDrawing();
  }
}

class DrawingPainter extends CustomPainter {
  final ShapeEditor editor;

  DrawingPainter(this.editor) : super(repaint: editor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    // Відображення всіх створених об'єктів.
    for (final shape in editor.shapes) {
      shape.draw(canvas, paint);
    }

    // Попередній перегляд — червоний суцільний слід.
    final start = editor.start;
    final current = editor.current;

    if (start != null && current != null) {
      final previewPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      switch (editor.selectedType) {
        case ShapeType.point:
          canvas.drawCircle(start, 3, previewPaint);

        case ShapeType.line:
          canvas.drawLine(start, current, previewPaint);

        case ShapeType.rectangle:
          final dx = (current.dx - start.dx).abs();
          final dy = (current.dy - start.dy).abs();

          canvas.drawRect(
            Rect.fromLTRB(
              start.dx - dx,
              start.dy - dy,
              start.dx + dx,
              start.dy + dy,
            ),
            previewPaint,
          );

        case ShapeType.ellipse:
          canvas.drawOval(
            Rect.fromPoints(start, current),
            previewPaint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.editor != editor;
  }
}
