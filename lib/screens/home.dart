import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter_sudoku/screens/game.dart';
import 'package:flutter_sudoku/shared/localization.dart';
import 'package:flutter_sudoku/widgets/home_page/level_select.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  onTap(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const LevelSelectSheet();
      },
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // TITLE
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appText[appLang]!['title']!,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5,
                    color: Colors.black87.withOpacity(.75),
                  ),
                ),
                //
                Text(
                  appText[appLang]!['subtitle']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 5,
                    color: Colors.blue.shade900.withOpacity(.8),
                  ),
                )
              ],
            ),
          ),
          //
          randomGameSection(appLang, context),
          // Expanded(
          //     child: Center(
          //   child: Image.asset(
          //     'assets/logo.png',
          //     width: 256,
          //     height: 256,
          //   ),
          // )),
          //
          // NEW GAME BUTTON
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: MaterialButton(
                height: 50,
                minWidth: 240,
                onPressed: () {
                  onTap(context);
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                color: Colors.blue.shade800.withOpacity(.8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  appText[appLang]!['new_game']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Expanded randomGameSection(String appLang, BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          height: 205,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24,
            ),
            child: Column(
              children: [
                //
                Text(
                  appText[appLang]!['random_game']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87.withOpacity(.8),
                  ),
                ),
                //
                const SizedBox(height: 20),
                //
                Icon(
                  Iconsax.calendar_1,
                  size: 64,
                  color: Colors.black87.withOpacity(.75),
                ),
                //
                const SizedBox(height: 20),
                //
                MaterialButton(
                  height: 40,
                  minWidth: 100,
                  onPressed: () {
                    List<String> levels = [
                      'Beginner',
                      'Easy',
                      'Medium',
                      'Hard',
                      'Expert',
                      'Champion',
                    ];
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GamePage(
                            difficulty: (levels..shuffle()).first,
                            isPrevGame: false),
                      ),
                    );
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  color: Colors.grey.shade200,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    appText[appLang]!['play']!,
                    style: TextStyle(
                      color: Colors.black87.withOpacity(.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
