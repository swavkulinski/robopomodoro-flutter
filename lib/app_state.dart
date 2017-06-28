import 'package:flutter/material.dart';

import 'main.dart';
import 'app_repository.dart';
import 'main/main_widget.dart';
import 'onboarding/onboarding_module.dart';

class AppState extends State<RobopomodoroApp> {
  AppState(this._appRepository);

  AppRepository _appRepository;

  var _onboardingCompleted = false;

  bool get onboardingCompleted => _onboardingCompleted;

  @override
  initState() {
    _appRepository.onReadHandler = (isOnboardingCompleted) {
      setState(()=>_onboardingCompleted = isOnboardingCompleted);
    };
    _appRepository.onWriteHandler = (){
      print('onboarding marked as completed');
    };
    _appRepository.readOnboardingCompleted();    
    super.initState();
  }

  void onOnboardingCompleted() {
    _onboardingCompleted = true;
    _appRepository.writeOnboardingCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _onboardingCompleted
          ? new MyHomePage()
          : onboardingWidget(() {
              onOnboardingCompleted();
            }),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}
