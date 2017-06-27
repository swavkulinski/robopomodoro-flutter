import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';
import 'app_repository.dart';
import 'main.dart';


var sharedPreferences = SharedPreferences.getInstance();
var appRepository = new AppRepository(sharedPreferences);
var appStateFactory = () => new AppState(appRepository);
var robopomodoroApp = new RobopomodoroApp(appStateFactory);
