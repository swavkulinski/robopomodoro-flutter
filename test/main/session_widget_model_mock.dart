import 'package:Robopomodoro/app/models.dart';
import 'package:Robopomodoro/main/models.dart';
import 'package:flutter/material.dart';

Paint mockForegroundPaint = new Paint();
Paint mockBackgroundPaint = new Paint();

const double OUTER_RADIUS = 100.0;
const double INNER_RADIUS = 50.0;

Section mockSectionOne = new Section(
  length: 1000 * 60 * 25,
  sessionType: SectionType.WORK,
  foregroundPaint: mockForegroundPaint,
  backgroundPaint: mockBackgroundPaint,
);

Section mockSectionTwo = new Section(
  length: 1000 * 60 * 15,
  sessionType: SectionType.WORK,
  foregroundPaint: mockForegroundPaint,
  backgroundPaint: mockBackgroundPaint,
);

Section mockSectionThree = new Section(
  length: 1000 * 60 * 5,
  sessionType: SectionType.WORK,
  foregroundPaint: mockForegroundPaint,
  backgroundPaint: mockBackgroundPaint,
);

SessionDigitConfig mockConfig = new SessionDigitConfig(
  dialInnerRadius: INNER_RADIUS,
  dialOuterRadius: OUTER_RADIUS,
);

DateTime mockTime = new DateTime(2017,5,10,12,0,0);

Session mockSession = new Session()..sections = [mockSectionOne,mockSectionTwo,mockSectionThree]
    ..name = "mock";
