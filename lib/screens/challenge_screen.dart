import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';

class TriviaQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  TriviaQuestion({required this.question, required this.options, required this.correctAnswer});
}

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final Random random = Random();
  late int challengeType; 
  
  // --- Math State ---
  late int num1, num2, correctMathAnswer;
  late String mathOperator;
  TextEditingController answerController = TextEditingController();

  // --- Trivia State ---
  late TriviaQuestion currentTrivia;
  late List<String> shuffledOptions;
  List<int> unaskedTriviaIndices = [];

  final List<TriviaQuestion> triviaBank = [
    TriviaQuestion(
      question: "In digital electronics, what is the fundamental building block of a VLSI integrated circuit?",
      options: ["Transistor", "Resistor", "Capacitor", "Inductor", "Diode", "Transformer"],
      correctAnswer: "Transistor",
    ),
    TriviaQuestion(
      question: "Which of these is a staple source of 'good fats'?",
      options: ["Avocado", "White Bread", "Pasta", "Lean Chicken", "Apple", "Skim Milk"],
      correctAnswer: "Avocado",
    ),
    TriviaQuestion(
      question: "What is the capital of Japan?",
      options: ["Tokyo", "Seoul", "Beijing", "Bangkok", "Hanoi", "Taipei"],
      correctAnswer: "Tokyo",
    ),
    TriviaQuestion(
      question: "What is the hardest natural substance on Earth?",
      options: ["Diamond", "Graphene", "Quartz", "Topaz", "Corundum", "Titanium"],
      correctAnswer: "Diamond",
    )
  ];

  // --- Color Puzzle State (Stroop Test) ---
  final List<Color> colorPalette = [
    Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal
  ];
  final List<String> colorNames = ["RED", "BLUE", "GREEN", "ORANGE", "PURPLE", "TEAL"];
  
  late String displayedWord;
  late Color displayedPaintColor;
  late Color correctColorAnswer;

  @override
  void initState() {
    super.initState();
    unaskedTriviaIndices = List.generate(triviaBank.length, (index) => index);
    _generateNewChallenge();
  }

  void _generateNewChallenge() {
    challengeType = random.nextInt(3); 

    if (challengeType == 0) {
      _generateMathQuestion();
    } else if (challengeType == 1) {
      _generateTriviaQuestion();
    } else {
      _generateColorQuestion();
    }
  }

  void _generateMathQuestion() {
    int opType = random.nextInt(3);
    if (opType == 0) {
      num1 = random.nextInt(80) + 20; 
      num2 = random.nextInt(80) + 20;
      mathOperator = "+";
      correctMathAnswer = num1 + num2;
    } else if (opType == 1) {
      num1 = random.nextInt(80) + 40; 
      num2 = random.nextInt(num1 - 10) + 1;
      mathOperator = "-";
      correctMathAnswer = num1 - num2;
    } else {
      num1 = random.nextInt(12) + 3; 
      num2 = random.nextInt(10) + 3;
      mathOperator = "×";
      correctMathAnswer = num1 * num2;
    }
    answerController.clear();
  }

  void _generateTriviaQuestion() {
    if (unaskedTriviaIndices.isEmpty) {
      unaskedTriviaIndices = List.generate(triviaBank.length, (index) => index);
    }
    int randomIndexInPool = random.nextInt(unaskedTriviaIndices.length);
    int actualIndex = unaskedTriviaIndices[randomIndexInPool];
    unaskedTriviaIndices.removeAt(randomIndexInPool);

    currentTrivia = triviaBank[actualIndex];
    shuffledOptions = List.from(currentTrivia.options)..shuffle();
  }

  void _generateColorQuestion() {
    int wordIndex = random.nextInt(colorNames.length);
    displayedWord = colorNames[wordIndex];

    int colorIndex;
    do {
      colorIndex = random.nextInt(colorPalette.length);
    } while (colorIndex == wordIndex); 

    displayedPaintColor = colorPalette[colorIndex];
    correctColorAnswer = displayedPaintColor; 
  }

  void _stopAlarmAndGoHome() {
    FlutterRingtonePlayer().stop();
    Vibration.cancel(); 
    FocusScope.of(context).unfocus();
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void _handleWrongAnswer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Wrong! Generating new challenge..."), 
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ),
    );
    setState(() {
      _generateNewChallenge(); 
    });
  }

  Widget _buildMathChallenge() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calculate, size: 80, color: Colors.blueAccent),
        SizedBox(height: 20),
        Text("$num1 $mathOperator $num2 = ?", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        SizedBox(height: 30),
        TextField(
          controller: answerController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: "Enter answer",
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 60),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if ((int.tryParse(answerController.text) ?? -999) == correctMathAnswer) {
              _stopAlarmAndGoHome();
            } else {
              _handleWrongAnswer();
            }
          },
          child: Text("Submit", style: TextStyle(fontSize: 22)),
        )
      ],
    );
  }

  Widget _buildTriviaChallenge() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.psychology, size: 60, color: Colors.deepPurple),
        SizedBox(height: 20),
        Text(currentTrivia.question, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 30),
        ...shuffledOptions.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 55),
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
            ),
            onPressed: () {
              if (option == currentTrivia.correctAnswer) _stopAlarmAndGoHome();
              else _handleWrongAnswer();
            },
            child: Text(option, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildColorChallenge() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.palette, size: 60, color: Colors.orange),
        SizedBox(height: 20),
        Text("Tap the COLOR of the text", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text("(Ignore what the word says!)", style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 40),
        Text(
          displayedWord,
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: displayedPaintColor, letterSpacing: 5),
        ),
        SizedBox(height: 50),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: colorPalette.map((color) => InkWell(
            onTap: () {
              if (color == correctColorAnswer) _stopAlarmAndGoHome();
              else _handleWrongAnswer();
            },
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, 
      child: Scaffold(
        appBar: AppBar(title: Text("WakeUp Challenge"), centerTitle: true, automaticallyImplyLeading: false),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: challengeType == 0 
                ? _buildMathChallenge() 
                : challengeType == 1 
                    ? _buildTriviaChallenge() 
                    : _buildColorChallenge(),
          ),
        ),
      ),
    );
  }
}
