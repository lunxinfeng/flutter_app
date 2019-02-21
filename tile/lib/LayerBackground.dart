import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tile/Coordinate.dart';
import 'package:tile/Utils.dart';

class LayerBackground extends StatefulWidget {
  int boardSize;

  LayerBackground(this.boardSize);

  @override
  State<StatefulWidget> createState() {
    return LayerBackgroundState();
  }
}

class LayerBackgroundState extends State<LayerBackground> {
  @override
  Widget build(BuildContext context) {
    print('layer background build');
    return CustomPaint(
      painter: LayerBackgroundUI(widget.boardSize),
    );
  }
}

class LayerBackgroundUI extends CustomPainter {
  double _width;
  double _tileSize;
  double _xOffset;
  double _yOffset;
  int boardSize;

  LayerBackgroundUI(this.boardSize);

  Paint _paintBg = Paint()
    ..color = Colors.yellow //画笔颜色
    ..strokeWidth = 15.0;
  Paint _paintBlack = Paint()..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    print('background size：$size');
    if (_width == null) {
      _width = min(size.width, size.height);
    }
    if (_tileSize == null) {
      _tileSize = _width / (boardSize + 1);
      _xOffset = _tileSize * 1;
      _yOffset = _tileSize * 1;
    }
    drawBackground(canvas, _width);
    drawLines(canvas, _width);
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
    double starSize = boardSize <= 9 ? _tileSize / 10 : _tileSize / 8;
    for (Coordinate c in Utils.createStar(boardSize)) {
      if (c != null) {
        canvas.drawOval(
            Rect.fromCircle(
                center: Offset(x2Screen(c.x), y2Screen(c.y)), radius: starSize),
            _paintBlack);
      }
    }
  }

  void drawCoordinate(Canvas canvas) {
    for (int i = 1; i <= boardSize; i++) {
      TextSpan textSpan = TextSpan(
          style: TextStyle(color: Colors.black, fontSize: _tileSize * 2 / 5),
          text: getAlpha(i - 1));
      TextPainter textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      //x
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(_tileSize * (i - 1) + _xOffset - textPainter.width / 2,
              (_yOffset - textPainter.height) / 2));

      textSpan = TextSpan(
          style: TextStyle(color: Colors.black, fontSize: _tileSize * 2 / 5),
          text: (boardSize - i + 1).toString());
      textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      //y
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset((_xOffset - textPainter.width) / 2,
              _tileSize * (i - 1) + _yOffset - textPainter.height / 2));
    }
  }

  String getAlpha(int i) {
    String list = "ABCDEFGHIJKLMNOPQRS";
    return list[i];
  }

  double x2Screen(int x) {
    return (x - 1) * _tileSize + _xOffset;
  }

  double y2Screen(int y) {
    return (boardSize - y) * _tileSize + _xOffset;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
