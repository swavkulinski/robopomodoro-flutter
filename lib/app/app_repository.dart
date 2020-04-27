import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AppRepository {
  Future<SharedPreferences> _sharedPreferencesFuture;
  OnReadOnboardingCompleted onReadHandler;
  OnWriteOnboardingCompleted onWriteHandler;

  AppRepository(this._sharedPreferencesFuture);

  readOnboardingCompleted() async {
    SharedPreferences prefs = await _sharedPreferencesFuture;
    var onboardingCompleted = prefs.getBool('onboadring_completed');
    onReadHandler(onboardingCompleted == null ? false : onboardingCompleted);
  }

  writeOnboardingCompleted() async {
    SharedPreferences prefs = await _sharedPreferencesFuture;
    prefs.setBool('onboadring_completed', true);
    onWriteHandler();
  }
}

typedef OnReadOnboardingCompleted (bool isOnboardingCompleted);

typedef OnWriteOnboardingCompleted();
