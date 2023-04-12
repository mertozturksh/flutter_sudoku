import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/shared/localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.fromRoot});

  final bool fromRoot;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    child: Icon(
                      size: 26,
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87.withOpacity(.75),
                    ),
                  ),
                ),
                //
                const SizedBox(width: 20),
                //
                //
                Text(
                  appText[appLang]!['settings']!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87.withOpacity(.8),
                  ),
                ),
                //
                Expanded(child: Container()),
                //
                widget.fromRoot
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            String appLang = Hive.box('settings')
                                .get('language', defaultValue: 'TR');

                            if (appLang == 'EN') {
                              Hive.box('settings').put('language', 'TR');
                            } else if (appLang == 'TR') {
                              Hive.box('settings').put('language', 'EN');
                            }
                            setState(() {});
                          },
                          child: SizedBox(
                              width: 48,
                              height: 48,
                              child:
                                  Image.asset('assets/language_$appLang.png')),
                        ),
                      )
                    : Container(),
                //
              ],
            ),
            //
            const SizedBox(height: 30),
            //
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (context, value, child) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        //
                        SettingsCard(
                          icon: Iconsax.audio_square,
                          text: appText[appLang]!['audio']!,
                          settName: 'audio',
                          defaultValue: false,
                        ),
                        //
                        SettingsCard(
                          text: appText[appLang]!['vibration']!,
                          icon: Icons.vibration_rounded,
                          settName: 'vibration',
                          defaultValue: false,
                        ),
                        //
                        SettingsCard(
                          text: appText[appLang]!['hint_limit']!,
                          icon: Icons.lightbulb_outline,
                          settName: 'hintLimit',
                          defaultValue: true,
                        ),
                        //
                        SettingsCard(
                          text: appText[appLang]!['mistake_limit']!,
                          icon: Icons.highlight_off_sharp,
                          settName: 'mistakesLimit',
                          defaultValue: true,
                        ),
                        //
                        SettingsCard(
                          text: appText[appLang]!['region_high']!,
                          icon: Icons.games_rounded,
                          settName: 'regHigh',
                          defaultValue: true,
                        ),
                        //
                        SettingsCard(
                          text: appText[appLang]!['number_high']!,
                          icon: Icons.numbers_outlined,
                          settName: 'numHigh',
                          defaultValue: true,
                        ),
                        //
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class SettingsCard extends StatefulWidget {
  const SettingsCard({
    super.key,
    required this.text,
    required this.icon,
    required this.settName,
    required this.defaultValue,
  });

  final String text;
  final IconData icon;
  final String settName;
  final bool defaultValue;

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    bool value = Hive.box('settings')
        .get(widget.settName, defaultValue: widget.defaultValue);
    String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Row(
              children: [
                Icon(
                  widget.icon,
                  color: Colors.black87.withOpacity(.8),
                  size: 32,
                ),
                //
                const SizedBox(width: 15),
                //
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54.withOpacity(.8),
                  ),
                ),
                //
                Expanded(child: Container()),
                //
                //
                Switch(
                  value: ['audio', 'vibration'].contains(widget.settName)
                      ? false
                      : value,
                  onChanged: (_) {
                    setState(() {
                      value = !value;
                      Hive.box('settings').put(widget.settName, value);
                    });
                  },
                ),
              ],
              //
            ),
            //
            ['audio', 'vibration'].contains(widget.settName)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 6),
                    child: Text(
                      appText[appLang]!['${widget.settName}_descr']!,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
