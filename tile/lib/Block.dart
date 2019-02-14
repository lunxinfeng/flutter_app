import 'package:tile/Coordinate.dart';
import 'package:tile/Function.dart';

class Block {
  List<Coordinate> block = List<Coordinate>();
  int _airCount = 0; //气数
  int _bw; //颜色

  Block(this._bw);

  int get bw {
    return _bw;
  }

  void add(Coordinate c) {
    block.add(c);
  }

  void addAir(int air) {
    _airCount += air;
  }

  bool isLive() {
    if (_airCount > 0 && block.length > 0) return true;
    return false;
  }

  void each(Func f) {
    for (Coordinate c in block) {
      f(c);
    }
  }
}
