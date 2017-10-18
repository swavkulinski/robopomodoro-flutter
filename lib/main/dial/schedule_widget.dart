import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'dart:math';

class ScheduleWidget extends StatelessWidget {

  final PillPainter painter;
  final Size size;

  const ScheduleWidget({
    @required this.painter,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: painter,
      size: size,
    );    
  }
}

class PillPainter extends CustomPainter {

  final Paint pillPaint;

  const PillPainter({@required this.pillPaint});
  
  @override
  void paint(Canvas canvas, Size size) {
      canvas.drawPath(_createPillPath(size), pillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Path _createPillPath(Size size) {
      double radius = size.height;
      Path path = new Path();
      path.moveTo(radius, size.height);
      path.arcTo(new Rect.fromLTRB(0.0, 0.0, radius, size.height), PI/2, PI, true);
      path.lineTo(size.width - radius, 0.0);
      path.arcTo(new Rect.fromLTRB(size.width - radius, 0.0, size.width, size.height),-PI/2,PI,false);
      path.close();
      return path;
  }
}