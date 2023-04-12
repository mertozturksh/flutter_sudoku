import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class SudokuProvider {
  //
  static List<List<SudokuCell>> makeNewSudoku(
      {required String difficulty, bool hasUniqueSolution = true}) {
    List<List<int>> emptySudoku;
    List<List<int>> solvedSudoku;

    int emptyCellSize = _getEmptyCellSize(difficulty);

    if (hasUniqueSolution && emptyCellSize > 54) {
      emptySudoku =
          SudokuGenerator(emptySquares: emptyCellSize, uniqueSolution: false)
              .newSudoku;
    } else {
      emptySudoku =
          SudokuGenerator(emptySquares: emptyCellSize, uniqueSolution: true)
              .newSudoku;
    }
    solvedSudoku = _getSolvedSudoku(emptySudoku);

    List<List<SudokuCell>> grid = [];

    for (int i = 0; i < 9; i++) {
      List<SudokuCell> temp = [];
      for (int j = 0; j < 9; j++) {
        temp.add(SudokuCell(
          actualValue: solvedSudoku[i][j],
          currentValue: emptySudoku[i][j],
        ));
      }
      grid.add(temp);
    }
    return grid;
  }

  //
  static List<List<int>> _getSolvedSudoku(List<List<int>> sudoku) {
    return SudokuSolver.solve(sudoku);
  }

  //
  static int _getEmptyCellSize(String diff) {
    switch (diff.toLowerCase()) {
      case 'beginner':
        return 15;
      case 'easy':
        return 20;
      case 'medium':
        return 30;
      case 'hard':
        return 40;
      case 'expert':
        return 54;
      case 'champion':
        return 61;
      default:
        return 30;
    }
  }
  //
  // static void printSudoku(List<List<SudokuCell>> sudoku) {
  //   for (var i in sudoku) {
  //     print(i);
  //   }
  // }
}

class SudokuCell {
  late bool isEmpty;
  late final bool isPrefilled;
  List<int> notes = [];
  bool useAsNote = false;
  bool isCompleted = false;
  int actualValue;
  int currentValue;

  SudokuCell({required this.actualValue, required this.currentValue}) {
    if (currentValue == 0) {
      isEmpty = true;
      isPrefilled = false;
    } else {
      isEmpty = false;
      isPrefilled = true;
      isCompleted = true;
    }
  }

  @override
  String toString() {
    var item = isEmpty ? "-" : currentValue.toString();
    return item;
  }

  bool toggleValue(int val) {
    if (!isPrefilled && !isCompleted) {
      isEmpty = false;
      currentValue = val;
      useAsNote = false;
      notes.clear();
      isCompleted = actualValue == currentValue;
      return true;
    }
    return false;
  }

  void toggleEmpty() {
    isEmpty = true;
    // useAsNote = false;
    currentValue = 0;
    isCompleted = false;
  }

  bool toggleErase() {
    if (!isPrefilled && !isEmpty && !isCompleted) {
      isEmpty = true;
      useAsNote = false;
      currentValue = 0;
      return true;
    } else if (useAsNote) {
      notes.clear();
      useAsNote = false;
      return true;
    }
    return false;
  }

  bool toggleNote(int val) {
    if (!isCompleted && !notes.contains(val)) {
      notes.add(val);
      useAsNote = true;
      return true;
    }
    return false;
  }

  bool toggleHint() {
    if (!isPrefilled && !isCompleted) {
      isEmpty = false;
      isCompleted = true;
      useAsNote = false;
      currentValue = actualValue;
      return true;
    }
    return false;
  }
}
