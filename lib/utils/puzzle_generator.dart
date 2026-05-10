import 'package:flutter/material.dart';
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';

class PuzzleGenerator {
  static PuzzleModel getEasyPuzzle() {
    int size = 9;
    List<List<CellModel>> grid = List.generate(size, (r) => 
      List.generate(size, (c) => CellModel(row: r, col: c))
    );

    // Row 1 Word: QUALITY
    grid[1][0] = CellModel(row: 1, col: 0, isClue: true, clueText: "Standard\nof\nExcellence", clueIcon: Icons.star);
    grid[1][1] = CellModel(row: 1, col: 1, correctLetter: "Q");
    grid[1][2] = CellModel(row: 1, col: 2, correctLetter: "U");
    grid[1][3] = CellModel(row: 1, col: 3, correctLetter: "A");
    grid[1][4] = CellModel(row: 1, col: 4, correctLetter: "L");
    grid[1][5] = CellModel(row: 1, col: 5, correctLetter: "I");
    grid[1][6] = CellModel(row: 1, col: 6, correctLetter: "T");
    grid[1][7] = CellModel(row: 1, col: 7, correctLetter: "Y");

    // Row 3 Word: ESSAY
    grid[3][0] = CellModel(row: 3, col: 0, isClue: true, clueText: "Short\nWriting", clueIcon: Icons.edit_document);
    grid[3][1] = CellModel(row: 3, col: 1, correctLetter: "E");
    grid[3][2] = CellModel(row: 3, col: 2, correctLetter: "S");
    grid[3][3] = CellModel(row: 3, col: 3, correctLetter: "S");
    grid[3][4] = CellModel(row: 3, col: 4, correctLetter: "A");
    grid[3][5] = CellModel(row: 3, col: 5, correctLetter: "Y");

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

  static PuzzleModel getMediumPuzzle() {
    int size = 9;
    List<List<CellModel>> grid = List.generate(size, (r) => 
      List.generate(size, (c) => CellModel(row: r, col: c))
    );

    // Row 1 Word: WATER
    grid[1][1] = CellModel(row: 1, col: 1, isClue: true, clueText: "We Drink\nThis", clueIcon: Icons.water_drop);
    grid[1][2] = CellModel(row: 1, col: 2, correctLetter: "W");
    grid[1][3] = CellModel(row: 1, col: 3, correctLetter: "A");
    grid[1][4] = CellModel(row: 1, col: 4, correctLetter: "T");
    grid[1][5] = CellModel(row: 1, col: 5, correctLetter: "E");
    grid[1][6] = CellModel(row: 1, col: 6, correctLetter: "R");

    // Row 3 Word: HOUSE
    grid[3][1] = CellModel(row: 3, col: 1, isClue: true, clueText: "Where We\nLive", clueIcon: Icons.home);
    grid[3][2] = CellModel(row: 3, col: 2, correctLetter: "H");
    grid[3][3] = CellModel(row: 3, col: 3, correctLetter: "O");
    grid[3][4] = CellModel(row: 3, col: 4, correctLetter: "U");
    grid[3][5] = CellModel(row: 3, col: 5, correctLetter: "S");
    grid[3][6] = CellModel(row: 3, col: 6, correctLetter: "E");

    return PuzzleModel(
      id: "puzzle_2",
      title: "Medium Challenge",
      difficulty: Difficulty.medium,
      category: Category.general,
      gridSize: size,
      grid: grid,
      acrossClues: [],
      downClues: [],
    );
  }

  static PuzzleModel getHardPuzzle() {
    int size = 9;
    List<List<CellModel>> grid = List.generate(size, (r) => 
      List.generate(size, (c) => CellModel(row: r, col: c))
    );

    // Row 1 Word: SCHOOL
    grid[1][0] = CellModel(row: 1, col: 0, isClue: true, clueText: "Place to\nStudy", clueIcon: Icons.school);
    grid[1][1] = CellModel(row: 1, col: 1, correctLetter: "S");
    grid[1][2] = CellModel(row: 1, col: 2, correctLetter: "C");
    grid[1][3] = CellModel(row: 1, col: 3, correctLetter: "H");
    grid[1][4] = CellModel(row: 1, col: 4, correctLetter: "O");
    grid[1][5] = CellModel(row: 1, col: 5, correctLetter: "O");
    grid[1][6] = CellModel(row: 1, col: 6, correctLetter: "L");

    // Row 3 Word: FRIEND
    grid[3][0] = CellModel(row: 3, col: 0, isClue: true, clueText: "Best\nBuddy", clueIcon: Icons.people);
    grid[3][1] = CellModel(row: 3, col: 1, correctLetter: "F");
    grid[3][2] = CellModel(row: 3, col: 2, correctLetter: "R");
    grid[3][3] = CellModel(row: 3, col: 3, correctLetter: "I");
    grid[3][4] = CellModel(row: 3, col: 4, correctLetter: "E");
    grid[3][5] = CellModel(row: 3, col: 5, correctLetter: "N");
    grid[3][6] = CellModel(row: 3, col: 6, correctLetter: "D");

    return PuzzleModel(
      id: "puzzle_3",
      title: "Hard Challenge",
      difficulty: Difficulty.hard,
      category: Category.general,
      gridSize: size,
      grid: grid,
      acrossClues: [],
      downClues: [],
    );
  }

  static PuzzleModel getDailyPuzzle() => getMediumPuzzle();

  static List<PuzzleModel> getPuzzlesByDifficulty(Difficulty difficulty) {
    if (difficulty == Difficulty.easy) return [getEasyPuzzle()];
    if (difficulty == Difficulty.medium) return [getMediumPuzzle()];
    return [getHardPuzzle()];
  }

  static Map<String, List<PuzzleModel>> getAllPuzzles() {
    return {
      'Easy': [getEasyPuzzle()],
      'Medium': [getMediumPuzzle()],
      'Hard': [getHardPuzzle()],
      'Daily': [getDailyPuzzle()],
    };
  }
}
