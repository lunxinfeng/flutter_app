import 'package:tile/Board.dart';
import 'package:tile/Coordinate.dart';
import 'package:tile/PieceProcess.dart';

class SgfHelper {
  static List<Coordinate> getCoordListformStr(String str) {
    List<Coordinate> cs = List<Coordinate>();
    if (str == "") return cs;

    int MaxX = (str.length / 5).floor();
    String ns = "";

    for (int i = 0; i < MaxX; i++) {
      ns = str.substring(i * 5, (i + 1) * 5); // 5位为1手

      /**
       * 此行改动，为实现题库标记，李朦利3-8  增加'l'判断,表示题库标记位
       */
      if (ns.length == 5 &&
          (ns[0] == '+' || ns[0] == '-' || ns[0] == 'l')) {
        int x = int.parse(ns.substring(1, 3));
        int y = int.parse(ns.substring(3, 5));
        int bw;
//				String bwstr = ns.substring(0, 1);
        if (ns.substring(0, 1) == "+") {
          bw = 1;
        } else if (ns.substring(0, 1) == "-") {
          bw = 2;
        } else {
          bw = 3;
        }

        Coordinate c = Coordinate.createNoSize(y, x, bw); // 为了兼容电脑客户端
        cs.add(c);
      }
    }

    return cs;
  }

  static String getBoardlastStr(Board b) {
    if (b.getCount() == 0) return "";
    String resStr = "";
    int StepCount = b.getCount() - 1;

    PieceProcess p = b.getPieceProcess(StepCount);
    resStr = resStr +
        mygopw2String(p.bw) +
        mygoint2String(p.c.y) +
        mygoint2String(p.c.x);

    return resStr;
  }

  static String mygopw2String(int bw) {
    if (bw == Board.Black) return "+";
    if (bw == Board.White) return "-";
    return "X";
  }

  static String mygoint2String(int a) {
    if (a >= 10) {
      return a.toString();
    } else {
      return "0" + a.toString();
    }
  }
}
