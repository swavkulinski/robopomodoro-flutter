import 'package:flutter/material.dart';
import 'package:Robopomodoro/di/di.dart';

class OnboardingWidget extends StatefulWidget {
  OnboardingWidget({Key key, this.onComplete, this.stateFactory}):
  assert(onComplete != null),
  assert(stateFactory != null),
  super(key:key);

  final Factory<OnboardingState> stateFactory;
  final VoidCallback onComplete;

  @override
  OnboardingState createState() => stateFactory();

}

class OnboardingState extends State<OnboardingWidget> {

  PageController _pageController;

  OnboardingState(this._pageController);

  var _previousEnabled = false;
  var _nextEnabled = true;

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new Expanded(
        child: new PageView(
          children: <Widget>[
            new Material(child: new Center(child: new Text('Page 0'))),
            new Material(child: new Center(child: new Text('Page 1'))),
            new Material(child: new Center(child: new Text('Page 2'))),
          ],
          controller: _pageController,
          onPageChanged: (index){
            setState((){
              _previousEnabled = index != 0;
              _nextEnabled = index != 2;
            });
          }
        ),
      ),
      new Material(child:new ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        new IconButton(icon: new Icon(Icons.arrow_back),onPressed:_handleOnPreviousPressed()),
        new IconButton(icon: new Icon(Icons.arrow_forward),onPressed:_handleOnNextPressed()),
      ])),
    ]);
  }

  VoidCallback _handleOnPreviousPressed (){
    if(_previousEnabled){
      return ()=>_pageController.previousPage(duration: new Duration(milliseconds: 400),curve: Curves.easeOut);
    }else {
      return null;
    }
  }

  VoidCallback _handleOnNextPressed () {
    if(_nextEnabled){
      return ()=>_pageController.nextPage(duration: new Duration(milliseconds: 400),curve: Curves.easeOut);
    } else {
      return (){
        widget.onComplete();
        Navigator.of(context).pushReplacementNamed('/home');
      };
    }
  }
}
