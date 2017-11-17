import 'package:flutter/material.dart';

import 'package:Robopomodoro/main/dial/pill_button.dart';
import 'package:Robopomodoro/main/di/main_module.dart';

class ClearScheduleButton extends StatelessWidget {

  final VoidCallback callback;

  const ClearScheduleButton({
    this.callback,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => new Padding(

        padding: new EdgeInsets.all(16.0),
        child: new GestureDetector(
          onTap: callback,
          child: new PillButton(
            foregroundPaint: PomodoroPaints.fillFullWhite,
            shadowPaint: PomodoroPaints.shadowPaint,
            child: new Container(
              constraints: const BoxConstraints.tightForFinite(height: 30.0),
              child: new Center(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Icon(Icons.delete),
                    new Text(
                      'CLEAR SCHEDULE',
                      style: defaultTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
