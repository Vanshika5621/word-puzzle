import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/user_stats_model.dart';
import '../models/puzzle_model.dart';
import '../utils/constants.dart';
import '../utils/puzzle_generator.dart';
import 'category_screen.dart';
import 'game_screen.dart';

// Home Screen - Main menu screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final stats = gameProvider.userStats;

            return Column(
              children: [
                // Header
                _buildHeader(stats),
                
                const SizedBox(height: 24),
                
                // Main Menu Options
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      // Daily Puzzle Card
                      _buildDailyPuzzleCard(context, gameProvider),
                      
                      const SizedBox(height: 20),
                      
                      // Play Button
                      _buildMainButton(
                        context,
                        icon: Icons.play_circle_fill,
                        title: 'Play Now',
                        subtitle: 'Choose your puzzle',
                        color: AppColors.accent,
                        onTap: () => _showDifficultySelector(context, gameProvider),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Categories
                      _buildMainButton(
                        context,
                        icon: Icons.category,
                        title: 'Categories',
                        subtitle: 'Browse by topic',
                        color: AppColors.gold,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CategoryScreen(),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Statistics
                      _buildMainButton(
                        context,
                        icon: Icons.bar_chart,
                        title: 'Statistics',
                        subtitle: 'View your progress',
                        color: AppColors.correctLetter,
                        onTap: () => _showStatistics(context, stats),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Shop / Buy Hints
                      _buildMainButton(
                        context,
                        icon: Icons.shopping_cart,
                        title: 'Shop',
                        subtitle: 'Buy hints & coins',
                        color: AppColors.revealedLetter,
                        onTap: () => _showShop(context, gameProvider),
                      ),
                    ],
                  ),
                ),
                
                // Bottom Info
                _buildBottomInfo(stats),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(UserStatsModel? stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Logo/Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.grid_on,
                size: 40,
                color: AppColors.accent,
              ),
              const SizedBox(width: 12),
              Text(
                'Crossword',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 32,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Puzzle Master',
            style: AppTextStyles.subheading.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.monetization_on,
                value: '${stats?.totalCoins ?? 0}',
                label: 'Coins',
                color: AppColors.gold,
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: '${stats?.currentStreak ?? 0}',
                label: 'Streak',
                color: AppColors.revealedLetter,
              ),
              _buildStatItem(
                icon: Icons.emoji_events,
                value: '${stats?.totalPuzzlesSolved ?? 0}',
                label: 'Solved',
                color: AppColors.correctLetter,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.subheading.copyWith(
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.clue.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyPuzzleCard(BuildContext context, GameProvider provider) {
    final dailyPuzzle = PuzzleGenerator.getDailyPuzzle();
    
    return GestureDetector(
      onTap: () {
        provider.startPuzzle(dailyPuzzle);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GameScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent,
              AppColors.accentLight,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Puzzle',
                    style: AppTextStyles.subheading.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Play today\'s special challenge!',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTag(dailyPuzzle.difficulty.name),
                      const SizedBox(width: 8),
                      _buildTag('+${dailyPuzzle.rewardCoins} coins'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.clue.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMainButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo(UserStatsModel? stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            'Hints Available: ${stats?.hintsAvailable ?? 0}',
            style: AppTextStyles.clue.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showDifficultySelector(BuildContext context, GameProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Difficulty',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 20),
              
              _buildDifficultyOption(
                context,
                difficulty: Difficulty.easy,
                provider: provider,
              ),
              const SizedBox(height: 12),
              _buildDifficultyOption(
                context,
                difficulty: Difficulty.medium,
                provider: provider,
              ),
              const SizedBox(height: 12),
              _buildDifficultyOption(
                context,
                difficulty: Difficulty.hard,
                provider: provider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDifficultyOption(
    BuildContext context, {
    required Difficulty difficulty,
    required GameProvider provider,
  }) {
    final puzzles = PuzzleGenerator.getPuzzlesByDifficulty(difficulty);
    
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        provider.startPuzzle(puzzles.first);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GameScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getDifficultyColor(difficulty).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${difficulty.gridSize}x${difficulty.gridSize}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(difficulty),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${puzzles.length} puzzles available',
                    style: AppTextStyles.clue.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return AppColors.correctLetter;
      case Difficulty.medium:
        return AppColors.gold;
      case Difficulty.hard:
        return AppColors.revealedLetter;
      case Difficulty.expert:
        return AppColors.wrongLetter;
    }
  }

  void _showStatistics(BuildContext context, UserStatsModel? stats) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'Your Statistics',
                    style: AppTextStyles.heading,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  _buildStatCard(
                    'Puzzles Solved',
                    '${stats?.totalPuzzlesSolved ?? 0}',
                    Icons.check_circle,
                    AppColors.correctLetter,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Current Streak',
                    '${stats?.currentStreak ?? 0} days',
                    Icons.local_fire_department,
                    AppColors.revealedLetter,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Best Streak',
                    '${stats?.bestStreak ?? 0} days',
                    Icons.emoji_events,
                    AppColors.gold,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Total Time',
                    '${((stats?.totalTimePlayed ?? 0) / 3600).toStringAsFixed(1)} hrs',
                    Icons.timer,
                    AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Hints Used',
                    '${stats?.hintsUsed ?? 0}',
                    Icons.lightbulb,
                    AppColors.revealedLetter,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.subheading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showShop(BuildContext context, GameProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shop',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 8),
              Text(
                'Buy hints to help solve puzzles',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              
              _buildShopItem(
                context,
                title: '10 Hints',
                price: '100 coins',
                onTap: () {
                  provider.userStats?.buyHints(10, 100);
                  provider.notifyListeners();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                title: '50 Hints',
                price: '400 coins',
                discount: '20% OFF',
                onTap: () {
                  provider.userStats?.buyHints(50, 400);
                  provider.notifyListeners();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildShopItem(
                context,
                title: '100 Hints',
                price: '700 coins',
                discount: '30% OFF',
                onTap: () {
                  provider.userStats?.buyHints(100, 700);
                  provider.notifyListeners();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopItem(
    BuildContext context, {
    required String title,
    required String price,
    String? discount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lightbulb,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    price,
                    style: AppTextStyles.clue.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
            if (discount != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.wrongLetter.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  discount,
                  style: AppTextStyles.clue.copyWith(
                    color: AppColors.wrongLetter,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
