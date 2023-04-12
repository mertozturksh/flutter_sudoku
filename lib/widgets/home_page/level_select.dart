import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/screens/game.dart';
import 'package:flutter_sudoku/shared/localization.dart';

class LevelSelectSheet extends StatelessWidget {
  const LevelSelectSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          section(context, 'Beginner'),
          section(context, 'Easy'),
          section(context, 'Medium'),
          section(context, 'Hard'),
          section(context, 'Expert'),
          section(context, 'Champion'),
        ],
      ),
    );
  }

  Widget section(BuildContext context, String name) {
    String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GamePage(difficulty: name, isPrevGame: false),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300.withOpacity(.8),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appText[appLang]![name.toLowerCase()]!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87.withOpacity(.8),
                ),
              ),
              //

              //
            ],
          ),
        ),
      ),
    );
  }
}
