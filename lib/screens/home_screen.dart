import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay? selectedTime;
  String statusText = "No alarm set";

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        statusText = "Alarm set for ${picked.format(context)}";
      });

      final now = DateTime.now();
      var alarmTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      
      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(Duration(days: 1));
      }

      final delay = alarmTime.difference(now);

      Timer(delay, () {
        Navigator.pushNamed(context, '/alarm');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WakeUp+"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alarm, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text(
              statusText,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.timer),
              label: Text("Set Alarm Time", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () => _selectTime(context),
            ),
          ],
        ),
      ),
    );
  }
}
