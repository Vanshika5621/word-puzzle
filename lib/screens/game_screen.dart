import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/cell_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startNewGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                _buildAppBar(),
                _buildMainTitle(),
                const SizedBox(height: 10),
                _buildScoreBar(provider),
                const Spacer(flex: 1), // Dynamic spacing
                _buildCrosswordGrid(provider),
                const Spacer(flex: 1), // Dynamic spacing
                _buildTileTray(provider),
                _buildBottomActions(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildMainTitle() {
    return const Column(
      children: [
        Text(
          "Solve",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF5D6981), letterSpacing: 0.5),
        ),
        Text(
          "Crosswords",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF2D3748), height: 1.1),
        ),
      ],
    );
  }

  Widget _buildScoreBar(GameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You", style: TextStyle(color: Color(0xFF718096), fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(width: 10),
            _buildScoreBox("${provider.playerScore}", const Color(0xFFEBF8FF), const Color(0xFF3182CE)),
            const SizedBox(width: 10),
            const Text("vs", style: TextStyle(color: Color(0xFF718096), fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(width: 10),
            _buildScoreBox("${provider.opponentScore}", const Color(0xFFF7FAFC), const Color(0xFFA0AEC0)),
            const SizedBox(width: 10),
            const Text("Opponent", style: TextStyle(color: Color(0xFF718096), fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBox(String score, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(score, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildCrosswordGrid(GameProvider provider) {
    if (provider.currentPuzzle == null) return const Center(child: CircularProgressIndicator());

    final grid = provider.currentPuzzle!.grid;
    final size = provider.currentPuzzle!.gridSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate max size that fits both width and a portion of height
          double availableWidth = constraints.maxWidth;
          return SizedBox(
            width: availableWidth,
            height: availableWidth,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: size * size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                int r = index ~/ size;
                int c = index % size;
                return _buildCell(provider, grid[r][c]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCell(GameProvider provider, CellModel cell) {
    if (cell.isClue) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          color: const Color(0xFFF7FAFC), // Slight background for clue cells
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (cell.clueIcon != null)
              Icon(cell.clueIcon, size: 14, color: const Color(0xFF3182CE)),
            if (cell.clueText != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                  cell.clueText!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Color(0xFF2D3748), height: 1.0),
                ),
              ),
          ],
        ),
      );
    }

    return DragTarget<String>(
      onAccept: (letter) => provider.placeTile(letter, cell.row, cell.col),
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
            color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.05) : Colors.white,
          ),
          child: cell.letter != null ? _buildGridTile(cell.letter!) : null,
        );
      },
    );
  }

  Widget _buildGridTile(String letter) {
    return Container(
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: const Color(0xFFFEEBC8),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 1, offset: const Offset(0, 1))],
      ),
      child: Center(
        child: Text(letter, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF744210))),
      ),
    );
  }

  Widget _buildTileTray(GameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: provider.tileTray.map((letter) => _buildDraggableTile(letter)).toList(),
      ),
    );
  }

  Widget _buildDraggableTile(String letter) {
    return Draggable<String>(
      data: letter,
      feedback: _buildTileUI(letter, isDragging: true),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildTileUI(letter)),
      child: _buildTileUI(letter),
    );
  }

  Widget _buildTileUI(String letter, {bool isDragging = false}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFFEEBC8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: isDragging ? 10 : 3, offset: Offset(0, isDragging ? 5 : 2))],
        ),
        child: Center(
          child: Text(letter, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF744210))),
        ),
      ),
    );
  }

  Widget _buildBottomActions(GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        children: [
          _buildActionButton(Icons.sync, const Color(0xFF3182CE), onTap: () => provider.resetGame()),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () => provider.submitPuzzle(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3182CE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 4,
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 15),
          _buildActionButton(Icons.lightbulb_outline, const Color(0xFF3182CE), badgeCount: 3, onTap: () => provider.revealHint()),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, {int? badgeCount, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          if (badgeCount != null)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Color(0xFF3182CE), shape: BoxShape.circle),
                child: Text("$badgeCount", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
    );
  }
}
