import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final Widget child;
  final Paint foregroundPaint;
  final Paint shadowPaint;
  final EdgeInsets margins;

  const PillButton({
    Key key,
    this.child,
    this.foregroundPaint,
    this.shadowPaint,
    this.margins : const EdgeInsets.all(8.0),
  }):
        assert(foregroundPaint != null),
        assert(shadowPaint != null),
        super(key: key);

  Widget build(BuildContext context) {
    return
          new CustomPaint(
          key: key,
          painter: _painter(foregroundPaint,shadowPaint,margins),
          child:child,
        );
  }
}

_RoundButtonPainter _painter(foregroundPaint,shadowPaint, margins) => new _RoundButtonPainter(
        bodyPaint: foregroundPaint,
        shadowPaint: shadowPaint,
        margins: margins,
      );

class _RoundButtonPainter extends CustomPainter {
  Paint bodyPaint;
  Paint shadowPaint;
  EdgeInsets margins;

  _RoundButtonPainter({this.bodyPaint, this.shadowPaint, this.margins});

  @override
  bool shouldRepaint(_RoundButtonPainter old) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rectangle = new Rect.fromLTWH(-margins.left, -margins.top, size.width + margins.right + margins.left, size.height + margins.top + margins.bottom);
    var path = new Path();
    //path.addOval(rectangle);
    path.addRRect(new RRect.fromRectXY(rectangle, size.height/2, size.height/2));
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, bodyPaint);
  }
}
