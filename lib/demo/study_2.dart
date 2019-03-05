import 'package:flutter/material.dart';

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
    return MaterialApp(
        routes: _routes,
        home: Page1()
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => Page2()));
              },
              child: Text("下一页，无参"),
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
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Page3()));
              },
              child: Text("下一页"),
            ),
            RaisedButton(
              onPressed: (){
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
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
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