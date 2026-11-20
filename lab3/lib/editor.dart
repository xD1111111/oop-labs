
import 'package:flutter/material.dart';
import 'shape.dart';

enum ShapeType {
  point,
  line,
  rectangle,
  ellipse,
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
    }
  }
}

class ShapeEditor extends ChangeNotifier {
  static const int maxShapes = 110;

  // Фіксована колекція на 110 позицій.
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

    return _createShape(_selectedType, _start!, _current!);
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

    final shape = _createShape(
      _selectedType,
      _start!,
      position,
    );

    _shapes[_count] = shape;
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
    }
  }
}

class DrawingPainter extends CustomPainter {
  final ShapeEditor editor;

  DrawingPainter(this.editor) : super(repaint: editor);

  @override
  void paint(Canvas canvas, Size size) {
    // Малюємо всі завершені фігури.
    for (final shape in editor.shapes) {
      shape.draw(canvas);
    }

    // Варіант 10: синій суцільний попередній контур.
    final preview = editor.preview;

    if (preview != null) {
      final paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      if (preview is PointShape) {
        canvas.drawCircle(preview.start, 3, paint);
      } else if (preview is LineShape) {
        canvas.drawLine(
          preview.start,
          preview.end,
          paint,
        );
      } else if (preview is RectangleShape) {
        canvas.drawRect(
          Rect.fromPoints(preview.start, preview.end),
          paint,
        );
      } else if (preview is EllipseShape) {
        final dx =
            (preview.end.dx - preview.start.dx).abs();
        final dy =
            (preview.end.dy - preview.start.dy).abs();

        final rect = Rect.fromLTRB(
          preview.start.dx - dx,
          preview.start.dy - dy,
          preview.start.dx + dx,
          preview.start.dy + dy,
        );

        canvas.drawOval(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.editor != editor;
  }
}
