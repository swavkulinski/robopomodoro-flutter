import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../lib/main/session_digit.dart';
import '../../lib/app/models.dart';
import 'package:flutter/material.dart';

void main(){

  const double OUTER_RADIUS = 100.0;
  const double INNER_RADIUS = 50.0;
  Color mockSectionOneColor = new Color(0xFFFF0000);
  Color mockSectionTwoColor = new Color(0xFF00FF00);
  Color mockSectionThreeColor = new Color(0xFFFF00FF);

  Section mockSectionOne = new Section(
            length: 1000 * 60 * 25,
            sessionType: SectionType.WORK,
            color: mockSectionOneColor,
          );


Section mockSectionTwo = new Section(
            length: 1000 * 60 * 15,
            sessionType: SectionType.WORK,
            color: mockSectionTwoColor,
          );


Section mockSectionThree = new Section(
            length: 1000 * 60 * 5,
            sessionType: SectionType.WORK,
            color: mockSectionThreeColor,
          );


  SessionPainter sessionPainterUnderTest = new SessionPainter(
        dialInnerRadius:INNER_RADIUS,
        dialOuterRadius:OUTER_RADIUS,
        sections: <Section> [
          mockSectionOne,
          mockSectionTwo,
          mockSectionThree,
        ]
    );

  test(
  "GIVEN array of sections WHEN total length is calculated THEN sum of lengths in milliseconds is returned",
  (){

    expect(sessionPainterUnderTest.calculateTotalLengthForSection(0), 0);
    expect(sessionPainterUnderTest.calculateTotalLengthForSection(1), 25 * 60 * 1000);
    expect(sessionPainterUnderTest.calculateTotalLengthForSection(2), 40 * 60 * 1000);
  }
  );

  test(
    "GIVEN a section WHEN deduction is calculated THEN returned value is a total length of all sections divided by the difference in outer and inner radius",
    (){
      expect(sessionPainterUnderTest.calculateRadiusDeduction(), 45 * 60 * 1000 / 50.0);
    }
  );

  test(
    "GIVEN a section WHEN number of stripes is calculated THEN returned value is high enough for stripes to be smaller than STRIPES_FACTOR",
    (){
      expect(sessionPainterUnderTest.calculateNumberOfStripes(mockSectionOne),85);
    }
  );

  test(
    "GIVEN a section WHEN stripe length is calculated THEN returned valus is equal to total length of the section divided by calculated number of stripes",
    (){
      expect(sessionPainterUnderTest.calculateStripeWidth(mockSectionOne),mockSectionOne.length / 85);
    }
  );
}
