import 'package:flutter/material.dart';
import 'package:Robopomodoro/main/di/main_module.dart';
import 'dart:math';

class MinuteDigit extends StatelessWidget {
  final DateTime currentTime;
  final double radius;
  MinuteDigit({Key key, this.currentTime, this.radius})
      : assert(currentTime != null),
        super(key: key);

  Widget build(BuildContext context) {
    return new CustomPaint(
        size: new Size(radius * 2, radius * 2),
        painter: new MinuteDigitPainter(currentTime));
  }
}

class MinuteDigitPainter extends CustomPainter {
  final DateTime currentTime;
  MinuteDigitPainter(this.currentTime);

  bool shouldRepaint(MinuteDigitPainter oldPainter) {
    return currentTime.minute != oldPainter.currentTime.minute ||
        currentTime.second != oldPainter.currentTime.second ||
        currentTime.millisecond != oldPainter.currentTime.millisecond;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var timestamp = calculateTimestamp();
    var p1 = new Offset(size.width / 2, size.height / 2);
    var p2 = calculateDigitRotation(timestamp, size);
    canvas.drawLine(p1, p2, minuteDigitPaint);
  }

  int calculateTimestamp() {
    return currentTime.minute * 60 + currentTime.second;
  }

  Offset calculateDigitRotation(int timestamp, Size size) {
    return new Offset(
        size.width / 2 +
            cos(DEFAULT_ANGLE_CORRECTION + timestamp / 60 / 30 * pi) *
                size.width /
                2,
        size.height / 2 +
            sin(DEFAULT_ANGLE_CORRECTION + timestamp / 60 / 30 * pi) *
                size.height /
                2);
  }
}
