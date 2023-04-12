import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/shared/localization.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({
    super.key,
    required this.gameTime,
    required this.difficulty,
  });

  final String difficulty;
  final Duration gameTime;

  @override
  Widget build(BuildContext context) {
    String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
    return ValueListenableBuilder(
      valueListenable:
          Hive.box('in_game_args').listenable(keys: ['time', 'mistakes']),
      builder: (context, value, child) {
        // time data example ->  01:25
        String time = Hive.box('in_game_args').get('time', defaultValue: '0');
        int mistakes =
            Hive.box('in_game_args').get('mistakes', defaultValue: 0);

        String min = time.split(':').first.padLeft(2, '0');
        String sec = time.split(':').last.padLeft(2, '0');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Text(
                appText[appLang]![difficulty.toLowerCase()]!,
                style: TextStyle(
                  color: Colors.blue.shade900.withOpacity(.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  ValueListenableBuilder(
                    valueListenable: Hive.box('settings')
                        .listenable(keys: ['mistakesLimit']),
                    builder: (context, value, child) {
                      bool limit = Hive.box('settings')
                          .get('mistakesLimit', defaultValue: true);
                      return Text(
                        '${appText[appLang]!['mistakes']!} : $mistakes ${limit ? "/ 3" : ""}',
                        style: TextStyle(
                          color: Colors.black87.withOpacity(.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                  //
                  Text(
                    "$min:$sec",
                    style: TextStyle(
                      color: Colors.black87.withOpacity(.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  //
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
