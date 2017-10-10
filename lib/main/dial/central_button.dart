import 'package:flutter/material.dart';
import 'central_button_painter.dart';
import '../di/main_module.dart';

class ToggleButton extends StatelessWidget {
  final VoidCallback onTapListener;
  final double radius;
  final bool paused;
  final bool noSession;
  final String primaryStateText;
  final String secondaryStateText;

  ToggleButton({
    Key key,
    this.onTapListener,
    this.radius,
    this.paused,
    this.noSession,
    this.primaryStateText,
    this.secondaryStateText,
  }):
  assert(radius > 0.0),
  assert(primaryStateText != null),
  assert(secondaryStateText != null),
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
      return primaryStateText;
    }
    return secondaryStateText;
  }
}
