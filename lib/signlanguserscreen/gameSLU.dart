import 'package:flutter/material.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final List<String>? optionImages; // For image-based options
  final int correctAnswerIndex;

  QuizQuestion(this.question, this.options, this.correctAnswerIndex,
      {this.optionImages});
}

class GameSL extends StatefulWidget {
  const GameSL({super.key});

  @override
  State<GameSL> createState() => _GameStateSL();
}

class _GameStateSL extends State<GameSL> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      'What is the sign for "Hello"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      0,
      optionImages: [
        'assets/Signs/hello.jpg',
        'assets/Signs/help.jpg'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Thank you"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      1,
      optionImages: [
        'assets/Signs/yes.jpg',
        'assets/Signs/thankyou.jpg'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Please"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      0,
      optionImages: [
        'assets/Signs/please.jpg',
        'assets/Signs/more.png'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Goodbye"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      0,
      optionImages: [
        'assets/Signs/goodbye.jpg',
        'assets/Signs/no.png'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Yes"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      1,
      optionImages: [
        'assets/Signs/no.png',
        'assets/Signs/yes.jpg'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "No"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      1,
      optionImages: [
        'assets/Signs/sorry.png',
        'assets/Signs/no.png'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Help"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      0,
      optionImages: [
        'assets/Signs/help.jpg',
        'assets/Signs/hello.jpg'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "More"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      1,
      optionImages: [
        'assets/Signs/no.png',
        'assets/Signs/more.png'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Sorry"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      0,
      optionImages: [
        'assets/Signs/sorry.png',
        'assets/Signs/thankyou.jpg'
      ], // Image paths
    ),
    QuizQuestion(
      'What is the sign for "Friend"?',
      ['Option 1', 'Option 2'], // Placeholder for image options
      1,
      optionImages: [
        'assets/Signs/please.jpg',
        'assets/Signs/friend.jpg'
      ], // Image paths
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
        title: const Text('Sign Language Quiz '),
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
                  (index) {
                    // Check if the current question has image options
                    if (questions[currentQuestionIndex].optionImages != null &&
                        questions[currentQuestionIndex]
                            .optionImages!
                            .isNotEmpty) {
                      // Display images as options
                      return GestureDetector(
                        onTap: () => _checkAnswer(index),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            questions[currentQuestionIndex]
                                .optionImages![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      // Display text as options for non-image questions
                      return SizedBox(
                        width: 150, // Set a fixed width for equal button sizes
                        height: 50, // Set a fixed height for equal button sizes
                        child: ElevatedButton(
                          onPressed: () => _checkAnswer(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hexStringToColor("2986cc"),
                            padding: const EdgeInsets.all(
                                0), // No additional padding
                          ),
                          child: Text(
                            questions[currentQuestionIndex].options[index],
                            style: const TextStyle(
                                color: Colors.black), // Text color
                          ),
                        ),
                      );
                    }
                  },
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
