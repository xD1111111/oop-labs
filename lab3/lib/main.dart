
import 'package:flutter/material.dart';
import 'editor.dart';

void main() {
  runApp(const Lab3App());
}

class Lab3App extends StatelessWidget {
  const Lab3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна робота №3',
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
  final ShapeEditor editor = ShapeEditor();

  @override
  void initState() {
    super.initState();
    editor.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    editor.removeListener(_refresh);
    editor.dispose();
    super.dispose();
  }

  void _selectShape(ShapeType type) {
    editor.selectType(type);
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Графічний редактор — Lab3',
      applicationVersion: '1.0',
      children: const [
        Text(
          'Лабораторна робота №3 з ООП.\n'
          'Реалізація: Dart / Flutter.\n'
          'Варіант: Ж = 10.',
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          const Text(
            'Інструменти:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          for (final type in ShapeType.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Tooltip(
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
          'Лабораторна №3 — графічний редактор',
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
                  editor.finish(
                    editor.preview?.end ??
                        Offset.zero,
                  );
                },
                onTapDown: (details) {
                  if (editor.selectedType ==
                      ShapeType.point) {
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
