import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<GameProvider>(
          builder: (context, game, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  game.gameOver
                      ? (game.isDraw
                      ? "It's a Draw!"
                      : "${game.winner == Player.X ? 'X' : 'O'} Wins!")
                      : "Current Player: ${game.currentPlayer == Player.X ? 'X' : 'O'}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: game.gameOver
                        ? (game.isDraw ? Colors.grey : Colors.green)
                        : (game.currentPlayer == Player.X ? Colors.blue : Colors.red),
                  ),
                ),
                const SizedBox(height: 30),

                _buildBoard(game),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    game.resetGame();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBoard(GameProvider game) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: game.boardSize,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: game.boardSize * game.boardSize,
        itemBuilder: (ctx, index) {
          final player = game.board[index];
          final isWinnerCell = game.winningPattern.contains(index);

          return GestureDetector(
            onTap: () async {
              game.makeMove(index);

              // Vibrate when game ends
              if (game.gameOver) {
                bool canVibrate = await Vibration.hasVibrator() ?? false;
                if (canVibrate) {
                  Vibration.vibrate(duration: 500);
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isWinnerCell ? Colors.greenAccent.withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isWinnerCell ? Colors.green : Colors.black12,
                  width: isWinnerCell ? 3 : 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: player == Player.None
                      ? const SizedBox.shrink()
                      : Text(
                    player == Player.X ? "X" : "O",
                    key: ValueKey<String>(player == Player.X ? "X$index" : "O$index"),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: player == Player.X ? Colors.blue : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
