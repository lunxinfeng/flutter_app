library tile;

import 'package:flutter/material.dart';
import 'package:tile/Function.dart';
import 'package:tile/LayerBackground.dart';
import 'package:tile/LayerChess.dart';

class TileView extends StatelessWidget {
  int boardSize;
  Func tileListener;
  GlobalKey<LayerChessState> keyChess;

  TileView({
    this.keyChess,
    this.boardSize = 19,
    this.tileListener
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        textDirection: TextDirection.ltr,
        fit: StackFit.expand,
        children: <Widget>[
          RepaintBoundary(
            child: LayerBackground(boardSize),
          ),
          LayerChess(
            keyChess: keyChess,
            boardSize: boardSize,
            tileListener: tileListener,
          )
        ],
      ),
    );
  }
}
