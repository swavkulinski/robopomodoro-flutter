import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import '../../di/main_module.dart';
import 'dart:ui';

class PlateWidget extends StatelessWidget {
  
  final Size size;

  PlateWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new _PlatePainter(),
      size: size,
      );
  }
}

class _PlatePainter extends CustomPainter {

  double tickSize = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    var height = size.height - 10;
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, height);
    path.lineTo(size.width/2 + tickSize, height);
    path.lineTo(size.width/2, height - tickSize);
    path.lineTo(size.width/2 - tickSize, height);
    path.lineTo(0.0, height);
    path.close();
    canvas.save();
    canvas.translate(0.0, 2.0);
    canvas.drawPath(path, PomodoroPaints.shadowPaint);
    canvas.restore();
    canvas.drawPath(path, defaultFillPaint(dialColor));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}