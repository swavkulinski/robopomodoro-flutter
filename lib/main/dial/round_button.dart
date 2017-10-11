import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Widget child;
  final Size size;
  final Paint foregroundPaint;
  final Paint shadowPaint;

  const RoundButton({
    Key key,
    this.child,
    this.size,
    this.foregroundPaint,
    this.shadowPaint,
  })
      : assert(size != null),
        assert(foregroundPaint != null),
        assert(shadowPaint != null),
        super(key: key);

  Widget build(BuildContext context) {
    return new Stack(
      alignment: FractionalOffsetDirectional.center,
      children: <Widget>[
        new CustomPaint(
          key: key,
          size: size,
          painter: _painter(foregroundPaint,shadowPaint),
        ),
        child,
      ],
    );
  }
}

_RoundButtonPainter _painter(foregroundPaint,shadowPaint) => new _RoundButtonPainter(
        bodyPaint: foregroundPaint,
        shadowPaint: shadowPaint,
      );

class _RoundButtonPainter extends CustomPainter {
  Paint bodyPaint;
  Paint shadowPaint;

  _RoundButtonPainter({this.bodyPaint, this.shadowPaint});

  @override
  bool shouldRepaint(_RoundButtonPainter old) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rectangle = new Rect.fromCircle(
        center: new Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    var path = new Path();
    path.addOval(rectangle);
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, bodyPaint);
  }
}
