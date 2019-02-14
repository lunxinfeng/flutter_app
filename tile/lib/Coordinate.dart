class Coordinate{
  int x;
  int y;
  int bw;
  int _boardSize;
  List<Coordinate> _near;

  final _up = 0;
  final _down = 1;
  final _right = 2;
  final _left = 3;

  Coordinate(this.x, this.y, this.bw, this._boardSize);

  Coordinate.create(this.x, this.y, this._boardSize);

  Coordinate up(){
    Coordinate c = Coordinate.create(x, y - 1,_boardSize);
    return c.isValid() ? c : null;
  }
   Coordinate down() {
    Coordinate c = Coordinate.create(x, y + 1,_boardSize);
    return c.isValid() ? c : null;
  }

   Coordinate right() {
    Coordinate c = Coordinate.create(x + 1, y,_boardSize);
    return c.isValid() ? c : null;
  }

   Coordinate left() {
    Coordinate c = Coordinate.create(x - 1, y,_boardSize);
    return c.isValid() ? c : null;
  }

   void initNear() {
    if (_near == null) {
      _near = List(4);
      _near[_up] = up();
      _near[_down] = down();
      _near[_right] = right();
      _near[_left] = left();
    }
  }

  Coordinate getNear(int direction) {
    initNear();
    return _near[direction];
  }


  bool isValid() {
    if (x == 0 && y == 0)
      return true;

    if (x < 1)
      return false;
    if (y < 1)
      return false;
    if (x > _boardSize)
      return false;
    if (y > _boardSize)
      return false;
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Coordinate &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

  @override
  int get hashCode =>
      x.hashCode ^
      y.hashCode ^
      bw.hashCode;

}