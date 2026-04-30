import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/puzzle_model.dart';
import '../models/cell_model.dart';
import '../models/clue_model.dart';
import '../models/user_stats_model.dart';
import '../utils/puzzle_generator.dart';
import '../utils/constants.dart';

enum GameState { idle, playing, completed }

class GameProvider extends ChangeNotifier {
  PuzzleModel? _currentPuzzle;
  PuzzleModel? get currentPuzzle => _currentPuzzle;

  GameState _gameState = GameState.idle;
  GameState get gameState => _gameState;

  UserStatsModel? _userStats;
  UserStatsModel? get userStats => _userStats;

  int _playerScore = 0;
  int get playerScore => _playerScore;
  int _opponentScore = 0;
  int get opponentScore => _opponentScore;

  List<String> _tileTray = [];
  List<String> get tileTray => _tileTray;

  String? _message;
  String? get message => _message;

  // Compatibility with existing code
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(StorageKeys.userId) ?? 'user_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString(StorageKeys.userId, userId);
    _userStats = UserStatsModel(userId: userId);
    notifyListeners();
  }

  void startPuzzle(PuzzleModel puzzle) {
    _currentPuzzle = puzzle;
    _gameState = GameState.playing;
    _playerScore = 0;
    _opponentScore = 0;
    _generateTileTray();
    notifyListeners();
  }

  void startNewGame() {
    startPuzzle(PuzzleGenerator.getEasyPuzzle());
  }

  void _generateTileTray() {
    _tileTray = ["E", "L", "U", "T", "P", "Q", "A", "I", "S", "Y"];
    _tileTray.shuffle();
    notifyListeners();
  }

  void placeTile(String letter, int row, int col) {
    if (_currentPuzzle == null) return;
    final cell = _currentPuzzle!.grid[row][col];
    if (cell.isClue) return;

    _tileTray.remove(letter);
    cell.letter = letter;
    
    if (cell.letter == cell.correctLetter) {
      cell.isCorrect = true;
      _playerScore += 2; // More points for correct placement
    } else {
      cell.isWrong = true;
    }
    notifyListeners();
  }

  void removeTile(int row, int col) {
    if (_currentPuzzle == null) return;
    final cell = _currentPuzzle!.grid[row][col];
    if (cell.letter != null) {
      _tileTray.add(cell.letter!);
      if (cell.isCorrect) _playerScore -= 2;
      cell.letter = null;
      cell.isCorrect = false;
      cell.isWrong = false;
      notifyListeners();
    }
  }

  void resetGame() {
    startNewGame();
    _message = "Game Reset!";
    notifyListeners();
  }

  void revealHint() {
    if (_currentPuzzle == null) return;
    
    // Find an empty letter cell that isn't filled correctly
    List<CellModel> targetCells = [];
    for (var row in _currentPuzzle!.grid) {
      for (var cell in row) {
        if (!cell.isClue && cell.correctLetter != null && (cell.letter == null || !cell.isCorrect)) {
          targetCells.add(cell);
        }
      }
    }

    if (targetCells.isNotEmpty) {
      final cell = targetCells[Random().nextInt(targetCells.length)];
      cell.letter = cell.correctLetter;
      cell.isCorrect = true;
      _playerScore += 1;
      notifyListeners();
    }
  }

  void submitPuzzle() {
    _gameState = GameState.completed;
    _message = "Puzzle Submitted!";
    notifyListeners();
  }
}
