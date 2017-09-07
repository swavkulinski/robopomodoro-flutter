import 'package:flutter/material.dart';
import 'central_button_painter.dart';
import '../di/main_module.dart';

class CentralButton extends StatelessWidget {
  final VoidCallback onTapListener;
  final double radius;
  final bool paused;
  final bool noSession;

  CentralButton({
    Key key,
    this.onTapListener,
    this.radius,
    this.paused,
    this.noSession,
  }):
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
                    label: _label(),
                ),
            ),
        );
  }

  String _label() {
    if(noSession) {
      return "";
    }
    if(paused) {
      return "Start";
    }
    return "Reset";
  }
}
