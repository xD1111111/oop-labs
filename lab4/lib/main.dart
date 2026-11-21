
import 'package:flutter/material.dart';
import 'editor.dart';

void main() {
  runApp(const Lab4App());
}

// Глобальний об'єкт редактора.
// Ініціалізується один раз і використовується в усьому вікні.
final ShapeEditor globalEditor = ShapeEditor();

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна робота №4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const EditorWindow(),
    );
  }
}

class EditorWindow extends StatefulWidget {
  const EditorWindow({super.key});

  @override
  State<EditorWindow> createState() => _EditorWindowState();
}

class _EditorWindowState extends State<EditorWindow> {
  ShapeEditor get editor => globalEditor;

  @override
  void initState() {
    super.initState();
    editor.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    editor.removeListener(_refresh);
    // Глобальний редактор тут не знищуємо.
    super.dispose();
  }

  void _selectShape(ShapeType type) {
    editor.selectType(type);
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Графічний редактор — Lab4',
      applicationVersion: '1.0',
      children: const [
        Text(
          'Лабораторна робота №4 з ООП.\n'
          'Мова програмування: Dart.\n'
          'Фреймворк: Flutter.\n'
          'Варіант: Ж = 10.\n'
          'Максимум об\'єктів: 110.',
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      color: Colors.blue.shade50,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Інструменти:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          for (final type in ShapeType.values)
            Tooltip(
              message: type.title,
              child: IconButton(
                tooltip: type.title,
                isSelected: editor.selectedType == type,
                style: IconButton.styleFrom(
                  backgroundColor:
                      editor.selectedType == type
                          ? Colors.blue.shade200
                          : Colors.white,
                  side: BorderSide(
                    color: editor.selectedType == type
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                ),
                onPressed: () => _selectShape(type),
                icon: Icon(type.icon),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return MenuBar(
      children: [
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: editor.clear,
              child: const Text('Очистити'),
            ),
            MenuItemButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              child: const Text('Закрити'),
            ),
          ],
          child: const Text('Файл'),
        ),
        SubmenuButton(
          menuChildren: [
            for (final type in ShapeType.values)
              MenuItemButton(
                onPressed: () => _selectShape(type),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      child: editor.selectedType == type
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                    Text(type.title),
                  ],
                ),
              ),
          ],
          child: const Text("Об'єкти"),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: _showAbout,
              child: const Text('Про програму'),
            ),
          ],
          child: const Text('Довідка'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Лабораторна №4 — графічний редактор',
        ),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildMenu(),
          ),
          _buildToolbar(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.grey.shade100,
            child: Text(
              'Поточний об\'єкт: ${editor.selectedType.title}  '
              '|  Фігур: ${editor.count}/${ShapeEditor.maxShapes}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (details) {
                  editor.begin(details.localPosition);
                },
                onPanUpdate: (details) {
                  editor.update(details.localPosition);
                },
                onPanEnd: (details) {
                  final end = editor.preview?.end;
                  if (end != null) {
                    editor.finish(end);
                  }
                },
                onTapDown: (details) {
                  if (editor.selectedType == ShapeType.point) {
                    editor.begin(details.localPosition);
                    editor.finish(details.localPosition);
                  }
                },
                child: CustomPaint(
                  painter: DrawingPainter(editor),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
