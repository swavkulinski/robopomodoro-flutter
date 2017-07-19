import 'package:flutter/material.dart';
import 'main_module.dart';
import 'dart:math';

class MinuteDigit extends StatelessWidget {

  final int minute;
  final double radius;
  MinuteDigit({Key key,this.minute,this.radius}):super(key:key);

  Widget build(BuildContext contex) {
    return new CustomPaint(
      size: new Size(radius *2, radius *2),
      painter: new _MinuteDigitPainter(minute)
    );
  }
}

class _MinuteDigitPainter extends CustomPainter {
  final int minute;
  _MinuteDigitPainter(this.minute);
  bool shouldRepaint(_MinuteDigitPainter oldPainter) {
    return minute != oldPainter.minute;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var p1 = new Offset(0.0,0.0);
    var p2 = new Offset(cos(DEFAULT_ANGLE_CORRECTION + minute / 30 * PI) * size.width/2,sin(DEFAULT_ANGLE_CORRECTION + minute / 30 * PI) * size.width/2);
    canvas.drawLine(p1, p2, minuteDigitPaint);

  }
}
