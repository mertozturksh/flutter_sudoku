import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/utils/sudoku.dart';

class NumericButton extends StatelessWidget {
  NumericButton({
    super.key,
    required this.num,
    required this.sudoku,
    required this.history,
    required this.gameTime,
    required this.difficulty,
    required this.penActivated,
    required this.remainingValues,
    required this.fastModeActivated,
    required this.checkSudokuCompleted,
  });

  final int num;
  final String difficulty;
  final Duration gameTime;
  final bool penActivated;
  final bool fastModeActivated;
  final Map<int, int> remainingValues;
  final List<List<SudokuCell>> sudoku;
  final VoidCallback checkSudokuCompleted;
  final List<MapEntry<String, String>> history;

  final Box sudokuBox = Hive.box('in_game_args');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
        valueListenable:
            sudokuBox.listenable(keys: ['fastModeValue', 'fastMode']),
        builder: (context, value, child) {
          int fastModeValue = 0;
          if (fastModeActivated) {
            fastModeValue = sudokuBox.get('fastModeValue', defaultValue: 0);
          }
          return Ink(
            decoration: BoxDecoration(
              color: fastModeActivated
                  ? (fastModeValue == num)
                      ? Colors.white
                      : Colors.white.withOpacity(.9)
                  : Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: fastModeActivated
                      ? (fastModeValue == num)
                          ? Colors.grey.shade500
                          : Colors.grey.shade50
                      : Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                // fast mode
                if (fastModeActivated) {
                  sudokuBox.put('fastModeValue', num);
                  sudokuBox.put('highlightValue', num);
                  sudokuBox.put('xy', '99');
                }
                // classic mode
                else {
                  String currentItem = sudokuBox.get('xy', defaultValue: '99');
                  int row = int.parse(currentItem[0]);
                  int col = int.parse(currentItem[1]);

                  if ((row == 9 || col == 9)) return;

                  sudokuBox.put('fastModeValue', 0);

                  // normal fill mode
                  if (!penActivated) {
                    sudokuBox.put('highlightValue', num);

                    // try toggle value
                    if (sudoku[row][col].toggleValue(num)) {
                      sudokuBox.put('fill', '$row$col');

                      // value is wrong
                      if (!sudoku[row][col].isCompleted) {
                        sudokuBox.put(
                          'mistakes',
                          sudokuBox.get('mistakes', defaultValue: 0) + 1,
                        );
                        history.add(MapEntry('wrong', '$row$col'));

                        // doldurduktan sonra o değer tükeniyorsa
                        // grid'de rowcol highlightning i kapatıyoruz.
                        if (remainingValues[fastModeValue] == 0) {
                          sudokuBox.put('xy', '99');
                        }
                      }
                      // value is correct
                      else {
                        remainingValues[num] = (remainingValues[num]! - 1);
                        history.add(MapEntry('correct', '$row$col'));
                        sudokuBox.put('remainingVals', 0);
                      }

                      checkSudokuCompleted();
                    }
                  }
                  // take note mode
                  else {
                    // try toggle note
                    if (sudoku[row][col].toggleNote(num)) {
                      sudokuBox.put('fill', '$row$col');
                      // history.add(MapEntry('note', '$row$col'));
                    }
                  }
                }
              },
              child: SizedBox(
                height: 65,
                width: width / 11,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          num.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: fastModeActivated
                                ? (fastModeValue == num)
                                    ? Colors.black87.withOpacity(.8)
                                    : Colors.black87.withOpacity(.2)
                                : Colors.black87.withOpacity(.8),
                          ),
                        ),
                        Expanded(child: Container()),
                        Text(
                          remainingValues[num].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: fastModeActivated
                                ? (fastModeValue == num)
                                    ? Colors.black45.withOpacity(.8)
                                    : Colors.black54.withOpacity(.2)
                                : Colors.black45.withOpacity(.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
