import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../lib/app/app_state.dart';
import '../lib/app/app_repository.dart';

class MockAppRepository extends Mock implements AppRepository {
  OnReadOnboardingCompleted onReadHandler;
  OnWriteOnboardingCompleted onWriteHandler;
}

void main() {
  var mockAppRepository = new MockAppRepository();
  test(
      'GIVEN AppState WHEN created THEN onboardingCompleted is false',
      () {
    AppState systemUnderTest = new AppState(mockAppRepository);
    var answer = systemUnderTest.onboardingCompleted;
    expect(answer, false);
  });

  test(
      'GIVEN AppState WHEN initState is invoked THEN callbacks are registered',
      () {
    AppState systemUnderTest = new AppState(mockAppRepository);
    systemUnderTest.initState();
    verify(mockAppRepository.readOnboardingCompleted());
    expect(mockAppRepository.onReadHandler,isNotNull);
    expect(mockAppRepository.onWriteHandler,isNotNull);
  });

  test(
    'GIVEN AppState WHEN onOnboardingCompleted() THEN state is updated and persisted in shared preferences',
  (){
    AppState systemUnderTest = new AppState(mockAppRepository);
    systemUnderTest.onOnboardingCompleted();
    verify(mockAppRepository.writeOnboardingCompleted());
    expect(systemUnderTest.onboardingCompleted,true);
  });
}
