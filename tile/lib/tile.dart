library tile;

import 'package:flutter/material.dart';
import 'package:tile/LayerBackground.dart';
import 'package:tile/LayerChess.dart';

class TileView extends StatelessWidget {
  int boardSize;

  TileView({this.boardSize = 19});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      textDirection: TextDirection.ltr,
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary(
          child: LayerBackground(boardSize),
        ),
        LayerChess(
          keyChess: GlobalKey(),
          boardSize: boardSize,
        )
      ],
    );
  }
}
