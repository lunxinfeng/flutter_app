import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tile/Coordinate.dart';
import 'package:tile/Utils.dart';
import 'package:tile/tile.dart';

class LayerBackground extends StatefulWidget {
  GlobalKey _myKey;

  LayerBackground(this._myKey);

  @override
  State<StatefulWidget> createState() {
    return LayerBackgroundState(_myKey);
  }
}

class LayerBackgroundState extends State<LayerBackground>{
  GlobalKey _myKey;

  LayerBackgroundState(this._myKey);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LayerBackgroundUI(),
      key: _myKey,
    );
  }
}

//class LayerBackground extends StatelessWidget {
//  GlobalKey _myKey;
//
//  LayerBackground(this._myKey);
//
//  @override
//  Widget build(BuildContext context) {
//    return CustomPaint(
//      painter: LayerBackgroundUI(),
//      key: _myKey,
//    );
//  }
//}

class LayerBackgroundUI extends CustomPainter {
  double width;
//  double tileSize;
//  double xOffset;
//  double yOffset;
//  int boardSize = 19;
  Paint _paintBg = Paint()
    ..color = Colors.yellow //画笔颜色
//    ..strokeCap = StrokeCap.round//画笔笔触类型
//    ..isAntiAlias = true//是否启动抗锯齿
//    ..style=PaintingStyle.fill//绘画风格，默认为填充
//    ..blendMode=BlendMode.exclusion//颜色混合模式
//    ..colorFilter=ColorFilter.mode(Colors.blueAccent, BlendMode.exclusion)//颜色渲染模式，一般是矩阵效果来改变的，但是flutter中只能使用颜色混合模式
//    ..maskFilter=MaskFilter.blur(BlurStyle.inner, 3.0)//模糊遮罩效果，flutter中只有这个
//    ..filterQuality=FilterQuality.high//颜色渲染模式的质量
    ..strokeWidth = 15.0;
  Paint _paintBlack = Paint()..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    print('background size：$size');
    if (width == null) {
      width = min(size.width, size.height);
    }
    if (tileSize == null) {
      tileSize = width / (boardSize + 1);
      xOffset = tileSize * 1;
      yOffset = tileSize * 1;
    }
    drawBackground(canvas, width);
    drawLines(canvas, width);
    drawStars(canvas);
    drawCoordinate(canvas);
  }

  void drawBackground(Canvas canvas, double width) {
    canvas.drawRect(Rect.fromLTWH(0, 0, width, width), _paintBg);
  }

  void drawLines(Canvas canvas, double width) {
    for (int i = 1; i < boardSize + 1; i++) {
      canvas.drawLine(Offset(x2Screen(1), y2Screen(i)),
          Offset(x2Screen(boardSize), y2Screen(i)), _paintBlack);
      canvas.drawLine(Offset(x2Screen(i), y2Screen(1)),
          Offset(x2Screen(i), y2Screen(boardSize)), _paintBlack);
    }
  }

  void drawStars(Canvas canvas) {
    double starSize = boardSize <= 9 ? tileSize / 10 : tileSize / 8;
    for (Coordinate c in Utils.createStar(boardSize)) {
      if(c!=null){
        canvas.drawOval(Rect.fromCircle(center: Offset(x2Screen(c.x), y2Screen(c.y)),radius: starSize), _paintBlack);
      }
    }
  }

  void drawCoordinate(Canvas canvas) {
    for(int i = 1; i <= boardSize; i++){
      TextSpan textSpan = TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 8
        ),
        text: getAlpha(i-1)
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr
      );
      //x
      textPainter.layout();
      textPainter.paint(canvas, Offset(tileSize * (i - 1.25) + xOffset, yOffset / 4));

      textSpan = TextSpan(
          style: TextStyle(
              color: Colors.black,
              fontSize: 8
          ),
          text: (boardSize - i + 1).toString()
      );
      textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr
      );
      //y
      textPainter.layout();
      textPainter.paint(canvas, Offset(xOffset / 4, tileSize * (i - 1.25) + yOffset));
    }
  }

  String getAlpha(int i) {
    String list = "ABCDEFGHIJKLMNOPQRS";
    return list[i];
  }

  double x2Screen(int x) {
    return (x - 1) * tileSize + xOffset;
  }

  double y2Screen(int y) {
    return (boardSize - y) * tileSize + xOffset;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
