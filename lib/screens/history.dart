import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/shared/localization.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
  //
  final ScrollController _scrollController = ScrollController();

  //
  late Box sudokuBox;
  late List sudokus;
  late int dataLength;
  late int currentMax;

  @override
  void initState() {
    super.initState();
    //
    sudokuBox = Hive.box('prev_sudokus');

    sudokus = sudokuBox.values.toList().reversed.toList();
    dataLength = sudokus.length;

    currentMax = 10 > dataLength ? dataLength : 10;

    //
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          currentMax < dataLength) {
        getMoreSudoku();
      }
    });
  }

  Future<void> getMoreSudoku() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    int i = 0;
    while (currentMax < dataLength && i < 10) {
      ++currentMax;
      ++i;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        const SizedBox(height: 40),
        //
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              appText[appLang]!['solved_sudokus']!,
              style: const TextStyle(
                fontSize: 32,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        //
        //
        const SizedBox(height: 60),
        //
        //
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Text(
                appText[appLang]!['history']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              //
              GestureDetector(
                onTap: () {
                  sudokuBox.clear();
                },
                child: Text(
                  '${appText[appLang]!['total']!} :  $currentMax',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              //
            ],
          ),
        ),
        //
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 15),
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            //
            itemCount: currentMax + 1,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemBuilder: (context, index) {
              if (index == currentMax && currentMax != dataLength) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (index != dataLength) {
                Map item = sudokus.elementAt(index);
                return HistoryCard(
                  level: item['difficulty'],
                  date: item['date'],
                  time: item['time'],
                  duration: item['duration'],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.level,
    required this.date,
    required this.time,
    required this.duration,
  });

  final String level;
  final String date;
  final String time;
  final String duration;

  @override
  Widget build(BuildContext context) {
    String appLang = Hive.box('settings').get('language', defaultValue: 'TR');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Row(
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  Text(
                    appText[appLang]!['difficulty']!,
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  //
                  const SizedBox(height: 6),
                  //
                  Text(
                    appText[appLang]![level.toLowerCase()]!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87.withOpacity(.8),
                    ),
                  ),
                  //
                ],
              ),
            ),
            //
            Expanded(child: Container()),
            //
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //
                Row(
                  children: [
                    Text(
                      "$date  $time",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //
                    const SizedBox(width: 10),
                    //
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 32,
                      color: Colors.black87.withOpacity(.8),
                    ),
                  ],
                ),
                //
                const Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
                //
                Row(
                  children: [
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //
                    const SizedBox(width: 10),
                    //
                    Icon(
                      Icons.timer_outlined,
                      size: 32,
                      color: Colors.black87.withOpacity(.8),
                    ),
                  ],
                ),
                //
              ],
            ),
          ],
        ),
      ),
    );
  }
}
