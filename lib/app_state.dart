import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'main/main_widget.dart';
import 'onboarding/onboarding_module.dart';

class AppState extends State<RobopomodoroApp> {

    AppState(this._preferences);

    Future<SharedPreferences> _preferences;

    var _onboardingCompleted = false;

    Future<Null> _persistOnboardingCompleted() async {
      SharedPreferences prefs = await _preferences;
      prefs.setBool('onboadring_completed', true);

    }

    bool get onboardingCompleted  => _onboardingCompleted;

    Future<Null> _readOnboardingCompleted() async {
      SharedPreferences prefs = await _preferences;
      setState((){
        var onboardingCompleted = prefs.getBool('onboadring_completed');
        _onboardingCompleted = onboardingCompleted == null ? false : onboardingCompleted;
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
      home: _onboardingCompleted ? new MyHomePage() : onboardingWidget((){onOnboardingCompleted();}),
      routes: <String,WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}
