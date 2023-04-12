import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_sudoku/utils/sudoku.dart';
import 'package:flutter_sudoku/widgets/game/grid_cell.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.sudoku,
    required this.sudokuBox,
    required this.history,
    required this.checkSudokuCompleted,
    required this.remainingValues,
  });

  final Box sudokuBox;
  final List<MapEntry<String, String>> history;

  final Map<int, int> remainingValues;
  final List<List<SudokuCell>> sudoku;
  final VoidCallback checkSudokuCompleted;

  @override
  Widget build(BuildContext context) {
    int row = 0, col = 0;
    return ValueListenableBuilder(
      valueListenable: sudokuBox.listenable(keys: [
        'xy',
        'fill',
        'erase',
        'hint',
        'fastModeValue',
        'highlightValue',
      ]),
      builder: (context, value, child) {
        // print("REFRESH");
        return AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 9,
              children: List.generate(81, (index) {
                row = index ~/ 9;
                col = index % 9;
                return GridCell(
                  row: row,
                  col: col,
                  history: history,
                  sudoku: sudoku,
                  cell: sudoku[row][col],
                  remainingValues: remainingValues,
                  checkSudokuCompleted: checkSudokuCompleted,
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
