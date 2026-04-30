import 'package:flutter/material.dart';

// Cell Model - Har ek grid cell ke liye
class CellModel {
  final int row;
  final int col;
  String? letter;           // User ne jo letter dala hai
  final String? correctLetter;  // Sahi answer ka letter
  final bool isBlack;       // Black cell hai ya nahi
  final String? clueText;   // Cell ke andar ka hint text
  final IconData? clueIcon; // Cell ke andar ka icon hint
  final int? clueNumber;    // Traditional numbering (optional)
  bool isSelected;
  bool isHighlighted;
  bool isWrong;
  bool isCorrect;
  bool isRevealed;
  bool isClue;              // Kya yeh clue cell hai?

  CellModel({
    required this.row,
    required this.col,
    this.letter,
    this.correctLetter,
    this.clueText,
    this.clueIcon,
    this.isBlack = false,
    this.clueNumber,
    this.isSelected = false,
    this.isHighlighted = false,
    this.isWrong = false,
    this.isCorrect = false,
    this.isRevealed = false,
    this.isClue = false,
  });

  CellModel copyWith({
    String? letter,
    bool? isSelected,
    bool? isHighlighted,
    bool? isWrong,
    bool? isCorrect,
    bool? isRevealed,
    bool? isClue,
    String? clueText,
    IconData? clueIcon,
  }) {
    return CellModel(
      row: row,
      col: col,
      letter: letter ?? this.letter,
      correctLetter: correctLetter,
      isBlack: isBlack,
      clueNumber: clueNumber,
      clueText: clueText ?? this.clueText,
      clueIcon: clueIcon ?? this.clueIcon,
      isSelected: isSelected ?? this.isSelected,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isWrong: isWrong ?? this.isWrong,
      isCorrect: isCorrect ?? this.isCorrect,
      isRevealed: isRevealed ?? this.isRevealed,
      isClue: isClue ?? this.isClue,
    );
  }
}
