import 'package:flutter/material.dart';
import "package:di/di.dart";
import 'onboarding/onboarding_module.dart';
import 'app_module.dart';
import 'app_state.dart';

void main() {
  runApp(new RobopomodoroApp());
}


var injector = new ModuleInjector(<Module>[appModule]);

class RobopomodoroApp extends StatefulWidget {

  RobopomodoroApp();

  @override
  AppState createState() => injector.get(AppState);

}
