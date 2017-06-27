import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AppRepository {
  Future<SharedPreferences> _sharedPreferencesFuture;

  AppRepository(this._sharedPreferencesFuture);

  Future<bool> readOnboardingCompleted() async {
    SharedPreferences prefs = await _sharedPreferencesFuture;
    var onboardingCompleted = prefs.getBool('onboadring_completed');
    return onboardingCompleted == null ? false : onboardingCompleted;
  }

  Future<Null> writeOnboardingCompleted() async {
    SharedPreferences prefs = await _sharedPreferencesFuture;
    prefs.setBool('onboadring_completed', true);
  }
}
