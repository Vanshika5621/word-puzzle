// Clue Model - Across aur Down clues ke liye
class ClueModel {
  final int number;
  final String clue;
  final String answer;
  final int row;
  final int col;
  final bool isAcross;
  bool isCompleted;
  bool isRevealed;

  ClueModel({
    required this.number,
    required this.clue,
    required this.answer,
    required this.row,
    required this.col,
    required this.isAcross,
    this.isCompleted = false,
    this.isRevealed = false,
  });

  // Clue length nikalne ke liye
  int get length => answer.length;

  ClueModel copyWith({
    bool? isCompleted,
    bool? isRevealed,
  }) {
    return ClueModel(
      number: number,
      clue: clue,
      answer: answer,
      row: row,
      col: col,
      isAcross: isAcross,
      isCompleted: isCompleted ?? this.isCompleted,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }
}
