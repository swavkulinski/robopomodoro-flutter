import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding/onboarding_widget.dart';
import 'main/main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  runApp(new RobopomodoroApp(SharedPreferences.getInstance()));
}

class RobopomodoroApp extends StatefulWidget {

  Future<SharedPreferences> _preferences;

  RobopomodoroApp(this._preferences);

  @override
  AppState createState() => new AppState(_preferences);

}

class AppState extends State<RobopomodoroApp> {

    Future<SharedPreferences> _preferences;
    AppState(this._preferences);

    var _onboardingCompleted = false;

    Future<Null> _persistOnboardingCompleted() async {
      SharedPreferences prefs = await _preferences;
      prefs.setBool('onboadring_completed', true);

    }

    bool get onboardingCompleted  => _onboardingCompleted;

    Future<Null> _readOnboardingCompleted() async {
      SharedPreferences prefs = await _preferences;
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
