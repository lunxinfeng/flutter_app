import 'package:flutter/material.dart';

///路由
void main() {
  runApp(MyApp());
}

const String PAGE_2 = "/page2";

final Map<String, WidgetBuilder> _routes = {
  PAGE_2: (_) => Page2(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: _routes, home: Page1());
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
            Text("Page1")
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Page2 build');
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
                print(
                    'Page2 pushAndRemoveUntil Page3');
                Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Page3()),
                        (route) {
                          print('route:$route');
                          return route.settings.name == "/";
                        })
                    .then((value) {
                  print('Page2 pushAndRemoveUntil result: $value');
                });
              },
              child: Text("pushAndRemoveUntil"),
            ),
            RaisedButton(
              onPressed: () {
                print('Page2 pop');
                Navigator.pop(context);
              },
              child: Text("返回"),
            ),
            Text("Page2")
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
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
            RaisedButton(
              onPressed: () {
                print('Page3 pop');
                Navigator.pop(context);
              },
              child: Text("返回"),
            ),
            Text("Page3")
          ],
        ),
      ),
    );
  }
}
