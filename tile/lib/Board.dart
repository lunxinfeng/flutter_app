import 'package:tile/Coordinate.dart';
import 'package:tile/Function.dart';
import 'package:tile/Grid.dart';
import 'package:tile/PieceProcess.dart';
import 'package:tile/SubBoard.dart';
import 'package:tile/Utils.dart';

class Board {
  static const int None = 0;
  static const int Black = 1;
  static const int White = 2;
  static const int FLAG = 3;
  static bool hasPickother = false;

  int n;
  int goType = 0; // 0:正常；1：连续黑；2：连续白
  // 行棋记录
  List<PieceProcess> list = new List<PieceProcess>();

  Grid currentGrid;

  int expBw = Black; // 轮到哪一方下
  Func listener;

  Board(int _boardSize) {
    this.n = _boardSize;
    this.currentGrid = new Grid(n); // 当前盘面
  }

  int getBoardSize() => n;

  void setGoType(int goType) {
    this.goType = goType;

    if (goType == 1) {
      expBw = Black;
    } else if (goType == 2) {
      expBw = White;
    }
  }

  bool put(int x, int y, int boardSize) {
    Coordinate c = new Coordinate.create(x, y, boardSize);
    PieceProcess p = new PieceProcess.create(expBw, c);
    // 执行虚步，停一手。
    if (x == 0 && y == 0) {
      list.add(p);
      finishedPut();
      return true;
    }

    if (currentGrid.putPiece(p)) {
      if (!check(p)) {
        currentGrid.executePieceProcess(p, true); // 返回一步
        return false;
      }

      list.add(p);
      finishedPut();
      return true;
    }
    return false;
  }

  // 预落子，检验是否合法
  bool prePut(int x, int y, int boardSize) {
    Coordinate c = new Coordinate.create(x, y, boardSize);
    PieceProcess p = new PieceProcess.create(expBw, c);

    if (currentGrid.putPiece(p)) {
      if (!check(p)) {
        currentGrid.executePieceProcess(p, true); // 返回一步

        return false;
      }

      currentGrid.executePieceProcess(p, true); // 返回一步
      return true;
    }
    return false;
  }

  void finishedPut() {
    if (goType == Board.Black) {
      expBw = Board.Black;
    } else if (goType == Board.White) {
      expBw = Board.White;
    } else {
      expBw = Utils.getReBW(expBw);
    }

    postEnvet();
  }

  // 打劫检测
  bool check(PieceProcess p) {
    // System.out.println(list.size());

    if (list.length < 3) return true;
    if (isOverEqualse(list.length - 2, p)) return false; // 盘面与上上一手比较，看是否同型

    return true;
  }

  bool isOverEqualse(int position, PieceProcess p) {
    // System.out.println(position);
    Board sb = getSubBoard(position + 1);
//     return sb.currentGrid.equals(this.currentGrid);
    return sb.currentGrid == this.currentGrid;
  }

  SubBoard getSubBoard(int index) {
    SubBoard board = new SubBoard(this, n);
    board.gotoIt(index);
    return board;
  }

  void cleanGrid(int boardSize) {
    this.currentGrid = new Grid(boardSize);
  }

  void addPieceProcess(PieceProcess p) {
    currentGrid.executePieceProcess(p, false);
    list.add(p);
    finishedPut();
  }

  void removePieceProcess() {
    if (list.isEmpty)
      return;
    PieceProcess p = list.removeAt(getCount() - 1);
    currentGrid.executePieceProcess(p, true);
    finishedPut();
  }


  int getValue(int x, int y) {
    return currentGrid.getValue(new Coordinate.create(x, y,n));
  }

  void postEnvet() {
    if (listener == null)
      return;
    listener(getCount(), expBw);
  }

  void setListener(Function listener) {
    this.listener = listener;
  }

  Coordinate getLastPosition() {
    if (getCount() == 0)
      return null;
    return list[getCount() - 1].c;
  }

  int getCount() {
    return list.length;
  }

  PieceProcess getPieceProcess(int i) {
    if (i >= getCount())
      return null;
    return list[i];
  }

  String getCurBW() {
    if (expBw == Black)
      return "+";
    return "-";
  }

  ///0:正常一黑一白模式;1:连续黑子;2:连续白子
  void setCurBW(int curBW) {
    expBw = curBW;
  }

  List<PieceProcess> getList(){
    return list;
  }
}
