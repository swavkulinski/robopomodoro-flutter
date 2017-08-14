import 'package:flutter/material.dart';
import 'session_digit_painter.dart';
import '../../app/models.dart';
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
      return new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter: new SessionDigitPainter(
              baseRotation: calculateStartRotation(startTime),
              sections: <Section>[
                new Section(
                  length: 1000 * 60 * 25,
                  foregroundPaint: workSectionCompletePaint,
                  backgroundPaint: workSectionIncompletePaint,
                  sessionType: SectionType.WORK,
                ),
                new Section(
                  length: 1000 * 60 * 5,
                  foregroundPaint: breakSectionCompletePaint,
                  backgroundPaint: breakSectionIncompletePaint,
                  sessionType: SectionType.BREAK,
                )
              ],
              dialOuterRadius: 135.0,
              dialInnerRadius: 50.0,
              elapsedLength: elapsedTime,
            ),
          );
  }

  int calculateStartRotation(DateTime startTime) {
    return (startTime.minute - 15) * 1000 * 60 + (startTime.second * 1000);
  }
}
