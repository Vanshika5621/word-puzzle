import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

// Win Screen - Celebration screen after completing puzzle
class WinScreen extends StatefulWidget {
  const WinScreen({super.key});

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final puzzle = gameProvider.currentPuzzle;
            final stats = gameProvider.userStats;
            final time = gameProvider.timerText;

            return Stack(
              children: [
                // Confetti
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: true,
                    colors: const [
                      AppColors.gold,
                      AppColors.accent,
                      AppColors.correctLetter,
                      AppColors.revealedLetter,
                    ],
                  ),
                ),
                
                // Main Content
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Trophy Icon
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withAlpha((0.2 * 255).toInt()),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withAlpha((0.3 * 255).toInt()),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            size: 80,
                            color: AppColors.gold,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Congratulations Text
                        Text(
                          'Congratulations!',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 32,
                            color: AppColors.gold,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Puzzle Completed!',
                          style: AppTextStyles.subheading.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Stats Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accent.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Puzzle Name
                              Text(
                                puzzle?.title ?? 'Puzzle',
                                style: AppTextStyles.subheading,
                              ),
                              const SizedBox(height: 16),
                              
                              // Stats Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStat(
                                    icon: Icons.timer,
                                    value: time,
                                    label: 'Time',
                                    color: AppColors.accent,
                                  ),
                                  _buildStat(
                                    icon: Icons.monetization_on,
                                    value: '+${puzzle?.rewardCoins ?? 0}',
                                    label: 'Coins',
                                    color: AppColors.gold,
                                  ),
                                  _buildStat(
                                    icon: Icons.local_fire_department,
                                    value: '${stats?.currentStreak ?? 0}',
                                    label: 'Streak',
                                    color: AppColors.revealedLetter,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        _buildButton(
                          context,
                          title: 'Play Next Puzzle',
                          icon: Icons.play_arrow,
                          color: AppColors.accent,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildButton(
                          context,
                          title: 'Share Score',
                          icon: Icons.share,
                          color: AppColors.correctLetter,
                          onTap: () => _shareScore(context, gameProvider),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildButton(
                          context,
                          title: 'Back to Home',
                          icon: Icons.home,
                          color: AppColors.surface,
                          isOutlined: true,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat({
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
            color: color,
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

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    bool isOutlined = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(12),
          border: isOutlined
              ? Border.all(color: color, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isOutlined ? color : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.button.copyWith(
                color: isOutlined ? color : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareScore(BuildContext context, GameProvider provider) {
    final puzzle = provider.currentPuzzle;
    final time = provider.timerText;
    final stats = provider.userStats;

    final shareText = '''
🎉 I just completed "${puzzle?.title ?? 'Crossword Puzzle'}"!

⏱️ Time: $time
🔥 Streak: ${stats?.currentStreak ?? 0} days
💰 Earned: ${puzzle?.rewardCoins ?? 0} coins

Can you beat my time? Download the app now!
''';    
    // Show share dialog
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
                'Share Your Score',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  shareText,
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildShareButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      color: AppColors.accent,
                      onTap: () {
                        // Copy to clipboard
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Copied to clipboard!',
                              style: AppTextStyles.body,
                            ),
                            backgroundColor: AppColors.accent,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildShareButton(
                      icon: Icons.share,
                      label: 'Share',
                      color: AppColors.correctLetter,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
