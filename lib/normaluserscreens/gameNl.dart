import 'package:flutter/material.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion(this.question, this.options, this.correctAnswerIndex);
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      'What is the sign for "Hello"?',
      ['A: Wave', 'B: Thumbs up', 'C: Point', 'D: Clap'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Thank you"?',
      ['A: Point at chin', 'B: Wave', 'C: Nod', 'D: Thumbs up'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Please"?',
      ['A: Rubbing chest', 'B: Thumbs down', 'C: Wave', 'D: Clap'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Goodbye"?',
      ['A: Wave', 'B: Thumbs up', 'C: Bow', 'D: Point'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Yes"?',
      ['A: Nod', 'B: Shake head', 'C: Clap', 'D: Point up'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "No"?',
      ['A: Shake head', 'B: Nod', 'C: Clap', 'D: Point'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Help"?',
      ['A: Raise hands', 'B: Clap', 'C: Point', 'D: Wave'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "More"?',
      ['A: Bring hands together', 'B: Wave', 'C: Clap', 'D: Thumbs up'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Sorry"?',
      ['A: Rubbing chest', 'B: Shake head', 'C: Clap', 'D: Thumbs down'],
      0,
    ),
    QuizQuestion(
      'What is the sign for "Friend"?',
      ['A: Two hands together', 'B: Wave', 'C: Thumbs up', 'D: Point'],
      0,
    ),
  ];

  int currentQuestionIndex = 0;
  int correctAnswersCount = 0; // Track correct answers
  String feedbackMessage = '';

  void _checkAnswer(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctAnswerIndex) {
      setState(() {
        feedbackMessage = 'Correct!';
        correctAnswersCount++; // Increment correct answer count
      });
    } else {
      setState(() {
        feedbackMessage = 'Incorrect! Try again.';
      });
    }

    // Move to the next question or show result if the quiz is over
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          feedbackMessage = '';
        } else {
          _showResult(); // Show result when quiz is over
        }
      });
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Over!'),
          content: Text(
              'You got $correctAnswersCount out of ${questions.length} correct!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuiz(); // Reset quiz when user acknowledges the result
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      correctAnswersCount = 0;
      feedbackMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Normal User Quiz On Signs'),
        backgroundColor: hexStringToColor("2986cc"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                questions[currentQuestionIndex].question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 130, 230),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16, // Space between options
                runSpacing: 16, // Space between rows of options
                alignment: WrapAlignment.center,
                children: List.generate(
                  questions[currentQuestionIndex].options.length,
                  (index) => SizedBox(
                    width: 150, // Set a fixed width for equal button sizes
                    height: 50, // Set a fixed height for equal button sizes
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hexStringToColor("2986cc"),
                        padding:
                            const EdgeInsets.all(0), // No additional padding
                      ),
                      child: Text(
                        questions[currentQuestionIndex].options[index],
                        style:
                            const TextStyle(color: Colors.black), // Text color
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                feedbackMessage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: hexStringToColor("ffffff"),
    );
  }
}
