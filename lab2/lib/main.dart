
import 'package:flutter/material.dart';
import 'editor.dart';

void main() {
  runApp(const Lab2App());
}

class Lab2App extends StatelessWidget {
  const Lab2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна робота №2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
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
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    editor.removeListener(_refresh);
    editor.dispose();
    super.dispose();
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Графічний редактор — Lab2',
      applicationVersion: '1.0',
      children: const [
        Text('Лабораторна робота №2 з ООП'),
        Text('Мова: Dart, фреймворк: Flutter'),
        Text('Номер у журналі: 9'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Лабораторна №2 — ${editor.selectedType.label}',
        ),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          MenuBar(
            children: [
              SubmenuButton(
                menuChildren: [
                  MenuItemButton(
                    onPressed: editor.clear,
                    child: const Text('Очистити'),
                  ),
                  MenuItemButton(
                    onPressed: () =>
                        Navigator.of(context).maybePop(),
                    child: const Text('Вихід'),
                  ),
                ],
                child: const Text('Файл'),
              ),
              SubmenuButton(
                menuChildren: [
                  for (final type in ShapeType.values)
                    MenuItemButton(
                      onPressed: () => editor.selectType(type),
                      child: Text(type.label),
                    ),
                ],
                child: const Text('Об’єкти'),
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
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.grey.shade100,
            child: Text(
              'Фігура: ${editor.selectedType.label}    '
              'Об’єктів: ${editor.shapes.length}/109',
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (details) {
                  editor.beginDrawing(
                    details.localPosition,
                  );
                },
                onPanUpdate: (details) {
                  editor.updateDrawing(
                    details.localPosition,
                  );
                },
                onPanEnd: (details) {
                  editor.finishDrawing(
                    editor.current ?? editor.start ??
                        Offset.zero,
                  );
                },
                onPanCancel: editor.cancelDrawing,
                child: SizedBox.expand(
                  child: CustomPaint(
                    painter: DrawingPainter(editor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
