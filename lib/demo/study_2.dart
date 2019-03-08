import 'package:flutter/material.dart';

///路由
void main() {
  runApp(MyApp());
}

const String PAGE_2 = "/page2";
const String PAGE_3 = "/page3";

final Map<String, Function> _routes = {
  PAGE_2: (context, {arguments}) => Page2(arguments: arguments),
  PAGE_3: (context, {arguments}) => Page3(arguments: arguments),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      routes: _routes,
      home: Page1(),
      onGenerateRoute: (routeSetting) {
        Function _routeGenerate = _routes[routeSetting.name];
        if (_routeGenerate != null)
          return MaterialPageRoute(
              builder: (context) =>
                  _routeGenerate(context, arguments: routeSetting.arguments));
      },
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Page1 build');
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                print('Page1 push Page2');
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Page2()))
                    .then((value) {
                  print('Page1 push result: $value');
                });
              },
              child: Text("push"),
            ),
            RaisedButton(
              onPressed: () {
                print('Page1 pushNamed Page2');
                Navigator.pushNamed(context, PAGE_2,
                    arguments: {"name": "lili"}).then((value) {
                  print('Page1 pushNamed result: $value');
                });
              },
              child: Text("pushNamed"),
            ),
            RaisedButton(
              onPressed: () {
                print('Page1 push Page2 with anim');
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Page2();
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 1.0)
                                  .animate(animation),
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500)));
              },
              child: Text("push with anim"),
            ),
            RaisedButton(
              onPressed: () {
                print('Page1 showDialog');
                showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Dismiss",
                    barrierColor: Color.fromRGBO(255, 0, 0, 0.5),
                    transitionDuration: Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return AlertDialog(
                        title: Text("标题"),
                      );
                    });
              },
              child: Text("showDialog"),
            ),
            Text("Page1")
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  Map<String, Object> arguments;

  Page2({this.arguments});

  @override
  Widget build(BuildContext context) {
    print('Page2 build');
    print('arguments:$arguments');
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                print('Page2 push Page3');
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Page3()));
              },
              child: Text("push"),
            ),
            RaisedButton(
              onPressed: () {
                print('Page2 pushReplacement Page3  and result: Page2 result');
                Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Page3()),
                        result: "Page2 result")
                    .then((value) {
                  print('Page2 pushReplacement result: $value');
                });
              },
              child: Text("pushReplacement"),
            ),
            RaisedButton(
              onPressed: () {
                print('Page2 pushAndRemoveUntil Page3');
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => Page3()),
                    (route) {
                  print('route:$route');
                  return route.settings.name == "/";
                }).then((value) {
                  print('Page2 pushAndRemoveUntil result: $value');
                });
              },
              child: Text("pushAndRemoveUntil"),
            ),
            Hero(
                tag: "btnBack",
                child: RaisedButton(
                  onPressed: () {
                    print('Page2 pop');
                    Navigator.pop(context);
                  },
                  child: Text("返回"),
                )),
            Text("Page2 arguments:$arguments")
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  Map<String, Object> arguments;

  Page3({this.arguments});

  @override
  Widget build(BuildContext context) {
    print('Page3 build');
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Hero(
                tag: "btnBack",
                child: RaisedButton(
                  onPressed: () {
                    print('Page3 pop');
                    Navigator.pop(context);
                  },
                  child: Text("返回"),
                )),
            Text("Page3")
          ],
        ),
      ),
    );
  }
}
