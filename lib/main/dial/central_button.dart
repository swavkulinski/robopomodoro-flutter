import 'package:flutter/material.dart';
import 'central_button_painter.dart';
import '../di/main_module.dart';

class CentralButton extends StatelessWidget {
  final VoidCallback onTapListener;
  final double radius;
  final bool paused;

  CentralButton({
    Key key,
    this.onTapListener,
    this.radius,
    this.paused,
  }):
  assert(onTapListener != null),
  assert(radius > 0.0),
  super(key:key);


  Widget build(BuildContext context) {
    return new GestureDetector(
            onTap: onTapListener,
            child: new CustomPaint(
                size: new Size(radius * 2, radius * 2),
                painter: new CentralButtonPainter(
                    bodyPaint: platePaint(),
                    shadowPaint: defaultShadowPaint(),
                    label: paused ? "Start" : "Reset"
                ),
            ),
        );
  }
}
