import 'dart:async';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../lib/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/app_repository.dart';

class MockSharedPreferencesFuture extends Mock
    implements Future<SharedPreferences> {}

class MockAppRepository extends Mock implements AppRepository {}

void main() {
  var mockAppRepository = new MockAppRepository();

  test(
      'GIVEN app starts for the first time WHEN AppState is created THEN onboadring is enabled',
      () {
    AppState systemUnderTest = new AppState(mockAppRepository);
    var answer = systemUnderTest.onboardingCompleted;
    expect(answer, false);
  });

  test(
      'GIVEN app starts WHEN onboarding was completed THEN onboarding is disabled',
      () {
    when(mockAppRepository.readOnboardingCompleted()).thenReturn(true);
    AppState systemUnderTest = new AppState(mockAppRepository);
    systemUnderTest.initState();
    verify(mockAppRepository.readOnboardingCompleted());
  });
}
