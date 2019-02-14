import 'package:flutter/material.dart';
import 'package:tile/tile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(20),
      color: Color.fromARGB(255, 255, 255, 255),
      child: AspectRatio(aspectRatio: 1/10,child: TileView()),
    );
  }
}