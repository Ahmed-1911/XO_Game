import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'X and O Game',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String?> gameBoard = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      gameBoard = List.filled(9, '');
      currentPlayer = 'X';
      gameEnded = false;
    });
  }

  void makeMove(int index) {
    if (gameBoard[index] == '') {
      setState(() {
        gameBoard[index] = currentPlayer;
        checkGameEnd();
        if (!gameEnded) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  void checkGameEnd() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (gameBoard[i] != '' &&
          gameBoard[i] == gameBoard[i + 1] &&
          gameBoard[i + 1] == gameBoard[i + 2]) {
        showWinnerDialog(gameBoard[i]!);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (gameBoard[i] != '' &&
          gameBoard[i] == gameBoard[i + 3] &&
          gameBoard[i + 3] == gameBoard[i + 6]) {
        showWinnerDialog(gameBoard[i]!);
        return;
      }
    }

    // Check diagonals
    if (gameBoard[0] != '' &&
        gameBoard[0] == gameBoard[4] &&
        gameBoard[4] == gameBoard[8]) {
      showWinnerDialog(gameBoard[0]!);
      return;
    }
    if (gameBoard[2] != '' &&
        gameBoard[2] == gameBoard[4] &&
        gameBoard[4] == gameBoard[6]) {
      showWinnerDialog(gameBoard[2]!);
      return;
    }

    // Check draw
    bool allFilled = true;
    for (int i = 0; i < 9; i++) {
      if (gameBoard[i] == '') {
        allFilled = false;
        break;
      }
    }
    if (allFilled) {
      showDrawDialog();
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Player $winner wins!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                startNewGame();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
    gameEnded = true;
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('It\'s a draw!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                startNewGame();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
    gameEnded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('X and O Game'),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.3),
        itemBuilder: (_, index) => GestureDetector(
          onTap: () {
            if (!gameEnded) {
              makeMove(index);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color:  Colors.white,
              border: Border.all(
                color: Colors.teal,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                gameBoard[index] ?? '',
                style: TextStyle(
                  fontSize: 55.0,
                  fontWeight: FontWeight.w700,
                  color: gameBoard[index] == 'X'
                      ? Colors.indigo
                      : gameBoard[index] == 'O'
                      ? Colors.deepOrangeAccent
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
