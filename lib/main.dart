import 'package:flutter/material.dart';
import 'onboarding/onboarding_widget.dart';

void main() {
  runApp(new RobopomodoroApp());
}

class RobopomodoroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new OnboardingWidget(title: 'Robopomodoro'),
    );
  }
}
