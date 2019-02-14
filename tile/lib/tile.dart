library tile;

import 'package:flutter/material.dart';
import 'package:tile/Board.dart';
import 'package:tile/LayerBackground.dart';

double tileSize;
double xOffset;
double yOffset;
int boardSize = 19;

class TileView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TileViewState();
  }
}

class TileViewState extends State<TileView> {
  GlobalKey _keyBg = GlobalKey();
  bool boardUnlock = true;
  Board board;
  double startX;//左上角x坐标
  double startY;//左上角y坐标

  int putType = 0;

  @override
  void initState() {
    board = Board(boardSize);
    print('initState');
  }

  void onTapUp(TapUpDetails event) {
    print('onTapUp：${event.globalPosition}');
    if (!boardUnlock) return;
    if(startX == null || startY == null){
      RenderBox renderBox = _keyBg.currentContext.findRenderObject();
      Offset offset = renderBox.localToGlobal(Offset.zero);
      print('start coordinate:$offset');
      startX = offset.dx;
      startY = offset.dy;
    }
    int x = x2Coordinate(event.globalPosition.dx - startX);
    int y = y2Coordinate(event.globalPosition.dy - startY);

    if (x == 0 || x > boardSize || y == 0 || y > boardSize) return;

    // 自信模式，直接落子
    if (putType == 0) {
      doPutPiece(x, y);
    } else if (putType == 2) {
//      topicx = x2Coordinate(xf + currentX);
//      topicy = y2Coordinate(yf + currentY);
//      TopicBank(topicx, topicy);
    } else {
      // 谨慎模式，预备落子
//      prePutPiece(x, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return GestureDetector(
        onTapUp: onTapUp,
        child: Container(
          child: CustomPaint(
            foregroundPainter: LayerChess(board),
            child: LayerBackground(_keyBg),
          ),
        ));
  }

  //  void removePiece(int x, int y) {
//    board.currentGrid.a[x - 1][y - 1] = 0;
//    for (int i = 0, n = board.getCount(); i < n; i++) {
//      PieceProcess p = board.getPieceProcess(i);
//      if (p.c.x == x && p.c.y == y) {
//        board.getList().remove(i);
//        break;
//      }
//    }
//    rePaintChess();
//  }

  void rePaintChess(){
    setState(() {

    });
  }

  bool doPutPiece(int x, int y) {
//    String c = board.getCurBW();
//    if (y < 10)
//      c += "0$y";
//    else
//      c += y.toString();
//    if (x < 10)
//      c += "0$x";
//    else
//      c += x.toString();

    Board.hasPickother = false;

    if (board.put(x, y, boardSize)) {
      print('doPutPiece：$x,$y');
      rePaintChess();
      return true;
    }

    return false;
  }

  int x2Coordinate(double x) {
    return ((x - xOffset) / tileSize).round() + 1;
  }

  int y2Coordinate(double y) {
    return boardSize - ((y - yOffset) / tileSize).round();
  }
}

class LayerChess extends CustomPainter {
  Board board;
  Paint _paintBlack = Paint()..color = Colors.black;
  Paint _paintWhite = Paint()..color = Colors.white;

  LayerChess(this.board);

  @override
  void paint(Canvas canvas, Size size) {
    print('chess size：$size');

    drawChess(canvas);
  }

  void drawChess(Canvas canvas){
    for(int x = 1;x<=boardSize;x++){
      for(int y = 1;y<=boardSize;y++){
        int bw = board.getValue(x, y);
        if(bw == Board.None) continue;
        switch(bw){
          case Board.Black:
            canvas.drawOval(Rect.fromCircle(center: Offset(x2Screen(x), y2Screen(y)),radius: tileSize/2), _paintBlack);
            break;
          case Board.White:
            canvas.drawOval(Rect.fromCircle(center: Offset(x2Screen(x), y2Screen(y)),radius: tileSize/2), _paintWhite);
            break;
        }
      }
    }
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
