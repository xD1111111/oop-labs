import 'package:flutter/material.dart';

import 'module1.dart';
import 'module2.dart';
import 'module3.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лабораторна №1 — ООП',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Lab1Home(),
    );
  }
}

class Lab1Home extends StatefulWidget {
  const Lab1Home({super.key});

  @override
  State<Lab1Home> createState() => _Lab1HomeState();
}

class _Lab1HomeState extends State<Lab1Home> {
  int? _selectedNumber;
  String _work2Result = 'Ще не виконано';

  Future<void> _openWork1() async {
    // Єдина зовнішня функція модуля 1 повертає 0 при скасуванні.
    final result = await runModule1(context);
    if (!mounted || result == 0) return;

    setState(() {
      _selectedNumber = result;
    });
  }

  Future<void> _openWork2() async {
    // Перше і друге діалогові вікна знаходяться в окремих модулях.
    // Кожне вікно закривається до показу наступного.
    while (mounted) {
      final firstResult = await runModule2(context);
      if (!mounted || firstResult == 0) return;

      final secondResult = await runModule3(context);
      if (!mounted) return;

      if (secondResult == -1) {
        // Назад: знову відкриваємо перше вікно.
        continue;
      }
      if (secondResult == 1) {
        setState(() {
          _work2Result = 'Завершено (натиснуто «Так»)';
        });
      }
      // 0 — Відміна або закриття хрестиком.
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №1'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MenuBar(
              children: [
                MenuItemButton(
                  onPressed: _openWork1,
                  child: const Text('Робота1'),
                ),
                MenuItemButton(
                  onPressed: _openWork2,
                  child: const Text('Робота2'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Номер у журналі: 9',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      const Text('Варіант В1 = 1, варіант В2 = 2.'),
                      const SizedBox(height: 24),
                      Text(
                        'Робота1 — число від 1 до 100:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _selectedNumber?.toString() ?? 'Число ще не вибрано',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Робота2 — два діалоги:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(_work2Result),
                    ],
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
