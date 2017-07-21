import 'package:test/test.dart';
import 'package:flutter/material.dart';
import '../../../lib/main/digit/minute_digit.dart';
import 'dart:math';

main() {

  int YEAR = 1;
  int MONTH = 1;
  int DAY = 1;

  test(
    "GIVEN curren time 10:41:16 WHEN calculateTimestamp is called THEN it should return timestamp equal to 41 x 60 + 16",
    (){
      DateTime dateTime = new DateTime(
        YEAR,
        MONTH,
        DAY,
        10,
        41,
        16,
        0,
        0
        );

        var minuteDigitPainter = new MinuteDigitPainter(dateTime);

        expect(minuteDigitPainter.calculateTimestamp(),41*60+16);
    });

  test("GIVEN timestamp equal 15 * 60 WHEN calculateDigitRotation is called THEN it returns offset of horizontal size.width / 2",
  (){
      DateTime dateTime = new DateTime(
        YEAR,
        MONTH,
        DAY,
        10,
        41,
        16,
        0,
        0
        );

      var mockedTimestamp = 15*60;
      var mockSize = new Size(10.0,10.0);
      var minuteDigitPainter = new MinuteDigitPainter(dateTime);

      var result = minuteDigitPainter.calculateDigitRotation(mockedTimestamp, mockSize);
      expect(result.dx,5.0);
      expect(result.dy,0.0);
  });

  test("GIVEN timestamp equal 30 * 60 WHEN calculateDigitRotation is called THEN it returns offset of vertical size.height / 2",
  (){
      DateTime dateTime = new DateTime(
        YEAR,
        MONTH,
        DAY,
        10,
        41,
        16,
        0,
        0
        );

      var mockedTimestamp = 30*60;
      var mockSize = new Size(10.0,10.0);
      var minuteDigitPainter = new MinuteDigitPainter(dateTime);

      var result = minuteDigitPainter.calculateDigitRotation(mockedTimestamp, mockSize);
      expect(result.dx.truncate(),0);
      expect(result.dy,5.0);
  });

  test("GIVEN timestamp equal 45 * 60 WHEN calculateDigitRotation is called THEN it returns offset of vertical - size.width / 2",
  (){
      DateTime dateTime = new DateTime(
        YEAR,
        MONTH,
        DAY,
        10,
        41,
        16,
        0,
        0
        );

      var mockedTimestamp = 45*60;
      var mockSize = new Size(10.0,10.0);
      var minuteDigitPainter = new MinuteDigitPainter(dateTime);

      var result = minuteDigitPainter.calculateDigitRotation(mockedTimestamp, mockSize);
      expect(result.dx,-5.0);
      expect(result.dy.truncate(),0);
  });

  test("GIVEN timestamp equal 60 * 60 WHEN calculateDigitRotation is called THEN it returns offset vertical of - size.height/2",
  (){
      DateTime dateTime = new DateTime(
        YEAR,
        MONTH,
        DAY,
        10,
        41,
        16,
        0,
        0
        );

      var mockedTimestamp = 60*60;
      var mockSize = new Size(10.0,10.0);
      var minuteDigitPainter = new MinuteDigitPainter(dateTime);

      var result = minuteDigitPainter.calculateDigitRotation(mockedTimestamp, mockSize);
      expect(result.dx.truncate(),0);
      expect(result.dy,-5.0);
  });
}