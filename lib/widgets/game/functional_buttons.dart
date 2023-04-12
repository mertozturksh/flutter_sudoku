import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter_sudoku/utils/sudoku.dart';

class FunctionalButtons extends StatefulWidget {
  const FunctionalButtons({
    super.key,
    required this.sudoku,
    required this.history,
    required this.checkSudokuCompleted,
    required this.remainingValues,
  });

  final Map<int, int> remainingValues;
  final List<List<SudokuCell>> sudoku;
  final VoidCallback checkSudokuCompleted;
  final List<MapEntry<String, String>> history;

  @override
  State<FunctionalButtons> createState() => _FunctionalButtonsState();
}

class _FunctionalButtonsState extends State<FunctionalButtons> {
  //
  late Box sudokuBox;

  @override
  void initState() {
    super.initState();
    //
    sudokuBox = Hive.box('in_game_args');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //
        // UNDO BUTTON
        Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // geri alma tuşu eleman sayısını etkiliyor, düzgün çalışmıyor.

              /// son yapılan 'fill' işlemini geri alma butonu.
              /// eğer son işlem yoksa hiçbir şey olmayacak.
              /// son yapılan işlem doğru veya yanlış olsun fark etmez. işlem gerçekleşecek.
              if (widget.history.isNotEmpty) {
                MapEntry<String, String> action = widget.history.last;
                int row = int.parse(action.value[0]);
                int col = int.parse(action.value[1]);

                switch (action.key) {
                  case 'correct':
                    int num = widget.sudoku[row][col].currentValue;
                    widget.remainingValues[num] =
                        (widget.remainingValues[num]! + 1);
                    widget.sudoku[row][col].toggleEmpty();
                    break;
                  case 'wrong':
                    widget.sudoku[row][col].toggleEmpty();
                    break;
                  case 'note':
                    widget.sudoku[row][col].notes.removeLast();
                    break;
                  default:
                }

                widget.history.removeLast();

                sudokuBox.put('xy', '99');
                sudokuBox.put('remainingVals', 0);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                size: 32,
                Iconsax.undo,
                color: Colors.black87.withOpacity(.8),
              ),
            ),
          ),
        ),
        //
        //
        // ERASE BUTTON
        Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              String currentItem = sudokuBox.get('xy', defaultValue: '99');
              int row = int.parse(currentItem[0]);
              int col = int.parse(currentItem[1]);

              if (row == 9 || col == 9) return;

              if (widget.sudoku[row][col].toggleErase()) {
                sudokuBox.put('erase', '$row$col');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                size: 32,
                Iconsax.eraser_15,
                color: Colors.black87.withOpacity(.8),
              ),
            ),
          ),
        ),
        //
        //
        // PENCIL BUTTON
        ValueListenableBuilder(
          valueListenable: sudokuBox.listenable(keys: ['penMode']),
          builder: (context, value, child) {
            bool penActivated = sudokuBox.get('penMode', defaultValue: false);
            return Ink(
              decoration: BoxDecoration(
                color: penActivated ? Colors.green.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  sudokuBox.put(
                    'penMode',
                    !sudokuBox.get('penMode', defaultValue: false),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    size: 32,
                    Iconsax.edit,
                    color: Colors.black87.withOpacity(.8),
                  ),
                ),
              ),
            );
          },
        ),
        //
        //
        // FASTMODE BUTTON
        ValueListenableBuilder(
          valueListenable: sudokuBox.listenable(keys: ['fastMode']),
          builder: (context, value, child) {
            bool fastModeActivated =
                sudokuBox.get('fastMode', defaultValue: true);
            return Ink(
              decoration: BoxDecoration(
                color: fastModeActivated ? Colors.green.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  sudokuBox.put(
                    'fastMode',
                    !sudokuBox.get('fastMode', defaultValue: true),
                  );

                  sudokuBox.put('fastModeValue', 0);
                  sudokuBox.put('xy', '99');
                  sudokuBox.put('highlightValue', 0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    size: 32,
                    Iconsax.flash5,
                    color: Colors.black87.withOpacity(.7),
                  ),
                ),
              ),
            );
          },
        ),
        //
        //
        // HINT BUTTON
        ValueListenableBuilder(
          valueListenable: sudokuBox.listenable(keys: ['hintCount']),
          builder: (context, value, child) {
            int usedHints = sudokuBox.get('hintCount', defaultValue: 0);
            return Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      String currentItem =
                          sudokuBox.get('xy', defaultValue: '99');
                      int row = int.parse(currentItem[0]);
                      int col = int.parse(currentItem[1]);

                      if (row == 9 || col == 9) return;

                      if (Hive.box('settings').get(
                            'hintLimit',
                            defaultValue: true,
                          ) &&
                          usedHints >= 3) {
                        return;
                      }

                      if (widget.sudoku[row][col].toggleHint()) {
                        sudokuBox.put('hint', '$row$col');

                        sudokuBox.put(
                          'hintCount',
                          sudokuBox.get('hintCount', defaultValue: 0) + 1,
                        );

                        int num = widget.sudoku[row][col].actualValue;

                        widget.remainingValues[num] =
                            (widget.remainingValues[num]! - 1);

                        if (widget.remainingValues[num] == 0) {
                          sudokuBox.put('xy', '99');
                        }

                        sudokuBox.put('xy', '$row$col');
                        sudokuBox.put('highlightValue', num);
                        sudokuBox.put('fastModeValue', num);

                        widget.checkSudokuCompleted();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        size: 32,
                        Icons.lightbulb_outline_sharp,
                        color: Colors.black87.withOpacity(.8),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(.8),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ValueListenableBuilder(
                          valueListenable: Hive.box('settings')
                              .listenable(keys: ['hintLimit']),
                          builder: (context, value, child) {
                            bool hintLimit = Hive.box('settings')
                                .get('hintLimit', defaultValue: true);
                            return Text(
                              '${hintLimit ? (3 - usedHints >= 0 ? 3 - usedHints : 0) : "∞"}',
                              style: TextStyle(fontSize: hintLimit ? 14 : 11),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        //
      ],
    );
  }
}
