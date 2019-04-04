import 'package:flutter/material.dart';
import '../../app/models.dart';
import '../di/main_module.dart';
import 'dart:math' as math;

class SessionIcon extends StatelessWidget {
  final Session session;
  final Size size;
  final VoidCallback onClick;

  const SessionIcon({this.size, this.session, this.onClick});

  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onClick,
      child: new CustomPaint(
        painter: new _IconPainter(session),
        size: size,
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  final Session session;

  const _IconPainter(this.session);

  bool shouldRepaint(CustomPainter oldPainter) {
    return false;
  }

  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(0.0, 0.0);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, defaultShadowPaint());
    for (var section in session.sections) {
      canvas.drawPath(
          _sectionPath(section, size, center), section.foregroundPaint);
      canvas.rotate(section.length * MILLIS_TO_ANGLE);
    }
    var remaining = session.remaining(platePaint());
    canvas.drawPath(
        _sectionPath(remaining, size, center), remaining.foregroundPaint);
    canvas.restore();
  }

  Path _sectionPath(Section section, Size size, Offset center) => new Path()
    ..arcTo(new Rect.fromCircle(center: center, radius: size.width / 2),
        -math.pi / 2, section.length * MILLIS_TO_ANGLE, true)
    ..lineTo(center.dx, center.dy)
    ..close();
}
