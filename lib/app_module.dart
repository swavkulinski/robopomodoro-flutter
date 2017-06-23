import 'dart:async';
import "package:di/di.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';

var appModule = new Module()
  ..bind(SharedPreferences)
  ..bind(AppState);
