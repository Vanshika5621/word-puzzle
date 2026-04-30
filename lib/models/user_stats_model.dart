// User Statistics Model - User ki progress track karne ke liye
class UserStatsModel {
  final String userId;
  int totalPuzzlesSolved;
  int totalCoins;
  int currentStreak;
  int bestStreak;
  int hintsUsed;
  int hintsAvailable;
  int totalTimePlayed; // seconds
  DateTime? lastPlayedDate;
  Map<String, dynamic> puzzleProgress; // Puzzle ID -> progress data

  UserStatsModel({
    required this.userId,
    this.totalPuzzlesSolved = 0,
    this.totalCoins = 100, // Starting coins
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.hintsUsed = 0,
    this.hintsAvailable = 3,
    this.totalTimePlayed = 0,
    this.lastPlayedDate,
    this.puzzleProgress = const {},
  });

  // JSON se banana
  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      userId: json['user_id'],
      totalPuzzlesSolved: json['total_puzzles_solved'] ?? 0,
      totalCoins: json['total_coins'] ?? 100,
      currentStreak: json['current_streak'] ?? 0,
      bestStreak: json['best_streak'] ?? 0,
      hintsUsed: json['hints_used'] ?? 0,
      hintsAvailable: json['hints_available'] ?? 3,
      totalTimePlayed: json['total_time_played'] ?? 0,
      lastPlayedDate: json['last_played_date'] != null
          ? DateTime.parse(json['last_played_date'])
          : null,
      puzzleProgress: json['puzzle_progress'] ?? {},
    );
  }

  // JSON me convert karna
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_puzzles_solved': totalPuzzlesSolved,
      'total_coins': totalCoins,
      'current_streak': currentStreak,
      'best_streak': bestStreak,
      'hints_used': hintsUsed,
      'hints_available': hintsAvailable,
      'total_time_played': totalTimePlayed,
      'last_played_date': lastPlayedDate?.toIso8601String(),
      'puzzle_progress': puzzleProgress,
    };
  }

  // Streak update karna
  void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastPlayedDate == null) {
      currentStreak = 1;
    } else {
      final lastDate = DateTime(
        lastPlayedDate!.year,
        lastPlayedDate!.month,
        lastPlayedDate!.day,
      );
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 1) {
        currentStreak++;
      } else if (difference > 1) {
        currentStreak = 1;
      }
      // difference == 0 means same day, streak remains same
    }
    
    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
    }
    lastPlayedDate = now;
  }

  // Coins add karna
  void addCoins(int amount) {
    totalCoins += amount;
  }

  // Coins spend karna
  bool spendCoins(int amount) {
    if (totalCoins >= amount) {
      totalCoins -= amount;
      return true;
    }
    return false;
  }

  // Hint use karna
  bool useHint() {
    if (hintsAvailable > 0) {
      hintsAvailable--;
      hintsUsed++;
      return true;
    }
    return false;
  }

  // Hints buy karna
  void buyHints(int count, int cost) {
    if (spendCoins(cost)) {
      hintsAvailable += count;
    }
  }
}
