import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';
import 'main.dart';

var sharedPreferences = SharedPreferences.getInstance();
var appStateFactory = () => new AppState(sharedPreferences);
var robopomodoroApp = new RobopomodoroApp(appStateFactory);
