import 'package:flutter/material.dart';
import '../di/main_module.dart';
import 'dart:math';

class MinuteDigit extends StatelessWidget {

  final DateTime currentTime;
  final double radius;
  MinuteDigit({Key key,this.currentTime,this.radius}):assert(currentTime != null),super(key:key);

  Widget build(BuildContext contex) {
    return new CustomPaint(
      size: new Size(radius *2, radius *2),
      painter: new _MinuteDigitPainter(currentTime)
    );
  }
}

class _MinuteDigitPainter extends CustomPainter {
  final DateTime currentTime;
  _MinuteDigitPainter(this.currentTime);
  bool shouldRepaint(_MinuteDigitPainter oldPainter) {
    return currentTime != oldPainter.currentTime;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var timestamp = currentTime.minute * 60 + currentTime.second;
    var p1 = new Offset(0.0,0.0);
    var p2 = new Offset(cos(DEFAULT_ANGLE_CORRECTION + timestamp / 60 / 30 * PI) * size.width/2,sin(DEFAULT_ANGLE_CORRECTION + timestamp / 60 / 30 * PI) * size.width/2);
    canvas.drawLine(p1, p2, minuteDigitPaint);
  }
}
