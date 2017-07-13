import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';

import '../app/models.dart';

class SessionPainter extends CustomPainter {

  static const MILLIS_TO_ANGLE =  2 * PI / (60 * 60 * 1000);

  List<Paint> sectionPaints;
  Matrix4 shadowTranslation;

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
          _drawSection(section, canvas, size);
    }
  }

  @override
  bool shouldRepaint(SessionPainter oldDelegate) {
    return false;
  }

  void _drawSection(Section section, Canvas canvas, Size size) {

    Path path = new Path();
    //path.moveTo(dialInnerRadius, 0.0);
    //path.lineTo(dialInnerRadius + dialOuterRadius, 0.0);
    var sweep = _calculateAngleForSection(section);
    var startAngle = PI/3;


    path.moveTo(dialOuterRadius + dialInnerRadius, dialOuterRadius);
    path.lineTo(dialOuterRadius * 2, dialOuterRadius);
    Rect outerRect = new Rect.fromLTWH(0.0,0.0, dialOuterRadius * 2, dialOuterRadius * 2);
    Rect innerRect = new Rect.fromLTWH(dialOuterRadius - dialInnerRadius, dialOuterRadius - dialInnerRadius, dialInnerRadius * 2, dialInnerRadius * 2);
    path.arcTo(outerRect, 0.0, sweep, false);
    path.lineTo(dialOuterRadius + cos(sweep) * dialInnerRadius, dialOuterRadius + sin(sweep) *dialInnerRadius);
    path.arcTo(innerRect, sweep, -sweep, false);

    var transform = new Matrix4.identity()
    //TOOD fix transform
    .multiplied(new Matrix4.translationValues(dialOuterRadius,dialOuterRadius, 0.0))
    .multiplied(new Matrix4.rotationZ(startAngle));

    canvas.transform(transform.storage);
    canvas.drawPath(path, _paintForColors(new Color(0xFFFF0000)));
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
