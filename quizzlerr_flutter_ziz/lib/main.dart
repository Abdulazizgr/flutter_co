import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quizbrain.dart';

QuizBrain quizBrain = QuizBrain();
void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<bool> scoreKeeper = [];

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuizAnswer();
    print(correctAnswer);
    setState(() {
      if (quizBrain.isFinished() == true) {
        int correctAnswersCount =
            scoreKeeper.where((element) => element == true).length;
        Alert(
          context: context,
          type: AlertType.error,
          title: "Finished",
          desc:
              "You\'ve reached the end of the quiz.\nAnd your result is $correctAnswersCount/13",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();

        quizBrain.reset();

        scoreKeeper = [];
      } else {
        if (correctAnswer == userPickedAnswer) {
          scoreKeeper.add(true);
        } else {
          scoreKeeper.add(false);
        }

        quizBrain.nextQuestionNUmber();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuizQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                // Sets the text color
                backgroundColor: Colors.green, // Sets the background color
              ),
              child: Text(
                'True',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
                // The user picked false.
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0), 
            child: TextButton(
              style: TextButton.styleFrom(
                // Sets the text color
                backgroundColor: Colors.red, // Sets the background color
              ),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
                // The user picked false.
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper.map((isCorrect) {
            return Expanded(
              child: Center(
                child: Icon(isCorrect ? Icons.check : Icons.close,
                    color: isCorrect ? Colors.green : Colors.red),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
