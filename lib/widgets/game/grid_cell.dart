import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/utils/sudoku.dart';

class GridCell extends StatelessWidget {
  GridCell({
    super.key,
    required this.row,
    required this.col,
    required this.cell,
    required this.sudoku,
    required this.history,
    required this.remainingValues,
    required this.checkSudokuCompleted,
  });

  final int row;
  final int col;
  final SudokuCell cell;
  final List<MapEntry<String, String>> history;
  final Map<int, int> remainingValues;
  final List<List<SudokuCell>> sudoku;
  final VoidCallback checkSudokuCompleted;

  final Box sudokuBox = Hive.box('in_game_args');

  @override
  Widget build(BuildContext context) {
    BorderSide thickBorder = const BorderSide(width: 2, color: Colors.black);
    BorderSide thinBorder = const BorderSide(width: 1, color: Colors.grey);

    FontWeight prefilledWeight = FontWeight.w700;
    FontWeight latefilledWeight = FontWeight.w500;

    Color prefilledColor = Colors.black87.withOpacity(.8);
    Color incorrectColor = Colors.red.shade400;
    Color latefilledColor = Colors.blue.shade800;

    Color highlightBG = Colors.blue.shade100;
    Color rowColHighBG = Colors.grey.shade100;
    Color defaultBG = Colors.white;

    const double fontSize = 24;

    //
    String data = sudokuBox.get('xy', defaultValue: '99');
    int rowH = int.parse(data[0]);
    int colH = int.parse(data[1]);

    bool valueHighlight = data == '99'
        ? false
        : !sudoku[rowH][colH].isCompleted
            ? false
            : cell.currentValue != sudoku[rowH][colH].currentValue
                ? false
                : true;

    bool centerHighlight = (col == colH && row == rowH);

    bool horizontalVerticalHighlight = (col == colH || row == rowH);

    return ValueListenableBuilder(
      valueListenable:
          Hive.box('settings').listenable(keys: ['regHigh', 'numHigh']),
      builder: (context, value, child) {
        bool settingsValHigh = Hive.box('settings').get(
          'numHigh',
          defaultValue: true,
        );
        valueHighlight = valueHighlight && settingsValHigh;

        horizontalVerticalHighlight = horizontalVerticalHighlight &&
            Hive.box('settings').get(
              'regHigh',
              defaultValue: true,
            );
        int fastModeValue = sudokuBox.get('fastModeValue', defaultValue: 0);
        int highlightValue = sudokuBox.get('highlightValue', defaultValue: 0);

        centerHighlight = centerHighlight && fastModeValue == 0;

        valueHighlight = (settingsValHigh &&
            (highlightValue != 0 && highlightValue == cell.currentValue));
        return Ink(
          // fastMode modu açıkken değer seçildiğinde tahtadaki aynı değere sahip
          // olan hepsi seçilmeli.
          decoration: BoxDecoration(
            color: (centerHighlight || valueHighlight)
                ? highlightBG
                : horizontalVerticalHighlight
                    ? rowColHighBG
                    : defaultBG,
            border: Border(
              left: (col == 0 || col == 3 || col == 6)
                  ? thickBorder
                  : BorderSide.none,
              top:
                  (row == 0 || row == 3 || row == 6) ? thickBorder : thinBorder,
              bottom: (row == 8) ? thickBorder : BorderSide.none,
              right: (col == 8) ? thickBorder : thinBorder,
            ),
          ),
          child: InkWell(
            onTap: () {
              String rowCol = sudokuBox.get(
                'xy',
                defaultValue: '99',
              );
              //
              bool fastModeActivated =
                  sudokuBox.get('fastMode', defaultValue: true);

              bool penActivated = sudokuBox.get('penMode', defaultValue: false);

              // cell highlighting
              if (rowCol != '$row$col') {
                sudokuBox.put('xy', '$row$col');
              }

              // fast mode
              if (fastModeActivated) {
                // hücre dolu değilse
                if (!cell.isCompleted) {
                  // normal mode
                  if (!penActivated) {
                    // seçili değer 0 değil ise
                    if (fastModeValue != 0 &&
                        remainingValues[fastModeValue] != 0) {
                      // dokunulan hücre seçili değer ile doldurulmaya çalışılacak.
                      if (sudoku[row][col].toggleValue(fastModeValue)) {
                        sudokuBox.put('fill', '$row$col');

                        // wrong value
                        if (!sudoku[row][col].isCompleted) {
                          sudokuBox.put(
                            'mistakes',
                            sudokuBox.get('mistakes', defaultValue: 0) + 1,
                          );
                          history.add(MapEntry('wrong', '$row$col'));
                        }
                        // correct value
                        else {
                          remainingValues[fastModeValue] =
                              (remainingValues[fastModeValue]! - 1);

                          sudokuBox.put('remainingVals', 0);
                          history.add(MapEntry('correct', '$row$col'));

                          // doldurduktan sonra o değer tükeniyorsa
                          // grid'de rowcol highlightning i kapatıyoruz.
                          if (remainingValues[fastModeValue] == 0) {
                            sudokuBox.put('xy', '99');
                          }
                        }
                        checkSudokuCompleted();
                      }
                    } else {
                      sudokuBox.put('highlightValue', cell.currentValue);
                      sudokuBox.put('fastModeValue', cell.currentValue);
                    }
                  }

                  // pen mode
                  else {
                    if (sudoku[row][col].toggleNote(fastModeValue)) {
                      sudokuBox.put('fill', '$row$col');
                      // history.add(MapEntry('note', '$row$col'));
                    }
                  }
                }
                // hücre dolu ise
                else {
                  sudokuBox.put('xy', '$row$col');
                  sudokuBox.put('highlightValue', cell.currentValue);
                  sudokuBox.put('fastModeValue', cell.currentValue);
                }
              }
              // normal mode
              else {
                // cell highlighting
                if (rowCol != '$row$col') {
                  sudokuBox.put('xy', '$row$col');
                  sudokuBox.put('highlightValue', cell.currentValue);
                }
              }
            },
            child: cell.useAsNote
                ? NoteSection(
                    notes: cell.notes,
                    highlightVal: highlightValue,
                    isSettingsActive: settingsValHigh,
                  )
                : Center(
                    child: Text(
                      cell.isEmpty ? "" : cell.currentValue.toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: cell.isPrefilled
                            ? prefilledWeight
                            : latefilledWeight,
                        color: cell.isPrefilled
                            ? prefilledColor
                            : cell.isCompleted
                                ? latefilledColor
                                : incorrectColor,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class NoteSection extends StatelessWidget {
  const NoteSection({
    super.key,
    required this.notes,
    required this.highlightVal,
    required this.isSettingsActive,
  });
  final List<int> notes;
  final int highlightVal;
  final bool isSettingsActive;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: List.generate(9, (index) {
        return Container(
          decoration: BoxDecoration(
            color: (isSettingsActive &&
                    highlightVal == index + 1 &&
                    notes.contains(index + 1))
                ? Colors.blue.shade100
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              notes.contains(index + 1) ? "${index + 1}" : "",
              style: const TextStyle(fontSize: 10),
            ),
          ),
        );
      }),
    );
  }
}
