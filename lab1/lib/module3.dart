import 'package:flutter/material.dart';

/// Публічний інтерфейс модуля 3: друге діалогове вікно.
/// -1 — назад, 1 — так, 0 — відміна або закриття.
Future<int> runModule3(BuildContext context) async {
  final result = await showDialog<int>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _SecondDialog(),
  );
  return result ?? 0;
}

class _SecondDialog extends StatelessWidget {
  const _SecondDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Робота2 — друге вікно')),
          IconButton(
            tooltip: 'Закрити',
            onPressed: () => Navigator.of(context).pop(0),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: const SizedBox(
        width: 350,
        child: Text('Це друге діалогове вікно. Можна повернутися назад або підтвердити дію.'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(-1),
          child: const Text('< Назад'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(0),
          child: const Text('Відміна'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(1),
          child: const Text('Так'),
        ),
      ],
    );
  }
}
