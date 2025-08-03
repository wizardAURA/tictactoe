import 'package:flutter/material.dart';

enum Player { X, O, None }

class GameProvider extends ChangeNotifier {
 // 3x3 board represented as a single list of 9 elements
 List<Player> _board = List<Player>.filled(9, Player.None);

 Player _currentPlayer = Player.X;
 Player _winner = Player.None;
 bool _isDraw = false;
 bool _gameOver = false;
 List<int> _winningPattern = [];
 List<int> get winningPattern => _winningPattern;

 List<Player> get board => _board;
 Player get currentPlayer => _currentPlayer;
 Player get winner => _winner;
 bool get isDraw => _isDraw;
 bool get gameOver => _gameOver;

 // Size of the board (3x3)
 final int boardSize = 3;

 // Generate winning patterns dynamically for any board size
 List<List<int>> _generateWinPatterns(int size) {
  List<List<int>> patterns = [];

  // Rows
  for (int row = 0; row < size; row++) {
   patterns.add([for (int col = 0; col < size; col++) row * size + col]);
  }

  // Columns
  for (int col = 0; col < size; col++) {
   patterns.add([for (int row = 0; row < size; row++) row * size + col]);
  }

  // Diagonal: top-left to bottom-right
  patterns.add([for (int i = 0; i < size; i++) i * size + i]);

  // Diagonal: top-right to bottom-left
  patterns.add([for (int i = 0; i < size; i++) i * size + (size - i - 1)]);

  return patterns;
 }

 // Make a move on the board if the spot is empty and game not over
 void makeMove(int index) {
  if (_board[index] != Player.None || _gameOver) return;

  _board[index] = _currentPlayer;
  _checkGameStatus();
  if (!_gameOver) {
   // Toggle player for next move
   _currentPlayer = _currentPlayer == Player.X ? Player.O : Player.X;
  }
  notifyListeners();
 }

 // Check if there is a winner or a draw
 void _checkGameStatus() {
  List<List<int>> winPatterns = _generateWinPatterns(boardSize);

  for (var pattern in winPatterns) {
   if (_board[pattern[0]] != Player.None) {
    bool allMatch = true;
    for (int i = 1; i < pattern.length; i++) {
     if (_board[pattern[i]] != _board[pattern[0]]) {
      allMatch = false;
      break;
     }
    }
    if (allMatch) {
     _winner = _board[pattern[0]];
     _gameOver = true;
     _winningPattern = pattern;
     return;
    }
   }
  }

  // If no empty cells and no winner, declare a draw
  if (!_board.contains(Player.None)) {
   _isDraw = true;
   _gameOver = true;
  }
 }

 // Reset the game state for a new game
 void resetGame() {
  _board = List<Player>.filled(boardSize * boardSize, Player.None);
  _currentPlayer = Player.X;
  _winner = Player.None;
  _isDraw = false;
  _gameOver = false;
  _winningPattern = [];
  notifyListeners();
 }
}
