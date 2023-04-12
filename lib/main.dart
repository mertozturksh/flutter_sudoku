import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/screens/host.dart';
import 'package:flutter_sudoku/shared/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter('sudoku');
  await Hive.openBox('settings');
  await Hive.openBox('in_game_args');
  await Hive.openBox('prev_sudokus');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(
        keys: ['dark_theme', 'language'],
      ),
      builder: (context, box, child) {
        String appLang =
            Hive.box('settings').get('language', defaultValue: 'TR');
        return MaterialApp(
          title: appText[appLang]!['title']!,
          debugShowCheckedModeBanner: false,
          theme: box.get('dark_theme', defaultValue: false)
              ? ThemeData.dark()
              : ThemeData.light(),
          home: const HostPage(),
        );
      },
    );
  }
}
