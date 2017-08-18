import 'package:flutter/material.dart';
import 'session_digit_painter.dart';
import '../../app/models.dart';
import 'models.dart';
import 'path_builder.dart';
import '../di/main_module.dart';

class SessionDigit extends StatelessWidget {

  final double radius;
  final int elapsedTime;
  final DateTime startTime;

  SessionDigit({
    Key key,
    this.radius,
    this.elapsedTime,
    this.startTime,
  }):super(key:key);


  Widget build(BuildContext context) {
      var sessionDigitConfig = new SessionDigitConfig(dialOuterRadius : 135.0,dialInnerRadius : 50.0);
      var sessionWidgetModel = new SessionWidgetModel()
              ..startTime = startTime
              ..sections = <Section>[
                new Section(
                  length: 1000 * 60 * 10,
                  foregroundPaint: workSectionCompletePaint,
                  backgroundPaint: workSectionIncompletePaint,
                  sessionType: SectionType.WORK,
                ),
                new Section(
                  length: 1000 * 60 * 10,
                  foregroundPaint: breakSectionCompletePaint,
                  backgroundPaint: breakSectionIncompletePaint,
                  sessionType: SectionType.BREAK,
                )
              ]

              ..elapsed = elapsedTime
              ..config = sessionDigitConfig;

      return new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter: new SessionDigitPainter(sessionWidgetModel,new PathBuilder(sessionDigitConfig, sessionWidgetModel)),
            );
  }

  
}
