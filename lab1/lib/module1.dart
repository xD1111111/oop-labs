import 'package:flutter/material.dart';

/// Публічний інтерфейс модуля 1.
/// Повертає вибране число (1..100), або 0 при скасуванні.
Future<int> runModule1(BuildContext context) async {
  final result = await showDialog<int>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _SliderDialog(),
  );
  return result ?? 0;
}

// Реалізація діалогового вікна прихована всередині файлу.
class _SliderDialog extends StatefulWidget {
  const _SliderDialog();

  @override
  State<_SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<_SliderDialog> {
  double _number = 50;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Робота1 — введення числа')),
          IconButton(
            tooltip: 'Закрити',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(0),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Виберіть число від 1 до 100:'),
            const SizedBox(height: 12),
            Text(
              '${_number.round()}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Slider(
              min: 1,
              max: 100,
              divisions: 99,
              value: _number,
              label: _number.round().toString(),
              onChanged: (value) => setState(() => _number = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(0),
          child: const Text('Відміна'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_number.round()),
          child: const Text('Так'),
        ),
      ],
    );
  }
}
