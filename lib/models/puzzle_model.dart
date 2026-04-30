import 'cell_model.dart';
import 'clue_model.dart';

// Puzzle Difficulty Levels
enum Difficulty { easy, medium, hard, expert }

// Puzzle Category
enum Category { daily, animals, food, sports, movies, general }

extension DifficultyExtension on Difficulty {
  String get name {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      case Difficulty.expert:
        return 'Expert';
    }
  }

  int get gridSize {
    switch (this) {
      case Difficulty.easy:
        return 5;
      case Difficulty.medium:
        return 10;
      case Difficulty.hard:
        return 13;
      case Difficulty.expert:
        return 15;
    }
  }
}

// Puzzle Model - Complete puzzle data
class PuzzleModel {
  final String id;
  final String title;
  final Difficulty difficulty;
  final Category category;
  final int gridSize;
  final List<List<CellModel>> grid;
  final List<ClueModel> acrossClues;
  final List<ClueModel> downClues;
  final DateTime? dailyDate;
  final int hintsAllowed;
  final int rewardCoins;

  PuzzleModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.category,
    required this.gridSize,
    required this.grid,
    required this.acrossClues,
    required this.downClues,
    this.dailyDate,
    this.hintsAllowed = 3,
    this.rewardCoins = 50,
  });

  // JSON se puzzle banana
  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    return PuzzleModel(
      id: json['id'],
      title: json['title'] ?? 'Untitled Puzzle',
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name.toLowerCase() == json['difficulty'],
        orElse: () => Difficulty.easy,
      ),
      category: Category.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => Category.general,
      ),
      gridSize: json['grid_size'] ?? 10,
      grid: _parseGrid(json['grid']),
      acrossClues: _parseClues(json['clues']['across'], true),
      downClues: _parseClues(json['clues']['down'], false),
      dailyDate: json['daily_date'] != null 
          ? DateTime.parse(json['daily_date']) 
          : null,
      hintsAllowed: json['hints_allowed'] ?? 3,
      rewardCoins: json['reward_coins'] ?? 50,
    );
  }

  static List<List<CellModel>> _parseGrid(List<dynamic> gridData) {
    List<List<CellModel>> grid = [];
    for (int i = 0; i < gridData.length; i++) {
      List<CellModel> row = [];
      for (int j = 0; j < gridData[i].length; j++) {
        var cellData = gridData[i][j];
        row.add(CellModel(
          row: i,
          col: j,
          correctLetter: cellData == '#' ? null : cellData as String?,
          isBlack: cellData == '#',
        ));
      }
      grid.add(row);
    }
    return grid;
  }

  static List<ClueModel> _parseClues(List<dynamic> cluesData, bool isAcross) {
    return cluesData.map((clue) => ClueModel(
      number: clue['number'],
      clue: clue['clue'],
      answer: clue['answer'],
      row: clue['row'] ?? 0,
      col: clue['col'] ?? 0,
      isAcross: isAcross,
    )).toList();
  }

  // Total words count
  int get totalWords => acrossClues.length + downClues.length;

  // Completed words count
  int get completedWords {
    int completed = 0;
    for (var clue in acrossClues) {
      if (clue.isCompleted) completed++;
    }
    for (var clue in downClues) {
      if (clue.isCompleted) completed++;
    }
    return completed;
  }

  // Is puzzle completed?
  bool get isCompleted => completedWords == totalWords;
}
