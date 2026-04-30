import 'package:flutter/material.dart';
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';

class PuzzleGenerator {
  static PuzzleModel getEasyPuzzle() {
    int size = 9;
    List<List<CellModel>> grid = List.generate(size, (r) => 
      List.generate(size, (c) => CellModel(row: r, col: c))
    );

    // Row 0 Clues with Clear Icons & Better Text
    grid[0][1] = CellModel(row: 0, col: 1, isClue: true, clueText: "BEST", clueIcon: Icons.workspace_premium);
    grid[0][3] = CellModel(row: 0, col: 3, isClue: true, clueText: "FOR", clueIcon: Icons.redo);
    grid[0][5] = CellModel(row: 0, col: 5, isClue: true, clueText: "LONG", clueIcon: Icons.timer_outlined);
    grid[0][6] = CellModel(row: 0, col: 6, isClue: true, clueText: "SALT", clueIcon: Icons.opacity);
    grid[0][7] = CellModel(row: 0, col: 7, isClue: true, clueText: "PASS", clueIcon: Icons.verified_user_outlined);

    // Row 1 Word: QUALITY
    grid[1][1] = CellModel(row: 1, col: 1, correctLetter: "Q");
    grid[1][2] = CellModel(row: 1, col: 2, correctLetter: "U");
    grid[1][3] = CellModel(row: 1, col: 3, correctLetter: "A");
    grid[1][4] = CellModel(row: 1, col: 4, correctLetter: "L");
    grid[1][5] = CellModel(row: 1, col: 5, correctLetter: "I");
    grid[1][6] = CellModel(row: 1, col: 6, correctLetter: "T");
    grid[1][7] = CellModel(row: 1, col: 7, correctLetter: "Y");

    // Column 0 Clues
    grid[2][0] = CellModel(row: 2, col: 0, isClue: true, clueText: "PIECE", clueIcon: Icons.pie_chart_outline);
    grid[3][0] = CellModel(row: 3, col: 0, isClue: true, clueText: "TIME", clueIcon: Icons.schedule);
    grid[4][0] = CellModel(row: 4, col: 0, isClue: true, clueText: "HELP", clueIcon: Icons.medical_services_outlined);

    // Row 3 Word: ESSAY
    grid[3][1] = CellModel(row: 3, col: 1, correctLetter: "E");
    grid[3][2] = CellModel(row: 3, col: 2, correctLetter: "S");
    grid[3][3] = CellModel(row: 3, col: 3, correctLetter: "S");
    grid[3][4] = CellModel(row: 3, col: 4, correctLetter: "A");
    grid[3][5] = CellModel(row: 3, col: 5, correctLetter: "Y");

    // Background Hint Icons (in "empty" boxes like the screenshot)
    grid[5][5] = CellModel(row: 5, col: 5, isClue: true, clueText: "SUN", clueIcon: Icons.wb_sunny_outlined);
    grid[6][2] = CellModel(row: 6, col: 2, isClue: true, clueText: "MUSIC", clueIcon: Icons.music_note_outlined);
    grid[2][6] = CellModel(row: 2, col: 6, isClue: true, clueText: "CAR", clueIcon: Icons.directions_car_outlined);
    grid[7][7] = CellModel(row: 7, col: 7, isClue: true, clueText: "LOCK", clueIcon: Icons.lock_outline);

    return PuzzleModel(
      id: "puzzle_1",
      title: "Crossword Challenge",
      difficulty: Difficulty.easy,
      category: Category.general,
      gridSize: size,
      grid: grid,
      acrossClues: [],
      downClues: [],
    );
  }

  static PuzzleModel getMediumPuzzle() => getEasyPuzzle();
  static PuzzleModel getHardPuzzle() => getEasyPuzzle();
  static PuzzleModel getDailyPuzzle() => getEasyPuzzle();

  static List<PuzzleModel> getPuzzlesByDifficulty(Difficulty difficulty) => [getEasyPuzzle()];

  static Map<String, List<PuzzleModel>> getAllPuzzles() {
    return {
      'Easy': [getEasyPuzzle()],
      'Medium': [getEasyPuzzle()],
      'Daily': [getEasyPuzzle()],
    };
  }
}
