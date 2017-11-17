import 'package:shared_preferences/shared_preferences.dart';
import 'package:Robopomodoro/app/app_state.dart';
import 'package:Robopomodoro/app/app_repository.dart';
import 'package:Robopomodoro/app/app_widget.dart';


var sharedPreferences = SharedPreferences.getInstance();
var appRepository = new AppRepository(sharedPreferences);
var appStateFactory = () => new AppState(appRepository);
var robopomodoroApp = new RobopomodoroApp(appStateFactory);
