import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ///我们需要在build函数中构建出我们的UI
  @override
  Widget build(BuildContext context) {
    Image _logo = Image.network(
        "https://upload.jianshu.io/users/upload_avatars/1215918/b54de985d456.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/300/h/300/format/webp");
    Text _textAccount = Text(
      "账号：",
      textDirection: TextDirection.ltr,
      style: TextStyle(color: Colors.pink, fontSize: 14),
    );
    Text _textPassword = Text(
      "密码：",
      textDirection: TextDirection.ltr,
      style: TextStyle(color: Colors.pink, fontSize: 14),
    );
    TextField _textFieldAccount = TextField(
      decoration: InputDecoration(hintText: "请输入账号"),
    );
    TextField _textFieldPassword = TextField(
      decoration: InputDecoration(hintText: "请输入密码"),
    );
    RaisedButton _buttonLogin = RaisedButton(
      onPressed: () => {},
      child: Text("登陆"),
    );

    return MaterialApp(
        home: Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logo,
            Row(
              children: <Widget>[
                _textAccount,
                Expanded(child: _textFieldAccount)
              ],
            ),
            Row(
              children: <Widget>[
                _textPassword,
                Expanded(child: _textFieldPassword)
              ],
            ),
            _buttonLogin,
          ],
        ),
      ),
    ));
  }
}
