import 'package:flutter/material.dart';
import 'package:flutter_calculator/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final List<String> buttons = [
    'c',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userQuestion,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        userAnswer,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ])),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: GridView.builder(
                    itemCount: buttons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      switch (index) {
                        // C button
                        case 0:
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                userQuestion = '';
                                userAnswer = '';
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors.green,
                            textColor: Colors.white,
                          );

                        //Delete button
                        case 1:
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                if (userQuestion != '')
                                  userQuestion = userQuestion.substring(
                                      0, userQuestion.length - 1);
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors.red,
                            textColor: Colors.white,
                          );

                        //Equal button
                        case 19:
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                equalPressed();
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors.red,
                            textColor: Colors.white,
                          );
                      }
                      return MyButton(
                        buttonTapped: () {
                          setState(() {
                            if (isOperator(buttons[index]))
                            {
                              if (!isOperator(userQuestion[userQuestion.length - 1]))
                              {
                                if (userAnswer != '')
                                {
                                  userQuestion = userAnswer + buttons[index];
                                  userAnswer = '';
                                }
                                else
                                  userQuestion += buttons[index];
                              }
                            }
                            else if (userAnswer != '')
                              {
                                userAnswer = '';
                                userQuestion = '' + buttons[index];
                              }
                            else
                              userQuestion += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? Colors.deepPurple
                            : Colors.deepPurple[50],
                        textColor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.deepPurple,
                      );
                    }),
              ),
            ),
          ],
        ));
  }

  bool isOperator(String x) {
    if (x == '%' || x == '+' || x == '-' || x == '/' || x == 'x' || x == '=') {
      return true;
    } else
      return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }
}
