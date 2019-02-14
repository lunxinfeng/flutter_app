import 'package:tile/Board.dart';
import 'package:tile/Coordinate.dart';

class Utils {
  static List<Coordinate> createStar(int boardSize) {
    List<Coordinate> cs = List(9);

    int star = 4;
    int dao3 = boardSize - 3;
    if (boardSize <= 9) {
      star = 3;
      dao3 = boardSize - 2;
    }

    cs[0] = Coordinate.create(star, star, boardSize);
    cs[1] = Coordinate.create(dao3, star, boardSize);
    cs[2] = Coordinate.create(star, dao3, boardSize);
    cs[3] = Coordinate.create(dao3, dao3, boardSize);

    int zhong = ((boardSize + 1) / 2).floor();

    if (boardSize > 9) {
      cs[4] = Coordinate.create(star, zhong, boardSize);
      cs[5] = Coordinate.create(zhong, star, boardSize);
      cs[6] = Coordinate.create(zhong, dao3, boardSize);
      cs[7] = Coordinate.create(dao3, zhong, boardSize);
    }

    cs[8] = Coordinate.create(zhong, zhong, boardSize);
    return cs;
  }

  static int getReBW(int bw) {
    if (bw == Board.White)
      return Board.Black;
    if (bw == Board.Black)
      return Board.White;

    return Board.Black;
  }
}
