import 'package:flutter/material.dart';
import 'app_state.dart';
import '../di/di.dart';

class RobopomodoroApp extends StatefulWidget {

  final Factory<AppState> _appStateFactory;

  RobopomodoroApp(this._appStateFactory);

  @override
  AppState createState() => _appStateFactory();

}
