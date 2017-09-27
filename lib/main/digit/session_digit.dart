import 'package:flutter/material.dart';
import 'session_digit_painter.dart';
import 'models.dart';
import 'path_builder.dart';

class SessionDigit extends StatelessWidget {

  final double radius;
  final int elapsedTime;
  final DateTime startTime;
  final SessionWidgetModel sessionWidgetModel;

  SessionDigit({
    Key key,
    this.radius,
    this.elapsedTime,
    this.startTime,
    this.sessionWidgetModel,
  }):super(key:key);


  Widget build(BuildContext context) {
           return new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter: new SessionDigitPainter(sessionWidgetModel,new PathBuilder(sessionWidgetModel.config, sessionWidgetModel)),
            //painter: new DummySessionDigitPainter(),
            );
  }
  
}
