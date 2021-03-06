import 'package:flutter_test/flutter_test.dart';
import 'session_widget_model_mock.dart';
import 'package:Robopomodoro/main/models.dart';

void main() {


  SessionWidgetModel modelUnderTest = new SessionWidgetModel()
  ..config = mockConfig
  ..startTime = mockTime
  ..session = mockSession;
   test(
      "GIVEN array of sections WHEN total length is calculated THEN sum of lengths in milliseconds is returned",
      () {
    expect(modelUnderTest.totalLengthBefore(mockSectionOne), 0);
    expect(modelUnderTest.totalLengthBefore(mockSectionTwo),
        25 * 60 * 1000);
    expect(modelUnderTest.totalLengthBefore(mockSectionThree),
        40 * 60 * 1000);
  });

  test(
      "GIVEN a section WHEN deduction is calculated THEN returned value is a total length of all sections divided by the difference in outer and inner radius",
      () {
    expect(modelUnderTest.radiusDeduction(),
        50 / (45 * 60 * 1000));
  });

  // TODO find a way to test internal implementation
  
  /*test(
      "GIVEN a section WHEN number of stripes is calculated THEN returned value is high enough for stripes to be smaller than STRIPES_FACTOR",
      () {
    expect(
        sessionPainterUnderTest.stripeCount(mockSectionOne), 85);
  });

  test(
      "GIVEN a section WHEN stripe length is calculated THEN returned valus is equal to total length of the section divided by calculated number of stripes",
      () {
    expect(sessionPainterUnderTest._stripeWidth(mockSectionOne),
        mockSectionOne.length / 85);
  });*/

}