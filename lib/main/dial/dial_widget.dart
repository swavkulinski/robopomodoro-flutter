import 'package:flutter/material.dart';
import 'timer_painter.dart';
import '../di/main_module.dart';
import 'central_button.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';
import '../digit/models.dart';
import '../session_controller/session_controller.dart';

class DialWidget extends StatelessWidget {


  static const DIAL_CENTER = 200.0;
  static const DIAL_RADIUS = 140.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;
  final int elapsedTime;
  final VoidCallback onTapListener;
  final bool paused;
  final DateTime currentTime;
  final DateTime startTime;
  final SessionWidgetModel sessionWidgetModel;

  DialWidget({
    this.elapsedTime,
    this.onTapListener,
    this.paused,
    this.currentTime,
    this.startTime,
    this.sessionWidgetModel,
  }):assert(onTapListener != null);

  Widget build(BuildContext context) {

  var size = MediaQuery.of(context).size;
  var sessionState = paused ? '' : 'Session in progress';

  var children = new List<Widget>()
      ..add(new CustomPaint(
          size: size,
          painter: new TimerPainter(
              dialCenter: DIAL_CENTER,
              dialRadius: DIAL_RADIUS,
              dialColor: dialColor,
              platePaint: platePaint(),
              shadowPaint: defaultShadowPaint(),
              shadowTranslation: new Matrix4.translationValues(0.0, 2.0, 0.0),
          )
        )
      )
      ..add(new Transform(
            transform:
                new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
                child: new MinuteDigit(currentTime: currentTime, radius: DIAL_RADIUS - 10.0),
          )
      )
      ..add(new Transform(
          transform: new Matrix4.translationValues(
              size.width / 2 - radius, DIAL_CENTER - radius, 0.0),
          child: new CentralButton(onTapListener: _getCentralButtonOnTapListener(),radius: radius, paused: paused, noSession: sessionWidgetModel.session == null,),
        )
      )
      ..add(new Align(
          alignment:new FractionalOffset(0.5, 0.6),
          child: 
          new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                new Text(sessionTimeFormat.format(new DateTime.fromMillisecondsSinceEpoch(elapsedTime)),style: sessionTimeTextStyle,),
                new Text(currentTimeFormat.format(new DateTime.now()),style: currentTimeTextStyle,),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text(sessionState,style: currentTimeTextStyle,),
                )
            ],
          ),
        )
      )
      ..add(new Align(
          alignment: new FractionalOffset(0.0, 1.0),
          child: new Material(
            child: new ButtonBar(
              alignment: MainAxisAlignment.center ,
              children: <Widget>[
                new FlatButton(
                  onPressed: () => sessionController.add(sessionFactory.longPomodoro()),
                  child:  new Text('Add Long')),
                new FlatButton(
                  onPressed: () => sessionController.add(sessionFactory.shortPomodoro()),
                  child:  new Text('Add Short')),

                new FlatButton(
                  onPressed: () => sessionController.clearSchedule(),
                  child:  new Text('Clear')),
              ],
            ),
          )
        )
      );
      if(sessionWidgetModel.session != null) {
          children.add(new Transform(
            transform:
                new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
            child: new SessionDigit(
              radius: radius,
              elapsedTime: elapsedTime,
              startTime: startTime,
              sessionWidgetModel: sessionWidgetModel,
            ),
          )
      )
    ;

      }
         return new Stack(children: children);
    
}

  VoidCallback _getCentralButtonOnTapListener() {
    return sessionWidgetModel.session == null ? null : onTapListener;
  }
}
