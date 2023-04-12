import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sudoku/screens/settings.dart';

class UpperBar extends StatelessWidget {
  const UpperBar({
    super.key,
    required this.name,
    required this.pauseDialog,
    required this.moveBackButton,
  });

  final String name;
  final VoidCallback pauseDialog;
  final VoidCallback moveBackButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          //
          // TODO: oyun tamamlanmamış ise bitmemiş oyun olarak kaydedilmeli.
          // MOVE BACK BUTTON
          GestureDetector(
            onTap: () {
              moveBackButton();
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              child: Icon(
                size: 26,
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87.withOpacity(.75),
              ),
            ),
          ),
          //
          //
          Expanded(child: Container()),
          //
          //
          // PAUSE BUTTON
          GestureDetector(
            onTap: () {
              pauseDialog();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              child: Icon(
                size: 26,
                Icons.pause_circle_outline_rounded,
                color: Colors.black87.withOpacity(.75),
              ),
            ),
          ),
          //
          const SizedBox(width: 20),
          //
          //
          // SETTINGS BUTTON
          GestureDetector(
            onTap: () {
              pauseDialog();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(fromRoot: false),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              child: Icon(
                Iconsax.setting,
                size: 26,
                color: Colors.black87.withOpacity(.75),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }
}
