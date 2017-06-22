import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding/onboarding_widget.dart';
import 'main/main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new RobopomodoroApp());
}

class RobopomodoroApp extends StatefulWidget {


  @override
  AppState createState() => new AppState();


}

class AppState extends State<RobopomodoroApp> {

    var _onboardingCompleted = false;
    Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

    Future<Null> _persistOnboardingCompleted() async {
      SharedPreferences prefs = await _sharedPreferences;
      prefs.setBool('onboadring_completed', true);

    }

    Future<Null> _readOnboardingCompleted() async {
      SharedPreferences prefs = await _sharedPreferences;
      setState((){
        _onboardingCompleted = prefs.getBool('onboadring_completed');
      });
    }

    @override initState() {
      super.initState();
      _readOnboardingCompleted();
    }

    void onOnboardingCompleted() {
        _onboardingCompleted = true;
        _persistOnboardingCompleted();
    }

    @override
    Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _onboardingCompleted ? new MyHomePage() : new OnboardingWidget(callback:(){onOnboardingCompleted();}),
      routes: <String,WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}
