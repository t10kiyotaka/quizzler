import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());
QuizBrain quizBrain = QuizBrain();

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
  List<Icon> scoreKeeper = [];

  void checkAnswer(bool userAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    var icon;
    if (userAnswer == correctAnswer) {
      print('User got right');
      icon = Icon(Icons.check, color: Colors.green);
    } else {
      print('User got wrong');
      icon = Icon(Icons.close, color: Colors.red);
    }
    setState(() {
      scoreKeeper.add(icon);
    });
    if (quizBrain.isLastQuestion()) {
      resetQuestion();
    } else {
      quizBrain.nextQuestion();
    }
  }

  resetQuestion() {
    var correctCnt = 0;
    scoreKeeper.forEach((element) {
      if (element.icon == Icons.check) {
        correctCnt++;
      }
    });

    String score = '$correctCnt / ${quizBrain.questionCount()}';
    _onBasicAlertPressed(context, '$score');
  }

  // The easiest way for creating RFlutter Alert
  _onBasicAlertPressed(context, String score) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Finished all Quizzes!",
      desc: "Your score is $score",
      buttons: [
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              quizBrain.initQuestion();
              scoreKeeper = [];
            });
            Navigator.pop(context);
          },
        )
      ],
//      alertAnimation: FadeAlertAnimation,
    ).show();
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
                quizBrain.getQuestionText(),
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
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
