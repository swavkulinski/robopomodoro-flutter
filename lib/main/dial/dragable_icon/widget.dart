import 'package:flutter/material.dart';
import 'package:Robopomodoro/app/models.dart';
import 'package:Robopomodoro/main/di/main_module.dart';
import 'package:Robopomodoro/main/dial/session_icon/widget.dart';

class DragableIcon extends StatelessWidget {
  final Session session;
  final Size iconSize;

  const DragableIcon({
    key,
    this.session,
    this.iconSize,
  })
      : assert(iconSize != null),
        assert(session != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => new Draggable<Session>(
        data: session,
        onDragCompleted: () {
          print(session.length());
        },
        onDraggableCanceled: (velocity, offset) {
          print("cancelled");
        },
        feedback: new Padding(
          padding: Paddings.ALL_8,
          child: new SessionIcon(
            session: session,
            size: iconSize,
            shadowPaint: PomodoroPaints.highLevelShadowPaint,
          ),
        ),
        child: new Padding(
          padding: Paddings.ALL_8,
          child: new SessionIcon(
              session: session,
              size: iconSize,
              shadowPaint: PomodoroPaints.highLevelShadowPaint,
              onClick: () {}),
        ),
      );
}
