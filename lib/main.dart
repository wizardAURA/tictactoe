import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/screens/game_screen.dart' show GameScreen;
import 'providers/game_provider.dart';
import 'screens/splash_screen.dart';


void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => GameProvider(),// will be created later
    child: Tictac(),
  ));
}

class Tictac extends StatelessWidget {
  const Tictac({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/game': (context) => GameScreen(),
      },
    );
  }
}
