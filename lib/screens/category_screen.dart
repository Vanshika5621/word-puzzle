import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../utils/puzzle_generator.dart';
import '../models/puzzle_model.dart';
import 'game_screen.dart';

// Category Screen - Browse puzzles by category
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allPuzzles = PuzzleGenerator.getAllPuzzles();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            const SizedBox(height: 16),
            
            // Categories List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: allPuzzles.entries.map((entry) {
                  return _buildCategorySection(
                    context,
                    title: entry.key,
                    puzzles: entry.value,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Categories',
              style: AppTextStyles.subheading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required List<PuzzleModel> puzzles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                title,
                style: AppTextStyles.subheading.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${puzzles.length}',
                  style: AppTextStyles.clue.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Puzzles Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: puzzles.length,
          itemBuilder: (context, index) {
            return _buildPuzzleCard(
              context,
              puzzle: puzzles[index],
            );
          },
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPuzzleCard(BuildContext context, {required PuzzleModel puzzle}) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return GestureDetector(
          onTap: () {
            gameProvider.startPuzzle(puzzle);
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Difficulty Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(puzzle.difficulty).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    puzzle.difficulty.name,
                    style: AppTextStyles.clue.copyWith(
                      color: _getDifficultyColor(puzzle.difficulty),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Grid Preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.grid_on,
                      size: 32,
                      color: AppColors.accent.withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${puzzle.gridSize}x${puzzle.gridSize}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Reward
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: AppColors.gold,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${puzzle.rewardCoins}',
                      style: AppTextStyles.clue.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.play_circle,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
}
