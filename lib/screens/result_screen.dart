// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/custom_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const BannerAdWidget(),
          Expanded(
            child: Consumer2<QuizProvider, AdProvider>(
              builder: (context, quizProvider, adProvider, child) {
                final score = quizProvider.score;
                final totalQuestions = quizProvider.totalQuestions;
                final percentage = (score / totalQuestions * 100).round();
                final bonusPoints = adProvider.adState.rewardedAdPoints;

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        percentage >= 70
                            ? Icons.emoji_events
                            : Icons.sentiment_satisfied,
                        size: 100,
                        color: percentage >= 70 ? Colors.amber : Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        percentage >= 70 ? 'Excellent!' : 'Good Job!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Your Score',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$score / $totalQuestions',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              if (bonusPoints > 0) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Bonus Points: $bonusPoints',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            text: 'Try Again',
                            onPressed: () {
                              quizProvider.resetQuiz();
                              Navigator.pop(context);
                            },
                          ),
                          CustomButton(
                            text: 'Home',
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            backgroundColor: Colors.grey[600],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
