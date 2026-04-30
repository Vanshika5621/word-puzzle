// App Constants - Saari important values yahan hain
import 'package:flutter/material.dart';

// 🎨 Color Scheme - Dark Navy Theme
class AppColors {
  // Background Colors
  static const Color background = Color(0xFF1A1A2E);
  static const Color backgroundLight = Color(0xFF252542);
  static const Color surface = Color(0xFF2D2D44);
  
  // Grid Colors
  static const Color gridWhite = Colors.white;
  static const Color gridBlack = Color(0xFF0D0D1A);
  static const Color gridBorder = Color(0xFF3D3D5C);
  
  // Highlight Colors
  static const Color selectedCell = Color(0xFFFFD700); // Yellow
  static const Color selectedWord = Color(0xFFB8E6FF); // Light Blue
  static const Color completedWord = Color(0xFF90EE90); // Light Green
  
  // Validation Colors
  static const Color wrongLetter = Color(0xFFFF4444); // Red
  static const Color correctLetter = Color(0xFF44FF44); // Green
  static const Color revealedLetter = Color(0xFFFFA500); // Orange
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textDark = Color(0xFF1A1A2E);
  
  // Accent Colors
  static const Color accent = Color(0xFF6C63FF);
  static const Color accentLight = Color(0xFF8B85FF);
  static const Color gold = Color(0xFFFFD700);
  static const Color coin = Color(0xFFFFA500);
}

// 📏 Dimensions
class AppDimensions {
  // Grid
  static const double cellSize = 32.0;
  static const double cellBorderWidth = 1.0;
  static const double clueNumberSize = 10.0;
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}

// 🎮 Game Settings
class GameSettings {
  // Hint Costs
  static const int hintLetterCost = 10;
  static const int hintWordCost = 50;
  static const int hintPuzzleCost = 100;
  
  // Rewards
  static const int dailyRewardCoins = 50;
  static const int puzzleCompletionReward = 30;
  static const int streakBonusMultiplier = 10;
  
  // Timer
  static const int maxTimeForBonus = 300; // 5 minutes
}

// 📝 Text Styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subheading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle clue = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle clueNumber = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  static const TextStyle cellLetter = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}

// 🌐 Backend Configuration
class BackendConfig {
  static const String baseUrl = 'https://little-carrots-stare.loca.lt';
}

// 💾 Storage Keys
class StorageKeys {
  static const String userId = 'user_id';
  static const String userStats = 'user_stats';
  static const String theme = 'theme_mode';
}
