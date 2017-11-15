import 'package:flutter/material.dart';
import '../../../app/models.dart';
import '../../di/main_module.dart';
import 'dart:math';

class SessionIcon extends StatelessWidget {
  final Session session;
  final Size size;
  final VoidCallback onClick;
  final Paint shadowPaint;

  SessionIcon({Key key,this.size, this.session, this.onClick, this.shadowPaint}):
  assert(size != null),
  assert(session != null),
  assert(shadowPaint != null),
  super(key:key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onClick,
      child: new CustomPaint(
        painter: new _IconPainter(session,shadowPaint),
        size: size,
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  final Session session;
  final Paint shadowPaint;

  const _IconPainter(this.session,this.shadowPaint):
  //assert(session != null),
  assert(shadowPaint != null);

  bool shouldRepaint(CustomPainter oldPainter) {
    return false;
  }

  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(0.0, 0.0);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, shadowPaint);
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
        -PI / 2, section.length * MILLIS_TO_ANGLE, true)
    ..lineTo(center.dx, center.dy)
    ..close();
}
