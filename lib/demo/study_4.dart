
import 'package:flutter/material.dart';

///动画
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State createState() {
    return _AnimationState();
  }
}

class _AnimationState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: 100,
      height: 100,
    );
  }
}