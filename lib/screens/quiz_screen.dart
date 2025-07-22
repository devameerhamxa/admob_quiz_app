// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/custom_button.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isQuizCompleted) {
            // Show interstitial ad before moving to result screen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AdProvider>().showInterstitialAd();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ResultScreen()),
              );
            });
            return const Center(child: CircularProgressIndicator());
          }

          final question = quizProvider.currentQuestion;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value:
                      (quizProvider.currentQuestionIndex + 1) /
                      quizProvider.totalQuestions,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Question ${quizProvider.currentQuestionIndex + 1} of ${quizProvider.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...question.options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CustomButton(
                      text: option,
                      onPressed: () {
                        quizProvider.answerQuestion(index);
                      },
                      backgroundColor: Colors.blue[100],
                      textColor: Colors.blue[800],
                    ),
                  );
                }).toList(),
                const Spacer(),
                Text(
                  'Current Score: ${quizProvider.score}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
