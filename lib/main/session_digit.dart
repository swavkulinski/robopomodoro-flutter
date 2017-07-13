import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';

import '../app/models.dart';

class SessionPainter extends CustomPainter {

  static const MILLIS_TO_ANGLE =  2 * PI / (60 * 60 * 1000);

  List<Paint> sectionPaints;

  double dialInnerRadius;
  double dialOuterRadius;

  List<Section> sections;

  SessionPainter({
    this.sections,
    this.dialInnerRadius,
    this.dialOuterRadius,
  }): assert (sections != null),
      assert (sections.length > 0),
      assert (dialInnerRadius < dialOuterRadius),
      assert (dialOuterRadius > 0.0);


  @override
  void paint(Canvas canvas, Size size) {
    _debug();
    for(Section section in sections) {
          _drawArcSection(section, canvas, size);
    }
  }

  @override
  bool shouldRepaint(SessionPainter oldDelegate) {
    return false;
  }

  void _drawArcSection(Section section, Canvas canvas, Size size) {
    Path path = new Path();
    var sweep = _calculateAngleForSection(section);

    path.arcTo(new Rect.fromCircle(center:new Offset(0.0, 0.0),radius: dialOuterRadius), 0.0, sweep,false);
    path.lineTo(cos(sweep) * dialInnerRadius,sin(sweep) *dialInnerRadius);
    path.arcTo(new Rect.fromCircle(center:new Offset(0.0, 0.0),radius: dialInnerRadius), sweep, -sweep,false);
    canvas.drawPath(path, _paintForColors(section.color));
    canvas.rotate(sweep);
  }

  double _calculateAngleForSection(Section section) {
    return section.length * MILLIS_TO_ANGLE;
  }

  Paint _paintForColors(Color primary) {
    Paint paint = new Paint();
    paint.color = primary;
    paint.strokeWidth = 2.0;
    paint.style = PaintingStyle.fill;
    return paint;
  }

  void _debug() {
    print("Drawing SessionPainter");
    print("dialOuterRadius $dialOuterRadius");
    print("dialInnerRadius $dialInnerRadius");
  }

}
