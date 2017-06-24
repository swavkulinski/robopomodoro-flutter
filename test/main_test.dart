import 'dart:async';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../lib/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MockSharedPreferences extends Mock implements Future<SharedPreferences> {}
void main() {

  var mockSharedPrefences = new MockSharedPreferences();
  /*var injector = new ModuleInjector(<Module>[
    new Module()
      ..bind(SharedPreferences,toValue: mockSharedPrefences)
      ..bind(AppState)
  ]);*/


  AppState systemUnderTest =  new AppState(mockSharedPrefences);
  test('GIVEN app starts for the first time WHEN AppState is created THEN onboadring is enabled', () {

    var answer = systemUnderTest.onboardingCompleted;
    expect(answer, false);
  });

  test('GIVEN app starts WHEN onboarding was completed THEN onboarding is disabled', () {
    var appState = new AppState(mockSharedPrefences);
    appState.onOnboardingCompleted();
    var answer = systemUnderTest.onboardingCompleted;
    expect(answer, true);
  });

}
