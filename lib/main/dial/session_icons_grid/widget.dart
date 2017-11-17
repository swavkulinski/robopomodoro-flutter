import 'package:flutter/widgets.dart';
import '../../di/main_module.dart';
import '../dragable_icon/widget.dart';

class SessionIconsGrid extends StatelessWidget {
  final Size size;
  final Size iconSize;


  SessionIconsGrid({
    Key key,
    this.size,
    this.iconSize,
  })
      : assert(size != null),
        assert(iconSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => new Column(children: [
        new Text(
          "Sessions",
          style: defaultTextStyle,
        ),
        new Container(
          width: size.width,
          height: 200.0,
          child: new GridView.builder(
            itemCount: sessionTemplates.length,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            padding: new EdgeInsets.all(10.0),
            itemBuilder: (context,index) => new SizedBox(width: 30.0,height: 30.0, child: new DragableIcon(
              session: sessionTemplates[index], iconSize: iconSize,
            ),),
          ),
        ),
      ]);
}
