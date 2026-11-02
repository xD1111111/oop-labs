import 'package:flutter/material.dart';

/// Публічний інтерфейс модуля 2: перше діалогове вікно.
/// 1 — далі, 0 — відміна або закриття.
Future<int> runModule2(BuildContext context) async {
  final result = await showDialog<int>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _FirstDialog(),
  );
  return result ?? 0;
}

class _FirstDialog extends StatelessWidget {
  const _FirstDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Робота2 — перше вікно')),
          IconButton(
            tooltip: 'Закрити',
            onPressed: () => Navigator.of(context).pop(0),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: const SizedBox(
        width: 350,
        child: Text('Це перше діалогове вікно. Натисніть «Далі», щоб перейти до другого.'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(0),
          child: const Text('Відміна'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(1),
          child: const Text('Далі >'),
        ),
      ],
    );
  }
}
