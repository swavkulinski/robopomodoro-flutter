import 'dart:async';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../lib/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MockSharedPreferences extends Mock implements Future<SharedPreferences> {}
void main() {

  var mockSharedPrefences = new MockSharedPreferences();

  test('GIVEN app starts for the first time WHEN AppState is created THEN onboadring is enabled', () {

    var answer = new AppState(mockSharedPrefences).onboardingCompleted;
    expect(answer, false);
  });

  test('GIVEN app starts WHEN onboarding was completed THEN onboarding is disabled', () {
    var appState = new AppState(mockSharedPrefences);
    appState.onOnboardingCompleted();
    var answer = appState.onboardingCompleted;
    expect(answer, true);
  });
}
