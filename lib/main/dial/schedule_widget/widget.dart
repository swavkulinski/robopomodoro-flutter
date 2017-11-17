import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../di/main_module.dart';
import '../../../app/models.dart';
import '../clear_schedule_button/widget.dart';
import '../../session_state/session_state_delegate.dart';
import '../../session_icon/session_icon.dart';

class ScheduleWidget extends StatelessWidget {
  final Size size;
  final Size iconSize;
  final DateTime scheduleEnds;
  final SessionStateDelegate sessionController;

  ScheduleWidget({
    Key key,
    this.size,
    this.iconSize,
    this.scheduleEnds,
    this.sessionController,
  })
      : assert(size != null),
        assert(iconSize != null),
        assert(scheduleEnds != null),
        assert(sessionController != null),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      new DragTarget<Session>(onWillAccept: (session) {
        return true;
      }, onAccept: (session) {
        sessionController.add(session);
      }, builder: (context, candidate, rejected) {
        return new Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 0.0),
          child: new Card(
            child: new Column(children: [
              new Text(
                _yourScheduleEnds(scheduleEnds),
                style: defaultTextStyle,
              ),
              new Stack(
                children: <Widget>[
                  new Container(
                    constraints: new BoxConstraints.loose(
                        new Size(size.width, size.height / 2)),
                    child: new GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemCount: sessionController.getSchedule().length,
                      itemBuilder: (context, index) => new SizedBox(width:30.0,height:30.0, child:new Padding(
                            padding: Paddings.ALL_8,
                            child: new SessionIcon(
                              onClick: () {},
                              session: sessionController.getCurrentSession(),
                              size: iconSize,
                              shadowPaint: PomodoroPaints.shadowPaint,
                            ),
                          ),),
                    ),
                  ), //),
                  new Container(
                    constraints: new BoxConstraints.loose(
                        new Size(size.width, size.height / 2)),
                    child: new Align(
                      alignment: new Alignment(0.0, 1.0),
                      child: new ClearScheduleButton(
                          callback: () => sessionController.clearSchedule()),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      });

  String _yourScheduleEnds(startTime) {
    if (sessionController.getSchedule() == null ||
        sessionController.getSchedule().length == 0) {
      return "Your schedule";
    } else {
      var scheduleEnd = currentTimeFormat.format(startTime.add(new Duration(
          milliseconds: sessionController
              .getSchedule()
              .map((session) => session.length())
              .reduce((i, c) => i += c))));
      return "Your schedule ends $scheduleEnd";
    }
  }
}
