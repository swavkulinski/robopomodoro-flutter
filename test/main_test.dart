import 'dart:async';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../lib/app_state.dart';
import '../lib/app_repository.dart';

class MockAppRepository extends Mock implements AppRepository {
  OnReadOnboardingCompleted onReadHandler;
  OnWriteOnboardingCompleted onWriteHandler;
}

void main() {
  var mockAppRepository = new MockAppRepository();
  var mockBoolFuture = new Future.sync(()=>true);
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
    AppState systemUnderTest = new AppState(mockAppRepository);
    systemUnderTest.initState();
    verify(mockAppRepository.readOnboardingCompleted());
    expect(mockAppRepository.onReadHandler,isNotNull);
    expect(mockAppRepository.onWriteHandler,isNotNull);
  });
}
