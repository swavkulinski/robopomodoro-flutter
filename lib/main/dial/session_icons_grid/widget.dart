import 'package:flutter/widgets.dart';
import '../../di/main_module.dart';
import '../dragable_icon/widget.dart';
import '../../session_state/session_state_delegate.dart';

class SessionIconsGrid extends StatelessWidget {

    final Size size;
    final Size iconSize;

    SessionIconsGrid ({
      Key key,
      this.size,
      this.iconSize,
    }):
    assert(size != null),
    assert(iconSize != null),
    super(key : key);

    @override
  Widget build(BuildContext context) => new Column(children: [
        new Text(
          "Sessions",
          style: defaultTextStyle,
        ),
        new Container(
            width: size.width,
            height: 200.0,
            child: new GridView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              padding: new EdgeInsets.all(10.0),
              children: <Widget>[
                new DragableIcon(
                    session: sessionFactory.longPomodoro(), iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.shortPomodoro(),
                    iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.firstCoffee(), iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.secondCoffee(), iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.thirdCoffee(), iconSize: iconSize),
              ],
            ))
      ]);

}

