import 'package:tile/Block.dart';
import 'package:tile/Board.dart';
import 'package:tile/Coordinate.dart';
import 'package:tile/PieceProcess.dart';
import 'package:tile/Utils.dart';

class Grid {
  List<List<int>> _a;
  int boardSize;
  int deadNumB = 0; //被吃掉的黑子数
  int deadNumW = 0; //被吃掉的白子数

  Grid(int boardSize) {
    this.boardSize = boardSize;
    _a = List<List<int>>(boardSize);

    for (int i = 0; i < boardSize; i++) {
      _a[i] = List<int>(boardSize);
      for (int j = 0; j < boardSize; j++) {
        _a[i][j] = 0;
      }
    }
  }

  List<List<int>> get a {
    return _a;
  }

  int getValue(Coordinate c) {
    return a[c.x - 1][c.y - 1];
  }

  void setValue(Coordinate c, int value) {
    a[c.x - 1][c.y - 1] = value;
  }

  ///执行棋子过程 p：行棋记录 reverse：是否反悔行棋
  void executePieceProcess(PieceProcess p, bool reverse) {
    if (p.c.x == 0 || p.c.y == 0) return;

    if (!reverse) {
      // 非悔棋，即正常行棋。落子后，对应位置标记为黑子或白字，同时，被迟掉的子置为NONE（空白）。
      setValue(p.c, p.bw);
      for (PieceProcess pp in p.removedList) {
        setValue(pp.c, Board.None);
      }
      if (p.removedList.length > 0) {
        switch (p.bw) {
          case 1:
            deadNumW += p.removedList.length;
            break;
          case 2:
            deadNumB += p.removedList.length;
            break;
        }
      }
    } else {
      // 悔棋。当前子设置为NONE（空白），被踢掉的子恢复状态。
      for (PieceProcess pp in p.removedList) {
        setValue(pp.c, pp.bw);

        switch (p.bw) {
          case 1:
            deadNumW--;
            break;
          case 2:
            deadNumB--;
            break;
        }
      }
      setValue(p.c, Board.None);
    }
  }

  /// 落子
  bool putPiece(PieceProcess piece) {
    // 先检查坐标是否有效，无效直接返回false
    if (!piece.c.isValid()) return false;

    // 检查档期坐标点是否已经有子，如果有子，则落子无效，直接返回false;
    if (getValue(piece.c) != Board.None) return false;

    setValue(piece.c, piece.bw);
    startPick(piece.c, piece.bw, piece.removedList);

    // 若果落子后会自杀，则返回false
    if (isSuicide(piece.c, piece.bw)) {
      setValue(piece.c, Board.None); // 还原回来
      return false;
    }

    piece.resultBlackCount = getPieceCount(Board.Black);
    piece.resultWhiteCount = getPieceCount(Board.White);

    return true;
  }

  /// 统计盘面棋子数量
  int getPieceCount(int bw) {
    int c = 0;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (a[i][j] == bw) {
          c++;
        }
      }
    }
    return c;
  }

  /// 判断落子会不会直接杀死自己
  bool isSuicide(Coordinate c, int bw) {
    List<List<bool>> v = new List(boardSize);
    for (int i = 0; i < boardSize; i++) {
      v[i] = List<bool>(boardSize);
      for (int j = 0; j < boardSize; j++) {
        v[i][j] = false;
      }
    }

    Block block = new Block(bw);
    pick(c, v, bw, block);

    return !block.isLive();
  }

  // ------------------------------------------------------------------提子

  void startPick(Coordinate c, int bw, List<PieceProcess> removedList) {
    int reBw = Utils.getReBW(bw);
    pickOther(c, reBw, removedList);

    if (removedList!=null && removedList.length > 0) {
      Board.hasPickother = true;
      switch (bw) {
        case 1:
          deadNumW += removedList.length;
          break;
        case 2:
          deadNumB += removedList.length;
          break;
      }
    }
    // pickSelf(c, bw, removedList);
  }

  void pickOther(Coordinate c, int bw, List<PieceProcess> removedList) {
    List<List<bool>> v = new List(boardSize);
    for (int i = 0; i < boardSize; i++) {
      v[i] = List<bool>(boardSize);
      for (int j = 0; j < boardSize; j++) {
        v[i][j] = false;
      }
    }
    for (int i = 0; i < 4; i++) {
      Coordinate nc = c.getNear(i);
      Block block = new Block(bw);
      pick(nc, v, bw, block);

      if (!block.isLive()) {
        deleteBlock(block, removedList);
      }
    }
  }

  /// 递归构造为块
  void pick(Coordinate c, List<List<bool>> v, int bw, Block block) {
    if (c == null) return;
    if (v[c.x - 1][c.y - 1] == true) return;

    if (getValue(c) == Board.None) {
      block.addAir(1);
      return;
    } else if (getValue(c) != bw) {
      return;
    }

    v[c.x - 1][c.y - 1] = true;
    block.add(c);

    for (int i = 0; i < 4; i++) {
      Coordinate nc = c.getNear(i);
      pick(nc, v, bw, block);
    }
  }

  void deleteBlock(Block block, List<PieceProcess> removedList) {
    block.each(([obj1,obj2,obj3]) {
      Coordinate c = obj1;
      a[c.x - 1][c.y - 1] = Board.None;
      removedList.add(new PieceProcess(block.bw, c, List<PieceProcess>()));
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Grid &&
              runtimeType == other.runtimeType &&
              equalsList(_a,other._a);

  @override
  int get hashCode => _a.hashCode;

  bool equalsList(List<List<int>> a,List<List<int>> b){
    for (int j = 0; j < boardSize; j++) {
      for (int i = 0; i < boardSize; i++) {
        if (a[j][i] != b[j][i])
          return false;
      }
    }
    return true;
  }
}
