import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/alarm_screen.dart';
import 'screens/challenge_screen.dart';

void main() {
  runApp(WakeUpApp());
}

class WakeUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WakeUp+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => HomeScreen(),
        '/alarm': (context) => AlarmScreen(),
        '/challenge': (context) => ChallengeScreen(),
      },
    );
  }
}
