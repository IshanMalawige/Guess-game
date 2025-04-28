import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GuessGameScreen(),
    );
  }
}

class GuessGameScreen extends StatefulWidget {
  const GuessGameScreen({super.key});

  @override
  State<GuessGameScreen> createState() => _GuessGameScreenState();
}

class _GuessGameScreenState extends State<GuessGameScreen> {
  final TextEditingController _guessController = TextEditingController();
  int _remainingAttempts = 3;
  final int _secretNumber = 5; // The number to guess (1-10)
  List<int> _guesses = [];

  void _checkGuess() {
    final int? guess = int.tryParse(_guessController.text);

    if (guess == null || guess < 1 || guess > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid number between 1-10')),
      );
      return;
    }

    setState(() {
      _guesses.add(guess);
    });

    if (guess == _secretNumber) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CorrectGuessScreen(),
        ),
      );
      _resetGame();
    } else {
      _remainingAttempts--;
      if (_remainingAttempts > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WrongGuessScreen(guess: guess),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameOverScreen(guesses: _guesses),
          ),
        );
        _resetGame();
      }
    }

    _guessController.clear();
  }

  void _resetGame() {
    setState(() {
      _remainingAttempts = 3;
      _guesses = [];
    });
  }

  Widget _buildBlueButton(
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Curved edges
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Guess Game')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Guess.png',
                height: 150,
                width: 150,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.question_mark, size: 150),
              ),
              const SizedBox(height: 20),
              const Text(
                'Guess a number between 1-10',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'You have $_remainingAttempts attempts left',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _guessController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your guess',
                ),
              ),
              const SizedBox(height: 20),
              _buildBlueButton(
                text: 'Submit Guess',
                onPressed: _checkGuess,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CorrectGuessScreen extends StatelessWidget {
  const CorrectGuessScreen({super.key});

  Widget _buildBlueButton(
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Center(child: Text('Correct!')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congratulations!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'You guessed the correct number!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildBlueButton(
              text: 'Play Again',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WrongGuessScreen extends StatelessWidget {
  final int guess;
  const WrongGuessScreen({super.key, required this.guess});

  Widget _buildBlueButton(
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: const Center(child: Text('Wrong Guess')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              '$guess was not the correct number.',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildBlueButton(
              text: 'Try Again',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverScreen extends StatelessWidget {
  final List<int> guesses;
  const GameOverScreen({super.key, required this.guesses});

  Widget _buildBlueButton(
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: const Center(child: Text('Game Over')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'You used all your attempts!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Your guesses: ${guesses.join(', ')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            _buildBlueButton(
              text: 'Play Again',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
